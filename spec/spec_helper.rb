# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require 'active_record'
require_relative '../lib/record_collection'

RSpec.configure do |config|
  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.warnings = true

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
