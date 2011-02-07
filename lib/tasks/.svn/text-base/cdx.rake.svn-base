# 
# cdx.rake
# online
# 
# Created by John Meredith on 2009-01-04.
# Copyright 2009 CDX Global. All rights reserved.
# 
namespace :cdx do
  namespace :schema do

    desc "Dump all relevant databases to db/cdx_schema.rb"
    task :dump => :environment do
      require 'active_record'
      require 'active_record/schema_dumper'
      require 'erb'

      connections = YAML.load(ERB.new(IO.read("#{RAILS_ROOT}/config/database.yml"), nil, nil, '_different_erb_out_variable_incase_ERB_is_being_evaluated').result)
      connections.each do |name, details|
        database_name = details['database']
        
        # Don't dump the test and production dbs
        next if (database_name =~ /test|production/) || (name =~ /test|production/)

        # We need to connect to each named db separately
        ActiveRecord::Base.establish_connection(details)

        # Dump the schema to file named after the db
        File.open(ENV['SCHEMA'] || "#{RAILS_ROOT}/db/schema/#{database_name}.rb", "w") do |file|
          file << "# #{'-' * 76}\n"
          file << "# #{database_name} Schema\n"
          file << "# #{'-' * 76}\n"

          ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
        end
      end
    end

  end
end
