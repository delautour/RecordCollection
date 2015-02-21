class BuildAndInstall
  require "rubygems"

  GEMSPEC_PATH = './record-collection.gemspec'

  def run
    spec = Gem::Specification::load(GEMSPEC_PATH)

    step { system("gem build #{GEMSPEC_PATH}") }
    step { system("gem install ./record-collection-#{spec.version}.gem") }
  end

  def step
    puts "="*15
    fail unless yield
  end
end

desc "Build and installs RecordCollection"
task build_and_install: [:test] do
  BuildAndInstall.new.run
end
