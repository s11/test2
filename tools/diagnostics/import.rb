#!/usr/bin/env ruby

require 'optparse'

options   = { :environment => (ENV['RAILS_ENV'] || 'development').dup }
optparse  = OptionParser.new do |opts|
  opts.banner = 'Usage: import.rb [options] csvfile'
  
  options[:force] = false
  opts.on( '-f', '--force', 'Force overwriting the specified system if it already exists' ) do
    options[:force] = true
  end
  
  options[:system] = nil
  opts.on( '--system NAME', 'Import content into system NAME') do |name|
    options[:system] = name
  end
  
  # Not properly thought out yet.  Should support automated creation of multiple scenarios
  options[:scenario] = nil
  opts.on( '--scenario NAME', 'Import content into scenario NAME') do |name|
    options[:scenario] = name
  end
  
  options[:practice] = false
  opts.on( '-p', '--practice', 'Flag the scenario as being a practice scenario') do
    options[:practice] = true
  end
  
  opts.on_tail( '-h', '--help', 'Show this message' ) do
    puts opts
    exit
  end
end

optparse.parse!

puts 'Loading environment.'

require File.dirname(__FILE__) + '/../../config/boot'

# Make sure we have the correct environment. Default to 'development'.
ENV['RAILS_ENV'] = options[:environment]

RAILS_ENV.replace(options[:environment]) if defined?(RAILS_ENV)

require RAILS_ROOT + '/config/environment'
require RAILS_ROOT + '/tools/diagnostics/lib.rb'

require 'fastercsv'

puts 'Commencing import.'

ARGV.each do |csv_filename|
  
  system = nil
  
  # Check the file actually exists
  unless File.exists? csv_filename
    puts "Unable to open #{csv_filename}.  File does not exist or you do not have permissions to read it."
    exit
  end
  
  if options[:system].nil?
    puts 'Need system to create the scenario in.'
    exit
  end
  
  # Find the system specified
  system = Diagnostics::System.find_by_name(options[:system])
  if system.nil?
    puts "Creating '#{options[:system]}' system."
    system = Diagnostics::System.create!({:name => options[:system]})
  else
    puts "Found system \"#{options[:system]}\" by name."
  end
  
  # Find the scenario by name
  scenario = system.scenarios.find_by_name(options[:scenario])
  
  unless scenario.nil?
    if not options[:force]
      puts 'Scenario already exists.  Use force option to replace it.'
      exit
    else
      puts "Removing '#{options[:scenario]}' scenario."
      scenario.destroy
      scenario = nil
    end
  end
  
  # Create and populate the scenario
  scenario = system.scenarios.build({:name => options[:scenario], :is_practice => options[:practice]}) if scenario.nil?
  create_scenario(scenario, csv_filename)
    
  puts 'Import completed succesfully.'
  
end