class Push
  require "rubygems"

  GEMSPEC_PATH = './record-collection.gemspec'

  def run
    spec = Gem::Specification::load(GEMSPEC_PATH)

    step { system("gem push ./record-collection-#{spec.version}.gem") }
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
