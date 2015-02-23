require 'spec_helper'

# Define a ActiveRecord model to help with our tests
ActiveRecord::Schema.define do
  self.verbose = false

  create_table :tests, force: true do |t|
    t.string :name
    t.integer :age
  end
end

class Test < ActiveRecord::Base

  default_scope { where.not(name: "Exclude by default") }
  scope :with_name, ->(name) { where(name: name) }
  scope :over_age, ->(age) { where("age > ?", age) }
end

describe RecordCollection do
  subject(:collection) { RecordCollection.new(Test.all) }
  describe ".new(baseScope)" do
    subject { RecordCollection.new(scope) }

    context "when baseScope is a scope" do
      let(:scope) { Test.all }

      it { should be_a(RecordCollection) }
    end

    context "when baseScope is a class" do
      let(:scope) { Test }

      it { should be_a(RecordCollection) }
    end
  end

  describe "#limit_by" do
    it { should respond_to :limit_by }

    it "accepts an argument" do
      expect { collection.limit_by(Test.with_name("Foo")) }.to_not raise_error
    end

    it "returns it's self" do
      expect(collection.limit_by(Test.all)).to be collection
    end

    it "accepts a block" do
      expect { collection.limit_by {} }.to_not raise_error
    end

    it "yields the base scope to the block" do
      base_scope = Test.with_name("foo")
      collection = RecordCollection.new(base_scope)

      yielded_scope = nil

      collection.limit_by { |s| yielded_scope = s }
      expect(yielded_scope).to eq base_scope
    end

    it "requires an argument or block" do
      expect { collection.limit_by() }.to raise_error(ArgumentError)
    end
  end

  describe "#and" do
    it { should respond_to :and }

    it "accepts an argument" do
      expect { collection.and(Test.with_name("Foo")) }.to_not raise_error
    end

    it "returns it's self" do
      expect(collection.and(Test.all)).to be collection
    end
  end

  describe "#order_by" do
    it { should respond_to :and }

    it "accepts an argument" do
      expect { collection.and(Test.with_name("Foo")) }.to_not raise_error
    end

    it "returns it's self" do
      expect(collection.and(Test.all)).to be collection
    end
  end

  describe "is_limited_by?" do
    it { should respond_to :is_limited_by? }

    it "accepts an argument" do
      expect { collection.is_limited_by?(Test.with_name("Foo")) }.to_not raise_error
    end

    it "returns true if `limit_by` has been called with the argument" do
      collection.limit_by(Test.with_name("Foo"))

      expect(collection.is_limited_by?(Test.with_name("Foo"))).to be true
    end

    it "returns true if the collection was created with the argument" do
      collection = RecordCollection.new(Test.with_name("Foo"))

      expect(collection.is_limited_by?(Test.with_name("Foo"))).to be true
    end

    it "returns false if `limit_by` has not been called with the argument" do
      collection.limit_by(Test.with_name("Foo"))

      expect(collection.is_limited_by?(Test.with_name("Bob"))).to be false
    end
  end

  describe "limited_by?" do
    it { should respond_to :limited_by? }

    it "accepts an argument" do
      expect { collection.limited_by?(Test.with_name("Foo")) }.to_not raise_error
    end

    it "returns true if `limit_by` has been called with the argument" do
      collection.limit_by(Test.with_name("Foo"))

      expect(collection.limited_by?(Test.with_name("Foo"))).to be true
    end

    it "returns true if the collection was created with the argument" do
      collection = RecordCollection.new(Test.with_name("Foo"))

      expect(collection.is_limited_by?(Test.with_name("Foo"))).to be true
    end

    it "returns false if `limit_by` has not been called with the argument" do
      collection.limit_by(Test.with_name("Foo"))

      expect(collection.limited_by?(Test.with_name("Bob"))).to be false
    end
  end

  describe "enumeration" do
    it { should respond_to :each }
    it { should respond_to :all? }
    it { should respond_to :any? }
    it { should respond_to :chunk }
    it { should respond_to :collect }
    it { should respond_to :collect_concat }
    it { should respond_to :count }
    it { should respond_to :cycle }
    it { should respond_to :detect }
    it { should respond_to :drop }
    it { should respond_to :drop_while }
    it { should respond_to :each_cons }
    it { should respond_to :each_entry }
    it { should respond_to :each_slice }
    it { should respond_to :each_with_index }
    it { should respond_to :each_with_object }
    it { should respond_to :entries }
    it { should respond_to :find }
    it { should respond_to :find_all }
    it { should respond_to :find_index }
    it { should respond_to :first }
    it { should respond_to :flat_map }
    it { should respond_to :grep }
    it { should respond_to :group_by }
    it { should respond_to :include? }
    it { should respond_to :inject }
    it { should respond_to :lazy }
    it { should respond_to :map }
    it { should respond_to :max }
    it { should respond_to :max_by }
    it { should respond_to :member? }
    it { should respond_to :min }
    it { should respond_to :min_by }
    it { should respond_to :minmax }
    it { should respond_to :minmax_by }
    it { should respond_to :none? }
    it { should respond_to :one? }
    it { should respond_to :partition }
    it { should respond_to :reduce }
    it { should respond_to :reject }
    it { should respond_to :reverse_each }
    it { should respond_to :select }
    it { should respond_to :sort }
    it { should respond_to :sort_by }
    it { should respond_to :take }
    it { should respond_to :take_while }
    it { should respond_to :to_a }
    it { should respond_to :to_h }
    it { should respond_to :zip }

    context "when the base scope was a class" do
      it "should yield objects accoprding to default scope" do
        adam = Test.create(name: "Adam")
        excluded_by_default = Test.create(name: "Exclude by default")
        collection = RecordCollection.new(Test)

        expect(collection).to include(adam)
        expect(collection).to_not include(excluded_by_default)
      end
    end

    context "when `filter_by` has not been called" do
      it "should yield objects in scope the base scope" do
        adam = Test.create(name: "Adam")
        bob = Test.create(name: "Bob")
        collection = RecordCollection.new(Test.with_name("Adam"))

        expect(collection).to include(adam)
        expect(collection).to_not include(bob)
      end
    end

    context "when `filter_by` with an argument has been called" do
      it "should not yield filtered out by scopes" do
        adam_12 = Test.create(name: "Adam", age: 12)
        adam_21 = Test.create(name: "Adam", age: 21)
        bob = Test.create(name: "Bob", age: 21)

        collection
            .limit_by(Test.with_name("Adam"))
            .and(Test.over_age(20))

        expect(collection).to include(adam_21)
        expect(collection).to_not include(bob, adam_12)
      end
    end

    context "when `filter_by` with a block has been called" do
      it "should not yield filtered out by scopes" do
        adam_12 = Test.create(name: "Adam", age:  12)
        adam_21 = Test.create(name: "Adam", age: 21)
        bob = Test.create(name: "Bob", age: 21)

        collection
            .limit_by { |s| s.with_name("Adam") }
            .and(Test.over_age(20))

        expect(collection).to include(adam_21)
        expect(collection).to_not include(bob, adam_12)
      end
    end
  end

  describe "rspec integration" do
    before :each do
      collection.limit_by(Test.with_name("Foo"))
    end

    it { should be_limited_by(Test.with_name("Foo")) }
    it { should_not be_limited_by(Test.with_name("Adam")) }
  end
end
