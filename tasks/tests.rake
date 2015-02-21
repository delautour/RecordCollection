desc "Runs tests"
task :test do
  fail unless system('rspec')
end
