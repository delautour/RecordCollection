# RecordCollections

**Don't expose `ActiveRecord::Relation`s, expose `RecordCollections`!**

Exposing ActiveRecord::Relations from your controllers to views is bad for business. As much as it is convenient to
do so, it really make sense that your view can use an `unscoped` version.

More importantly, testing what is or isn't in scope of a `ActiveRecord::Relation` is REALLY hard. RecordCollections make it easy (so long as you use small scopes).

## Usage

Controllers

    def index
      @users = RecordCollection.new(User)
          .limit_by(User.active)
          .and(User.first_name("Jane"))
          .and(User.over_21)
    end


RSpec

    subject(:users) { assigns[:users] }

    it { should be_limited_by?(User.active) }
    it { should be_limited_by?(User.first_name("Jane")) } # Yes, it even works with arguments to the scope
    it { should be_limited_by?(User.over_21) }

    it { should_not be_limited_by?(User.under_50) } # Maybe there are some scopes you definitely don't want
