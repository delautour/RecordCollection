require_relative '../lib/version'

class Install
  require "rubygems"

  GEMSPEC_PATH = './record-collection.gemspec'

  def run
    step { system("gem install ./bin/record-collection-#{VERSION}.gem") }
  end

  def step
    puts "="*15
    fail unless yield
  end
end

desc "Installs the gem locally"
task install: [:build] do
  Install.new.run
end
