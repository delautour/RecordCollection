class RecordCollection
  require 'set'

  def initialize(base_scope)
    self.base_scope = coerce_to_relation(base_scope)
    self.scopes = Set.new
  end

  def coerce_to_relation(base_scope)
    # rails 3
    if base_scope.respond_to?(:scoped)
      base_scope.scoped
    else
      # rails 4
      base_scope.all
    end
  end

  def limit_by(scope)
    scopes.add(scope)
    self
  end

  alias and limit_by

  def is_limited_by?(scope)
    # because ActiveRecord::Relations do not implement hashing correctly, we must do case by case equality
    base_scope == scope || scopes.any? { |s| s == scope }
  end

  alias limited_by? is_limited_by?

  def respond_to?(name)
    super || final_scope.respond_to?(name)
  end

  def method_missing(name, *args, &block)
    final_scope.__send__(name, *args, &block)
  end

private

  attr_accessor :base_scope, :scopes

  def final_scope
    scopes.reduce(base_scope) { |scope, base| base.merge(scope) }
  end
end
