DataMaps [![build status](https://gitlab-ci.sys.mixxt.net/projects/11/status.png?ref=master)](https://gitlab-ci.sys.mixxt.net/projects/11?ref=master)
=================

Create great mappings to convert structured data into your own format!

**Attention:** This gem is currently under development and can't used yet!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'data_maps'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install data_maps

## Usage

### Mapper
The DataMas::Mapper only works with a ruby Hash.

```ruby
mapper = DataMaps::Mapper.new(mapping)

converted_data = your_data.map do |data_row|
  mapper.convert(data_row)
end
```

### Mapping
Create mappings

#### Simple field mapping
```ruby
mapping = DataMaps::Mapping.new({
  'field' => {
    from: 'source'
  }
  # or simpler 'field' => 'source'
})

#### Conditions
Conditions must have a when and then command always. All converters will be ignored if any condition is true.
All condition statements executed procedural. But when your condition says `break: true` the traversal stopped immediately after this condition match.
The only exception when using `then: { filter: true }`, then execution breaks immediately and remove the whole field from result.

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

- **Condition: empty**
  Possible Options for the empty conditions are `true` or `false`.
  The condition is true when `data.empty? == result`

  ```ruby
    empty: result # true or false
  ```
- **Condition: regex**
  Define a regular expression condition.
  The condition is true when `data.match regex`

  ```ruby
    regex: /[a-z]/i
  ```
- **Condition: gt, gte**
  Check if data is *greater* or *greater or equal* then the given value.

  ```ruby
    gt: 5
    gte 5
  ```
- **Condition: lt**
  Check if data is *lower* or *lower or equal* then the given value.

  ```ruby
    lt: 5
    lte: 5
  ```
- **Condition: eq, neq**
  Check if data is *equal* or *not equal* to the given value.

  ```ruby
    eq: 10
    neq: 'a-value'
  ```
- **Condition: in, nin**
  Check if data is *in* or *not in* the set of given values.

  ```ruby
    in: ['a', 'b', 'c']
    nin: ['x', 'y', 'z']
  ```
- **Condition: custom**
  Define your own condition class by Monkeypatch them into the `DataMaps::When` module.
  Your condition must implement a `check` method which returns `true` or `false`.
  When your class extends the `DataMaps::When::Base`-Class all options are available via the `option` attribute reader.

  ```ruby
    class DataMaps::When::isZip < DataMaps::When::Base
      def check(data)
        !!data.match(/\d{5}/)
      end
    end
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
  When this is set to true, then the whole field will filtered.

  ```ruby
    filter: true
  ```
- **Then: custom**
  Define your own *then* by Monkeypatch them into the `DataMaps::Then` module.
  Your Then must implement a `result` method. The return of this method is set as data.
  When your class extends the `DataMaps::Then::Base`-Class all options are available via the `option` attribute reader.

  ```ruby
    class DataMaps::Then::doSomethingSpecial < DataMaps::Then::Base
      def result(data)
        data + '€'
      end
    end
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
  A simple value mapping. Maps are converted to a HashWithIndifferentAccess.
  Works with flat values, Hashes and arrays.

  ```ruby
    map: {
      from: to
    }
  ```
- **Converter: numeric**
  Cast data to a numeric value. Possible options are 'Integer', 'Float' or a number, then it is casted to float and rounded.

  ```ruby
    numeric: 'Integer'
    numeric: 'Float'
    numeric: 2
  ```
- **Converter: String**
  Cast explicit to string

  ```ruby
    string: true
  ```
- **Converter: Boolean**
  Cast explicit to bool

  ```ruby
    bool: true
  ```
- **Converter: keys**
  This map the hash keys when the input data is a hash or when you select multiple *from* fields.

  ```ruby
    keys: {
      'address1' => 'street'
    }
  ```
- **Converter: Prefix**
  This prefixes the data with given value. Returns a String

  ```ruby
    prefix: '$'
  ```
- **Converter: Postfix**
  This postfixes the data with given value. Returns a String

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

Have fun using the `DataMaps` gem :)
