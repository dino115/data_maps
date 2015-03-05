DataMaps
=================
[![Build Status](https://travis-ci.org/dino115/data_maps.svg?branch=master)](https://travis-ci.org/dino115/data_maps)
[![Code Climate](https://codeclimate.com/github/dino115/data_maps/badges/gpa.svg)](https://codeclimate.com/github/dino115/data_maps)
[![Test Coverage](https://codeclimate.com/github/dino115/data_maps/badges/coverage.svg)](https://codeclimate.com/github/dino115/data_maps)
[![Gem Version](https://badge.fury.io/rb/data_maps.svg)](http://badge.fury.io/rb/data_maps)
[![Dependency Status](https://gemnasium.com/dino115/data_maps.svg)](https://gemnasium.com/dino115/data_maps)

Create mappings to convert structured data into another format!
This is useful when you need a dynamic generated or serializable mapping.

**Attention: The API can change before the gem version reach 1.0!**

## Installation

Add this line to your applications' Gemfile:

```ruby
gem 'data_maps'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install data_maps

## Usage

### Mapper
The DataMaps::Mapper converts data only from a ruby hash. So you have to import your data and create a ruby hash of it.

```ruby
mapper = DataMaps::Mapper.new(mapping)

converted_data = your_data.map do |data_row|
  mapper.convert(data_row)
end
```

### Mapping
Create mappings.

#### Field mapping
You can map a single field, a nested field or multiple fields.

```ruby
mapping = DataMaps::Mapping.new({
  'field' => {
    from: 'source'
  }
  # or simple: 'field' => 'source'
})

# Example:
#
# source_data = {
#   'familyname' => 'Smith'
# }
#
# mapping = {
#   'last_name' => {
#     from: 'familyname'
#   }
# }
#
# destination_data = {
#   'last_name' => 'Smith'
# }
```

For nested fields you can specify the field chain as `Array`.
```ruby
mapping = DataMaps::Mapping.new({
  'field' => {
    from: ['level1', 'level2']
  }
})

# Example:
#
# source_data = {
#   company_relation: {
#     id: '123',
#     name: 'My Company'
#   }
# }
#
# mapping = {
#   'company' => {
#     from: ['company_relation', 'name']
#   }
# }
#
# destination_data = {
#   'company' => 'My Company'
# }
```

You can select multiple fields from your data. By pass them as `Hash`. You can pass directly a new field name.
```ruby
mapping = DataMaps::Mapping.new({
  'field' => {
    from: { field: true, other_field: true } # or map them directly to a new field name by passing the new name instead of true
  }
})

# Example:
#
# source_data = {
#   customer_street: 'My street 5',
#   customer_city: 'Cologne'
# }
#
# mapping = {
#   'address' => {
#     from: {
#       customer_street: 'street',
#       customer_city: 'city'
#     }
#   }
# }
#
# destination_data = {
#   'address' => {
#     'street' => 'My street 5',
#     'city' => 'Cologne'
#   }
# }
```

#### Conditions
Conditions must always have a when and then command. All condition statements are executed procedural.
The only exception is when using `then: { filter: true }`, then the execution breaks immediately and removes the whole field from result data.

```ruby
'field' => {
  from: 'source'
  conditions: [
    { when: { empty: true }, then: { set: 'something' },
    { when: { regex: /[1-9]{5}/i }, then: { convert: { numeric: 'Integer' } } }
  ]
}
```

##### Possible when's

- **When: empty**
  Possible options for the empty conditions are `true` or `false`.
  The condition is true when `data.empty? == result`

  ```ruby
  empty: true # or false
  ```
- **When: regex**
  Define a regular expression condition.
  The condition is true when `data.match regex`. Only works with strings.

  ```ruby
  regex: /[a-z]/i
  ```
- **When: gt, gte**
  Check if data is *greater* or *greater or equal* than the given value. Only works with comparable objects.

  ```ruby
  gt: 5
  gte 5
  ```
- **When: lt, lte**
  Check if data is *lower* or *lower or equal* than the given value. Only works with comparable objects.

  ```ruby
  lt: 5
  lte: 5
  ```
- **When: eq, neq**
  Check if data is *equal* or *not equal* to the given value. Only works with comparable objects.

  ```ruby
  eq: 10
  neq: 'a-value'
  ```
- **When: in, nin**
  Check if data is *in* or *not in* the set of given values. Doesn't work for a collection of values.

  ```ruby
  in: ['a', 'b', 'c']
  nin: ['x', 'y', 'z']
  ```
- **When: custom**
  Define your own condition class by defining them in the `DataMaps::When` module.
  Your `When` must implement a `execute` method which returns `true` or `false`.
  You have to extend the `DataMaps::When::Base` class. Then all options are available via the `option` attribute reader.

  ```ruby
  class DataMaps::When::IsZip < DataMaps::When::Base
    def execute(data)
      !!data.match(/\d{5}/)
    end
  end
  ```

  ```ruby
  is_zip: true # option isn't used, you can pass anything, for example and readability true
  ```

##### Possible then's

- **Then: set**
  Set the value to given value.

  ```ruby
  set: 'to this value'
  ```
- **Then: convert**
  Apply the configured converter. See converter section for more information.

  ```ruby
  convert: [
    { apply: :numeric, option: 'Integer' }
  ]
  ```
- **Then: filter**
  When this is set to true then the whole field will filtered.

  ```ruby
  filter: true
  ```
- **Then: custom**
  Define your own *then* by defining them in the `DataMaps::Then` module.
  Your `Then` must implement a `execute` method. The return of this method is set as data.
  You have to extend the `DataMaps::Then::Base` class. Then all options are available via the `option` attribute reader.

  ```ruby
  class DataMaps::Then::SendEmail < DataMaps::Then::Base
    def execute(data)
      MyFramework::Email.send(to: option)
      data
    end
  end
  ```

  ```ruby
  send_email: me@example.com
  ```

#### Converter
Apply one or many converters to the input data. Converters applied procedural.

```ruby
'field' => {
  from: 'source',
  convert: [
    { apply: :map, option: { 1: 'A', 2: 'B' } }
  ]
  # or in short, when no option is needed
  convert: [ :string ]
}
```

##### Possible converter

- **Converter: map**
  A simple value mapping. Maps are converted to a `HashWithIndifferentAccess`.
  Works with flat values, hashes and arrays.
  For arrays and hashes it returns nil if the value is not in the mapping. For flat values it returns the original data.

  ```ruby
  apply: :map,
  option: {
    from: to
  }
  ```
- **Converter: numeric**
  Cast data to a numeric value. Possible options are 'Integer', 'Float' or a number, then it is casted to float and rounded. Doesn't work with collections.
  Can raise an error if the value is not convertable.

  ```ruby
  apply: :numeric,
  option 'Integer'
  # option: 'Float'
  # option: 2
  ```
- **Converter: String**
  Cast explicit to string. Doesn't work with collections.
  Can raise error if the value is not convertable.

  ```ruby
  apply: :string
  ```
- **Converter: Boolean**
  Cast explicit to bool (by double negotiation). Doesn't work with collections.
  Can return unexpected values, e.g. a double negotiated empty array is true! `!![] #=> true`

  ```ruby
  apply: :bool
  ```
- **Converter: keys**
  This maps the hash keys when the input data is a hash or when you select multiple *from* fields. Only works with hashes.
  Return the original data when the data isn't a hash.

  ```ruby
  apply: :key,
  option: {
    'address1' => 'street'
  }
  ```
- **Converter: Prefix**
  This prefixes the data with a given value. Call `to_s` on data and always returns a string.

  ```ruby
  apply: :prefix,
  option: '$'
  ```
- **Converter: Postfix**
  This postfixes the data with a given value. Call `to_s` on data and always returns a string.

  ```ruby
  apply: :postfix,
  option: '€'
  ```
- **Converter: ruby**
  Apply any method on the current data object.

  ```ruby
  apply: :ruby,
  option: :upcase
  # option: [:slice, 5]
  # option: [:join, ', ']
  ```
- **Converter: custom**
  Define your own *converter* by defining them in the `DataMaps::Converter` module.
  Your `Converter` must implement an `execute` method. The return of this method is set as new data.
  You have to extend the `DataMaps::Converter::Base` class. Then all options are available via the `option` attribute reader.

  ```ruby
  class DataMaps::Converter::PersonObject < DataMaps::Converter::Base
    def execute(data)
      Person.new(data, option)
    end
  end
  ```

  ```ruby
  apply: person_object,
  option: { as: :importer } # passed value are available via option
  ```

Have fun using the `DataMaps` gem :)
