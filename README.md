# Overview

We need a simply way to [anonymize data](https://en.wikipedia.org/wiki/Data_anonymization)
for exporting to various departments for analytics and troubleshooting.  This tool
allows us to annotate a DB schema with special comments that can trigger
different data mutations

FakePipe

## Workflow with FakePipe

Here's how FakePipe could work in a projects lifecycle. These steps assume a
Postgres database:

1. Add comment to table column: `COMMENT ON COLUMN user.phone IS 'anon: phone_number';`.
2. Pipe DB dump to fake_pipe: `pg_dump my_db | fake_pipe > anon-db-dump.sql`.
3. Send `anon-db-dump.sql` to needy people.


## Basic Class Diagram

TODO This is subject to change!

    +---------------+       +----------------------------------+
    | Piper         |       | DatabaseAdapter/PostgresAdapter  |
    | * stdin       |       | * match comments                 |
    | * stdout      +-------> * match dml                      |
    | * main loop   |       |   * delegate.on_cell(name, cell) |
    | * def on_cell |       |                                  |
    |               |       +----------------------------------+
    |               |
    |               |       +-----------------+
    |               |       | Mutator         |
    |               +-------> * phone_number  |
    +---------------+       | * email         |
                            |                 |
                            +-----------------+

# Comment Dialect

Schema columns comments are in [YAML format](http://www.yaml.org/start.html).
Using some of it's option quoting, it can look very much like JSON. The reason
it was chosen over JSON is due for the optional quotes. That means the following
syntax will resolve to the same Ruby definition:

```
---
color: red
width: 100
```

```
{color: "red", width: 100}
```

For single options, the quotes can be omitted: `color: red`.

Any keys unknown by FakePipe will be ignored. So annotations from other system
shouldn't interfere. We do hope the abbreviated YAML syntax is simple to parse
by all systems.

## Currently Support FakePipe Methods

To get a current list try running `rake methods` from terminal.

```sh
$ rake methods
anon: email         # Faker email
anon: md5           # MD5 hash of cell contents
anon: phone_number  # Faker::PhoneNumber with digits only
```

TODO clean up README. The following is default stock from `bundle gem ...`


# Decisions
- 2016-06-08
  - parsing SQL file is okay for now. Reconsider using a temp DB when
    foreign keys need to be scrambled
  - MD5sum foreign keys


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fake_pipe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fake_pipe

## Usage


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/centro/fake_pipe.


## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).

