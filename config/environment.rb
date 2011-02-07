# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.


  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/reports #{RAILS_ROOT}/app/mailers )


  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'andand',              :version => '1.3.1'
  config.gem 'authlogic',           :version => '2.1.3'
  config.gem 'awesome_nested_set',  :version => '1.4.3'
  config.gem 'duration',            :version => '0.1.0'
  config.gem 'haml',                :version => '2.2.16'
  config.gem "hoptoad_notifier",    :version => ">= 2.1.3"
  config.gem 'inherited_resources', :version => '0.9.4'
  config.gem 'murdoch',             :version => '1.0.1',    :lib => "ruport/murdoch"
  config.gem 'paperclip',           :version => '2.3.1.1'
  config.gem 'preferences',         :version => '0.3.1'
  config.gem 'searchlogic',         :version => '2.3.9'
  config.gem 'settingslogic',       :version => '2.0.3'
  config.gem 'state_machine',       :version => '0.8.0'
  config.gem 'stripper',            :version => '2.0.3'
  config.gem 'thinking-sphinx',     :version => '1.3.14', :lib => 'thinking_sphinx'
  config.gem 'will_paginate',       :version => '2.3.11'

  # Used by custom scripts
  config.gem 'hpricot',             :version => '>= 0.8.1', :lib => nil
  config.gem 'main',                :version => '>= 2.8.4', :lib => nil

  # MSSQL - Don't change versions as activerecord-sqlserver-adapter is dependent on these to for the moment.
  config.gem 'activerecord-sqlserver-adapter',  :version => '2.3', :lib => "active_record/connection_adapters/sqlserver_adapter"
  config.gem 'dbi',       :version => '0.4.1'
  config.gem 'dbd-odbc',  :version => '0.2.4', :lib => 'dbd/ODBC'


  # FIXME: Remove when API adjusted to user_id change
  # config.gem 'thumblemonks-load_model',           :source => 'http://gems.github.com',  :version => '>= 0.2.2', :lib => 'load_model'




  # For rake tasks and scripts


  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  config.plugins = [ :hoptoad_notifier, :all ]


  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]


  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer


  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'


  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end


# FIXME: Should probably be included in the lib dir
module ActiveSupport::CoreExtensions::String::Inflections
  def classnameify
    self.gsub(/[^\w]+/, '_').downcase
  end
end

require 'rails_extensions.rb'
