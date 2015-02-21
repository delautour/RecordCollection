require_relative '../lib/version'

class Build
  require "rubygems"
  GEMSPEC_PATH = './record-collection.gemspec'

  def run
    step do
      File.open('.build', 'w') do |f|
        f.write(VERSION)
      end

      begin
        system("gem build #{GEMSPEC_PATH}")

        FileUtils.mkpath('bin')
        FileUtils.mv("./record-collection-#{VERSION}.gem", "bin/record-collection-#{VERSION}.gem")
      ensure
        File.delete('.build')
      end
    end
  end

  def step
    puts "="*15
    fail unless yield
  end
end

desc "Build the gem"
task build: :test do
  Build.new.run
end
