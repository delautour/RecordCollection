# RecordCollections

## Don't expose `ActiveRecord::Relation`s, expose `RecordCollections`!

Exposing ActiveRecord::Relations from your controllers to views is bad for business. As much as it is convenient to
do so, it really make sense that your view can use an `unscoped` version. More importantly, testing what is
or isn't in scope of a `ActiveRecord::Relation` is REALLY hard.
