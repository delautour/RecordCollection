# RecordCollections

## Don't expose `ActiveRecord::Relation`s, expose `RecordCollections`!

Exposing ActiveRecord::Relations from your controllers to views is bad for business. As much as it is convenient to
do so, it really make sense that your view can use an `unscoped` version. More importantly, testing what is
or isn't in scope of a `ActiveRecord::Relation` is REALLY hard.

## Usage

    # users_controller.rb

    def index
      @users = RecordCollection.new(User)
          .limit_by(User.active)
          .and(User.first_name("Jane"))
          .and(User.over_21)
    end


    # users_controller_spec.rb

    subject(:users) { assigns[:users] }

    it { should be_limited_by?(User.active) }
    it { should be_limited_by?(User.first_name("Jane")) }
    it { should be_limited_by?(User.over_21) }
