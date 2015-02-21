require_relative '../lib/version'

class Push
  require "rubygems"

  def run
    step { system("gem push ./bin/record-collection-#{VERSION}.gem") }
  end

  def step
    puts "="*15
    fail unless yield
  end
end

desc "Pushes the gem to RubyGems"
task push: :build_and_install do
  Push.new.run
end
