entasis
=======

[![Build Status](https://secure.travis-ci.org/ingemar/entasis.png)](http://travis-ci.org/ingemar/entasis)

Entasis provides a few neat methods for building a basic class. Handy for models without a database.

Example:

```ruby
class Person
  include Entasis::Model

  attributes :name, :age, :city

  def age=(years)
    @age = years.to_i
  end
end

hilda = Person.new(name: 'Hilda', age: '23', city: 'Stockholm')
hilda.attribute_names # => ["name", "age", "city"]
hilda.attributes      # => {"name"=>"Hilda", "age"=>23, "city"=>"Stockholm"}

anon = Person.new
anon.valid?           # => false
anon.errors           # => {:name=>["can't be blank"]}>
```

Default behavior is to raise if any key in the hash given to `.new` or `#attributes=` is not defined,
this can be circumvented by passing `ignore_undefined: true` as options when defining your attributes.


Transposing keys
----------------

If you include the module `Entasis::TransposeKeys` after you have included `Entasis::Model`,
keys in the given hash will be downcased and underscored before calling the setter methods.

This can be very useful when you got hash with camelcased keys, for example from an external service serving XML soup.


Contributors
------------

  - Ingemar Edsborn (ingemar)
  - Joshua Davey (jgdavey)
  - Johnny Winn (nurugger07)
  - Jack Christensen (jackc)

