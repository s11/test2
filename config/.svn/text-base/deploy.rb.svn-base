set :stages, %w(staging production)
# set :default stage, "production"
require 'capistrano/ext/multistage'
require 'thinking_sphinx/deploy/capistrano'

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
