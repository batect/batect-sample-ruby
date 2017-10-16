require 'rspec/core/rake_task'
require 'rubocop/rake_task'

namespace :spec do
  %w[unit integration journey].each do |category|
    desc "Run #{category} tests"
    RSpec::Core::RakeTask.new(category) do |t|
      t.rspec_opts = ['-I', 'lib', '-I', 'spec']
      t.pattern = FileList["spec/#{category}/**/*_spec.rb"]
    end
  end
end

RuboCop::RakeTask.new

desc 'Prepares application files for the Docker image build.'
task :prepareImage do
  relative_dest_dir = 'dev-infrastructure/international-transfers-service/app/'
  dest_dir = File.expand_path(relative_dest_dir,
                              File.dirname(__FILE__))

  rm_rf dest_dir
  mkdir_p dest_dir
  cp 'Gemfile', dest_dir
  cp 'Gemfile.lock', dest_dir
  cp_r 'lib', "#{dest_dir}/lib"
end
