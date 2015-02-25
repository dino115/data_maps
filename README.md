DataMaps
=================
[![Build Status](https://travis-ci.org/dino115/data_maps.svg?branch=master)](https://travis-ci.org/dino115/data_maps)
[![Code Climate](https://codeclimate.com/github/dino115/data_maps/badges/gpa.svg)](https://codeclimate.com/github/dino115/data_maps)
[![Test Coverage](https://codeclimate.com/github/dino115/data_maps/badges/coverage.svg)](https://codeclimate.com/github/dino115/data_maps)

Create great mappings to convert structured data into your own format!

**Attention:** This gem is currently under development and can't be used yet!

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
The DataMaps::Mapper converts data from a ruby hash to another.

```ruby
mapper = DataMaps::Mapper.new(mapping)

converted_data = your_data.map do |data_row|
  mapper.convert(data_row)
end
```

### Mapping
Create mappings.

#### Simple field mapping
```ruby
mapping = DataMaps::Mapping.new({
  'field' => {
    from: 'source'
  }
  # or simple: 'field' => 'source'
})
```

#### Conditions
Conditions must always have a when and then command. All condition statements are executed procedural.
The only exception is when using `then: { filter: true }`, then the execution breaks immediately and removes the whole field from result data.

```ruby
  'field' => {
    from: 'source' # or array of source fields
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
    convert: {
      numeric: 'Integer'
    }
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
    convert: {
      map: {
        1: 'A',
        2: 'B'
      }
    }
  }
```

##### Possible converter

- **Converter: map**
  A simple value mapping. Maps are converted to a `HashWithIndifferentAccess`.
  Works with flat values, hashes and arrays.
  For arrays and hashes it returns nil if the value is not in the mapping. For flat values it returns the original data.

  ```ruby
    map: {
      from: to
    }
  ```
- **Converter: numeric**
  Cast data to a numeric value. Possible options are 'Integer', 'Float' or a number, then it is casted to float and rounded. Doesn't work with collections.
  Can raise an error if the value is not convertable.

  ```ruby
    numeric: 'Integer'
    numeric: 'Float'
    numeric: 2
  ```
- **Converter: String**
  Cast explicit to string. Doesn't work with collections.
  Can raise error if the value is not convertable.

  ```ruby
    string: true
  ```
- **Converter: Boolean**
  Cast explicit to bool (by double negotiation). Doesn't work with collections.
  Can return unexpected values, e.g. a double negotiated empty array is true! `!![] #=> true`

  ```ruby
    bool: true
  ```
- **Converter: keys**
  This maps the hash keys when the input data is a hash or when you select multiple *from* fields. Only works with hashes.
  Return the original data when the data isn't a hash.

  ```ruby
    keys: {
      'address1' => 'street'
    }
  ```
- **Converter: Prefix**
  This prefixes the data with a given value. Call `to_s` on data and always returns a string.

  ```ruby
    prefix: '$'
  ```
- **Converter: Postfix**
  This postfixes the data with a given value. Call `to_s` on data and always returns a string.

  ```ruby
    postfix: '€'
  ```
- **Converter: ruby**
  Apply any method on the current data object.

  ```ruby
    ruby: :upcase
    ruby: [:slice, 5]
    ruby: [:join, ', ']
  ```
- **Converter: custom**
  Define your own *converter* by defining them in the `DataMaps::Converter` module.
  Your `Converter` must implement an `execute` method. The return of this method is set as new data.
  You have to extend the `DataMaps::Converter::Base` class. Then all options are available via the `option` attribute reader.

  ```ruby
    class DataMaps::Converter::ToPersonObject < DataMaps::Converter::Base
      def execute(data)
        Person.new(data, option)
      end
    end
  ```

  ```ruby
    to_person_object: { as: :importer } # passed value are available with option
  ```

Have fun using the `DataMaps` gem :)
