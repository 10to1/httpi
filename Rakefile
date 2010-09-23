require "rake"

begin
  require "metric_fu"
  
  MetricFu::Configuration.run do |c|
    c.metrics = [:churn, :flog, :flay, :reek, :roodi, :saikuro] # :rcov seems to be broken
    c.graphs = [:flog, :flay, :reek, :roodi]
    c.rcov[:rcov_opts] << "-Ilib -Ispec"
  end
rescue LoadError
  desc message = %{"gem install metric_fu" to generate metrics}
  task("metrics:all") { abort message }
end

begin
  require "rspec/core/rake_task"
  
  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = %w(-fd -c)
  end
rescue LoadError
  task :spec do
    abort "Run 'gem install rspec' to be able to run specs"
  end
end

task :default => :spec
