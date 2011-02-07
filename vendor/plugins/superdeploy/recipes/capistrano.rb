namespace :capistrano do
  desc <<-DESC
    Update revisions log from Capistrano 1.x.
    
    Migrate from the revisions log to REVISION. Capistrano 1.x recorded each \
    deployment to a revisions.log file. Capistrano 2.x is cleaner, and just \
    puts a REVISION file in the root of the deployed revision. This task \
    migrates from the revisions.log used in Capistrano 1.x, to the REVISION \
    tag file used in Capistrano 2.x. It is non-destructive and may be safely \
    run any number of times.
  DESC
  task :upgrade, :roles => :app do
    revisions = capture("cat #{deploy_to}/revisions.log")

    mapping = {}
    revisions.each do |line|
      revision, directory = line.chomp.split[-2,2]
      mapping[directory] = revision
    end

    commands = mapping.keys.map do |directory|
      "echo '.'; test -d #{directory} && echo '#{mapping[directory]}' > #{directory}/REVISION"
    end

    command = commands.join(";")

    run "cd #{releases_path}; #{command}; true" do |ch, stream, out|
      STDOUT.print(".")
      STDOUT.flush
    end
  end
end