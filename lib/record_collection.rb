class RecordCollection
  include Enumerable
  require 'set'

  def initialize(base_scope)
    self.base_scope = coerce_to_relation(base_scope)
    self.scopes = Set.new
  end

  def coerce_to_relation(base_scope)
    if base_scope.respond_to?(:all)
      base_scope.all
    else
      # rails 3
      base_scope.scoped
    end
  end

  def limit_by(scope)
    scopes.add(scope)
    self
  end

  alias and limit_by

  def is_limited_by?(scope)
    # because ActiveRecord::Relations do not implement hashing correctly, we must do case by case equality
    scopes.any? { |s| s == scope }
  end

  def each(&block)
    scopes.reduce(base_scope) { |scope, base| base.merge(scope) }.each(&block)
  end

private

  attr_accessor :base_scope, :scopes
end
