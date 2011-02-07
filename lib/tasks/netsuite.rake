# 
# netsuite.rake
# online
# 
# Created by John Meredith on 2009-01-28.
# Copyright 2009 CDX Global. All rights reserved.
#
# TODO: Split this up into separate files?
#
namespace :netsuite do
  namespace :clients do
    desc "Update NetSuite IDs from the file given in FILE"
    task :update_customer_ids => :environment do
      raise "FILE required" if ENV['FILE'].blank?
  
      require "fastercsv"
      
      not_found = []
      
      FasterCSV.foreach(ENV['FILE'], :headers => :first_row) do |row|
        client_prefix = row['client_prefix']
        if client_prefix.size != 4
          next
        end
        
        begin
          client                      = Client.find(client_prefix)
          client.client_name          = row['name']
          client.netsuite_customer_id = row['netsuite_customer_id']
          client.save!
  
          puts "[INFO] [#{client.client_prefix}] #{client.client_name}"
        rescue ActiveRecord::RecordNotFound => e
          not_found << row
        rescue ActiveRecord::RecordInvalid => e
          puts client.errors.inspect
        end
      end
  
      unless not_found.blank?
        puts "\n"
        puts '=' * 72
        puts "The following records were not found:"
        puts '=' * 72
        not_found.each do |row|
          puts "\t[#{row['client_prefix']}] #{row['name']}"
        end
      end
    end
  end

  namespace :trials do
    # ========================================================================
    # Process trial user requests (new and extensions) from NetSuite into `auto`
    # instance
    # ------------------------------------------------------------------------
    desc "Process trial user requests (new and extensions) from NetSuite into `auto` instance"
    task :process => :environment do
      # Build our NetSuite search. We're looking for all trial request after
      # the last processed request
      trial_search = returning(NetSuite::SOAP::CustomRecordSearch.new) do |search|
        basic = NetSuite::SOAP::CustomRecordSearchBasic.new
        basic.recType = returning(NetSuite::SOAP::RecordRef.new("Trial System")) { |ref| ref.xmlattr_internalId = 23 }

        # If we have last run, use that to specify the date criteria
        if last_run = NetsuiteTrialRequest.last
          basic.internalIdNumber = returning(NetSuite::SOAP::SearchLongField.new(last_run.netsuite_id)) { |f| f.xmlattr_operator = NetSuite::SOAP::SearchLongFieldOperator::GreaterThan }
        end

        search.basic = basic
      end

      # Open an NetSuite session
      NetSuite.filter(nil) do |session|
        # Dump the request and response XML to screen in dev mode
        session.wiredump_dev = STDOUT if Rails.env.development?

        result = session.search(NetSuite::SOAP::SearchRequest.new(trial_search)).searchResult

        if result.status.xmlattr_isSuccess && !result.recordList.blank?
          all_records = result.recordList

          # FIXME: Seems there's a NS bug ... can't grab more than 5 contacts. Let's
          #        split them into groups then.
          all_records.in_groups_of(5, false) do |records|
            puts "[NetSuite:TrialUsers] Internal ID: #{records.map(&:xmlattr_internalId) * ','}"
            # Create our contacts fetch query 
            contact_refs = NetSuite::SOAP::GetListRequest.new
            records.each do |record|
              custom_fields = record.customFieldList.index_by(&:xmlattr_internalId)
              contact_refs << returning(NetSuite::SOAP::RecordRef.new) do |contact_ref|
                contact_ref.xmlattr_type       = NetSuite::SOAP::RecordType::Contact
                contact_ref.xmlattr_internalId = custom_fields['custrecord_ts_contact'].value.xmlattr_internalId
              end
            end

            # Fetch the associated contacts for each trial signup
            contacts_response = session.getList(contact_refs).readResponseList
            contacts = contacts_response.map(&:record).compact.index_by(&:xmlattr_internalId)

            client = Client.find_by_client_prefix!('auto')
            Moodle::Base.setup_tables_by_client(client)

            records.each_with_index do |record, i|
              custom_fields = record.customFieldList.index_by(&:xmlattr_internalId)

              contact = contacts[custom_fields['custrecord_ts_contact'].value.xmlattr_internalId]


              # Check the users table by NetSuite ID, then email otherwise assume a new user
              user = User.find_deleted_by_netsuite_id(client, contact.xmlattr_internalId)
              user = User.find_deleted_by_username(client, contact.email) if user.blank?
              user = client.users.new if user.blank?

              # Make sure we have a clean email address
              sanitized_email     = contact.email.gsub(/[^a-zA-Z0-9@.\-_]/, '')

              # Update the attributes with the NetSuite contact data
              user.username       = sanitized_email
              user.password       = user.password_confirmation = 'cdxdemo'
              user.email          = contact.email

              # NS users can't be taught to separate someone's name into 2 distinct parts apparently. 
              user.firstname      = contact.firstName || contact.lastName
              user.lastname       = contact.lastName  || contact.firstName

              user.role_shortname = 'student'
              user.client_id      = client.id

              # Now store the trial subscription details
              user.netsuite_contact_id = contact.xmlattr_internalId


              # Ensure the menu is v51 otherwise default to ASE v5.1
              menu_id           = custom_fields['custrecord_ts_menu'].value.xmlattr_internalId || 2
              user.menu_version = MenuVersion.first(:conditions => { :menu_id => menu_id, :version => 51 })


              # The deleted_at field acts as an expiry date
              if custom_fields.has_key?('custrecord_ts_expiry_date')
                user.deleted_at = custom_fields['custrecord_ts_expiry_date'].value
              else
                user.deleted_at = 14.days.from_now
              end

              if user.new_record?
                puts "[NetSuite:TrialUsers] Adding #{user.username} (Expires on #{user.deleted_at})"
              else
                puts "[NetSuite:TrialUsers] Updating #{user.username} (Expires on #{user.deleted_at})"

      					# We have to manually fix the email address as username is a primary key
      					User.update_all("username='#{contact.email}', email='#{contact.email}'", "netsuite_contact_id=#{contact.xmlattr_internalId}")
              end
      				user.save!

              # If the NS contact's email address has changed, update it manually (to bypass the read-only restriction on usernames)
              User.update_all("username='#{sanitized_email}'", "id=#{user.id}") if user.username != sanitized_email


              # Make sure we keep track of the last requested time. Should probably be
              # linked to the created field on the Trial System row.
              NetsuiteTrialRequest.create(:netsuite_id => record.xmlattr_internalId)
            end
          end
        end
      end
    end

    namespace :upload do
      # ======================================================================
      # Upload trial user usage statistics to NetSuite
      # ----------------------------------------------------------------------
      desc "Upload trial user usage statistics to NetSuite"
      task :usage => :environment do
        # Load the auto client (Trial Instance)
        client = Client.cpload('auto')

        # Assemble the users with NetSuite IDs and iterate through each grabbing the respective stats
        contacts = []
        client.users.with_netsuite_id.paginated_each do |user|
          contacts << returning(NetSuite::SOAP::Contact.new) do |contact|
            contact.xmlattr_internalId = user.netsuite_contact_id
            contact.nullFieldList      = NetSuite::SOAP::NullField.new

            contact.customFieldList = returning( NetSuite::SOAP::CustomFieldList.new ) do |fields|
              # Only update the last access date if we have one, otherwise nullify it
              if last_access_date = user.date_last_accessed
                fields << returning( NetSuite::SOAP::DateCustomFieldRef.new( last_access_date.xmlschema ))  { |ref| ref.xmlattr_internalId = :custentity_ts_last_accessed }
              else
                contact.nullFieldList << :custentity_ts_last_accessed
              end

              fields << returning( NetSuite::SOAP::LongCustomFieldRef.new( user.total_sessions ))                   { |ref| ref.xmlattr_internalId = :custentity_ts_sessions }
              fields << returning( NetSuite::SOAP::LongCustomFieldRef.new( user.total_sessions_in_last_30_days ))   { |ref| ref.xmlattr_internalId = :custentity_ts_sessions_30days }
              fields << returning( NetSuite::SOAP::LongCustomFieldRef.new( user.total_page_views ))                 { |ref| ref.xmlattr_internalId = :custentity_ts_page_views }
              fields << returning( NetSuite::SOAP::LongCustomFieldRef.new( user.total_page_views_in_last_30_days )) { |ref| ref.xmlattr_internalId = :custentity_ts_page_views_30days }
            end
          end
        end


        # Update the updated customer data to NetSuite
        NetSuite.filter(nil) do |session|
          session.wiredump_dev = STDOUT if Rails.env.development?
          update_batches = contacts.in_groups_of(100)
          update_batches.each_with_index do |batch, i|
            session.asyncUpdateList(NetSuite::SOAP::AsyncUpdateListRequest.new(batch.compact))
          end
        end
      end
    end
  end
  
  namespace :online do
    namespace :upload do
      # ======================================================================
      # Upload CDX Online instance statistic to NetSuite
      # ----------------------------------------------------------------------
      #
      # Usage:
      # 
      #   rake netsuite:online:statistics DATE='2009-02-24'
      #
      desc "Upload CDX Online instance statistic to NetSuite. Set DATE='2009-02-24' to process just that date"
      task :statistics => :environment do
        date = Date.yesterday
        date = ENV['DATE'].to_date unless ENV['DATE'].blank?

        puts "Processing CDX Online statistics for #{date}"

        netsuite_operations = []

        # Fetch the MITO client and setup the environment
        Client.current.with_netsuite_id.paginated_each(:order => "client_id DESC", :per_page => 5) do |client|
          User.set_table_name("cdxenroldb_v4.#{client.client_table}")
          Moodle::Base.setup_tables_by_database(client.client_database_name)

          # Ignore the client if there was no activity
          next unless client.access_logs.on_date(date).count > 0

          # Grab all the valid student and instructor usernames and Moodle userid's
          student_usernames    = client.all_users.current_before(date).students.usernames.map(&:username)
          instructor_usernames = client.all_users.current_before(date).instructors.usernames.map(&:username)

          student_moodle_ids    = Moodle::User.all(:conditions => { :username => student_usernames    }).map(&:id)
          instructor_moodle_ids = Moodle::User.all(:conditions => { :username => instructor_usernames }).map(&:id)

          netsuite_operations << returning(NetSuite::SOAP::CustomRecord.new) do |record|
            record.xmlattr_externalId = "#{client.client_prefix}-#{date}"

            # Define the record type we're creating
            (record.recType = NetSuite::SOAP::RecordRef.new('Online Statistics')).xmlattr_internalId = 28

            # Add the required fields for this row
            record.customFieldList = returning(NetSuite::SOAP::CustomFieldList.new) do |fl|
              # Link the row to the NS customer
              customerRef                    = NetSuite::SOAP::ListOrRecordRef.new
              customerRef.xmlattr_internalId = client.netsuite_customer_id
              customerRef.xmlattr_typeId     = -2
              (selectFieldRef = NetSuite::SOAP::SelectCustomFieldRef.new(customerRef)).xmlattr_internalId = 'custrecord_os_customer'
              fl << selectFieldRef

              # Set the date for this row
              fl << NetSuite::Helpers::custom_date_field_ref(:custrecord_os_date, date.to_datetime.to_s(:iso))

              # Student activity
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_active_students_daily,  client.access_logs.by_username(student_usernames).on_date(date).count(:username, :distinct => true))
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_active_students_30days, client.access_logs.by_username(student_usernames).between_dates(date - 30.days, date).count(:username, :distinct => true))
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_active_students,        client.access_logs.by_username(student_usernames).before_date(date).count(:username, :distinct => true))

              # Instructor activity
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_active_instructors_daily,   client.access_logs.by_username(instructor_usernames).on_date(date).count(:username, :distinct => true))
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_active_instructors_30days,  client.access_logs.by_username(instructor_usernames).between_dates(date - 30.days, date).count(:username, :distinct => true))
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_active_instructors,         client.access_logs.by_username(instructor_usernames).before_date(date).count(:username, :distinct => true))

              # All activity
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_active_users_daily,     client.access_logs.on_date(date).count(:username, :distinct => true))
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_active_users_30days,    client.access_logs.between_dates(date - 30.days, date).count(:username, :distinct => true))
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_active_users,           client.access_logs.before_date(date).count(:username, :distinct => true))

              # Sessions
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_sessions_students,      client.access_logs.sessions.by_username(student_usernames).on_date(date).count(:username))
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_sessions_instructors,   client.access_logs.sessions.by_username(instructor_usernames).on_date(date).count(:username))
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_sessions_supervisor,    client.access_logs.sessions.by_username('supervisor').on_date(date).count(:username))

              # Page views
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_page_views_students,    client.access_logs.pages.by_username(student_usernames).on_date(date).count(:username))
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_page_views_instructors, client.access_logs.pages.by_username(instructor_usernames).on_date(date).count(:username))
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_page_views_supervisor,  client.access_logs.pages.by_username('supervisor').on_date(date).count(:username))

              # Moodle Quizzes & Tests
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_quizzes_and_tests, Moodle::QuizAttempt.completed.on_date(date).count)

              # Tasksheets (Approved)
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_tasksheets_approved, client.tasksheet_submissions.on_date(date).approved.count)

              # User numbers
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_users_students, client.all_users.students.current_before(date).count)
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_users_instructors, client.all_users.instructors.current_before(date).count)

              # Add unqualified totals
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_unqualified_total_pages, client.access_logs.pages.on_date(date).count)
              fl << NetSuite::Helpers::custom_long_field_ref(:custrecord_os_unqualified_total_sessions, client.access_logs.sessions.on_date(date).count)
            end

            puts "#{Time.now} [#{client.prefix}] #{date}"
          end
        end

        puts "#{Time.now} Processing batches..."
        if netsuite_operations.size > 0
          NetSuite.filter(nil) do |session|
            session.wiredump_dev = STDOUT

            update_batches = netsuite_operations.in_groups_of(100, false)
            update_batches.each_with_index do |batch, i|
              puts "#{Time.now} Sending batch #{i+1} of #{update_batches.size} (sync)"
              session.asyncAddList(NetSuite::SOAP::AsyncAddListRequest.new(batch))
            end
          end
        end
      end


      # ======================================================================
      # Upload CDX Online instance summaries to the NetSuite customer records
      # ----------------------------------------------------------------------
      desc "Upload CDX Online instance summaries to the NetSuite customer records"
      task :summaries => :environment do
        # We don't want to update each customer indicually, so whack them into a
        # placeholder and take advantage of updateList
        customer_list = []


        # Cycle through the current (not expired) clients with NetSuite IDs
        # [ Client.cpload('mito') ].each do |client|
        Client.with_netsuite_id.paginated_each(:order => "id ASC") do |client|
          puts "Processing `#{client.client_name}` [#{client.client_prefix} - #{client.netsuite_customer_id}]"

          # Make sure we're using the correct Moodle DB
          Moodle::Base.setup_tables_by_client(client)

          # Setup the customer record with the custom fields to be updated
          customer_list << returning( NetSuite::SOAP::Customer.new ) do |customer|
            customer.xmlattr_internalId = client.netsuite_customer_id
            customer.nullFieldList      = NetSuite::SOAP::NullField.new

            # Expiry date of the subscription
            customer.endDate = client.expires_on.to_datetime.xmlschema

            # Update the custom field for the customer
            customer.customFieldList = returning( NetSuite::SOAP::CustomFieldList.new ) do |list|
        			# Update the supervisor_email field
        			list << returning( NetSuite::SOAP::StringCustomFieldRef.new( client.email.andand.strip)) { |ref| ref.xmlattr_internalId = :custentity_online_supervisor_email }

              # User counts
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.users.instructors.count ))                  { |ref| ref.xmlattr_internalId = :custentity_online_used_instructor_logons }
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.users.students.count ))                     { |ref| ref.xmlattr_internalId = :custentity_online_used_student_logons }

              # Only update the last access date if we have one, otherwise nullify it
              if client.date_last_accessed.blank?
                customer.nullFieldList << :custentity_online_last_access_date
              else
                list << returning( NetSuite::SOAP::DateCustomFieldRef.new( client.date_last_accessed )) { |ref| ref.xmlattr_internalId = :custentity_online_last_access_date }
              end 

              # Update custentity_online_subscription_created
              list << returning( NetSuite::SOAP::DateCustomFieldRef.new( client.created_at.to_datetime.xmlschema )) { |ref| ref.xmlattr_internalId = :custentity_online_subscription_created }

              # Active users
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.total_active_users ))                       { |ref| ref.xmlattr_internalId = :custentity_online_active_users }
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.total_active_users_in_last_30_days ))       { |ref| ref.xmlattr_internalId = :custentity_online_active_users_30days }

              # Page views
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.total_page_views ))                         { |ref| ref.xmlattr_internalId = :custentity_online_page_views }
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.total_page_views_in_last_30_days ))         { |ref| ref.xmlattr_internalId = :custentity_online_page_views_30days }

              # Quizzes and tests (completed only)
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.total_quizzes_and_tests ))                  { |ref| ref.xmlattr_internalId = :custentity_online_quizzes }
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.total_quizzes_and_tests_in_last_30_days ))  { |ref| ref.xmlattr_internalId = :custentity_online_quizzes_30days }

              # Tasksheets (approved only)
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.total_tasksheets ))                         { |ref| ref.xmlattr_internalId = :custentity_online_tasksheets }
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.total_tasksheets_in_last_30_days ))         { |ref| ref.xmlattr_internalId = :custentity_online_tasksheets_30days }

              # Sessions (approved only)
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.total_sessions ))                         { |ref| ref.xmlattr_internalId = :custentity_online_sessions }
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.total_sessions_in_last_30_days ))         { |ref| ref.xmlattr_internalId = :custentity_online_sessions_30days }

              # Supervisor details
              list << returning( NetSuite::SOAP::StringCustomFieldRef.new( client.client_email ))         { |ref| ref.xmlattr_internalId = :custentity_online_supervisor_email }

              # Make sure we null out the phone number if none is given
              if client.emergency_number.blank?
                customer.nullFieldList << :custentity_online_supervisor_phone
              else
                # NetSuite won't accept phone numbers greater than 21 chars. Truncate.
                list << returning( NetSuite::SOAP::StringCustomFieldRef.new( client.emergency_number[0...21] ))     { |ref| ref.xmlattr_internalId = :custentity_online_supervisor_phone }
              end

              # If the client password is blank, make sure whoever has access
              # in NetSuite will be made aware of that.
              #
              if client.cleartext_password.blank?
                list << returning( NetSuite::SOAP::StringCustomFieldRef.new( "(PASSWORD UNKNOWN)" ))   { |ref| ref.xmlattr_internalId = :custentity_online_supervisor_password }
              else
                list << returning( NetSuite::SOAP::StringCustomFieldRef.new( client.cleartext_password ))   { |ref| ref.xmlattr_internalId = :custentity_online_supervisor_password }
              end

              # Maxium role logins
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.current_logons ))                               { |ref| ref.xmlattr_internalId = :custentity_online_total_allocated_logons  }
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.current_logons - (client.instructor_logons - 1))) { |ref| ref.xmlattr_internalId = :custentity_online_allocated_students      }
              list << returning( NetSuite::SOAP::LongCustomFieldRef.new( client.instructor_logons - 1 ))                        { |ref| ref.xmlattr_internalId = :custentity_online_allocated_instructors   }

              # We need to do a little more work when dealing with menus. Ignore the custom ones.
              unless [7, 8, 10, 11, 12, 13].include?(client.menu.id)
                list << returning(NetSuite::SOAP::SelectCustomFieldRef.new) do |menu|
                  menu.xmlattr_internalId = :custentity_online_menu_pref
                  menu.value = returning(NetSuite::SOAP::ListOrRecordRef.new) do |ref|
                    ref.xmlattr_typeId     = :customlist_online_menus
                    ref.xmlattr_internalId = client.menu.id
                  end
                end
              else
                customer.nullFieldList << :custentity_online_menu_pref
              end

              # Time zone
              # if client.time_zone.present?
              #   list << returning( NetSuite::SOAP::StringCustomFieldRef.new( client.time_zone ))          { |ref| ref.xmlattr_internalId = :custentity_online_time_zone }
              # else
              #   customer.nullFieldList << :custentity_online_time_zone
              # end 
            end 
          end
        end

        # Update the updated customer data to NetSuite
        NetSuite.filter(nil) do |session|
          update_batches = customer_list.in_groups_of(100)
          update_batches.each_with_index do |batch, i|
            session.asyncUpdateList(NetSuite::SOAP::AsyncUpdateListRequest.new(batch.compact))
          end
        end
      end
    end
  end
end
