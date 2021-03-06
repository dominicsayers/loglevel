## Loglevel

[![Gem version](https://badge.fury.io/rb/loglevel.svg)](https://rubygems.org/gems/loglevel)
[![Gem downloads](https://img.shields.io/gem/dt/loglevel.svg)](https://rubygems.org/gems/loglevel)
[![Build Status](https://travis-ci.org/dominicsayers/loglevel.svg?branch=master)](https://travis-ci.org/dominicsayers/loglevel)
[![Code Climate](https://codeclimate.com/github/dominicsayers/loglevel/badges/gpa.svg)](https://codeclimate.com/github/dominicsayers/loglevel)
[![Test Coverage](https://codeclimate.com/github/dominicsayers/loglevel/badges/coverage.svg)](https://codeclimate.com/github/dominicsayers/loglevel/coverage)
[![Dependency Status](https://gemnasium.com/badges/github.com/dominicsayers/loglevel.svg)](https://gemnasium.com/github.com/dominicsayers/loglevel)
[![Security](https://hakiri.io/github/dominicsayers/loglevel/master.svg)](https://hakiri.io/github/dominicsayers/loglevel/master)

Control logging at runtime with an environment variable

Usage:

```sh
LOGLEVEL=WARN rails server
```

Loglevel will direct your logging to `STDOUT` (as suggested in
[the 12-factor app](https://12factor.net/logs)). See the Log Device section
below for how to control where your logging goes.

### Features

Control which components create visible log entries by simply setting an
environment variable. For instance:

```sh
LOGLEVEL=DEBUG,NOAR,NOHTTP rails server
```

would set the Rails logger level to `:debug` but would suppress messages from
the ActiveRecord logger and the HttpLogger gem.

Here are the available settings:

| Option    | Description                                 |
| --------- | ------------------------------------------- |
| FATAL     | Equivalent to config.log_level = :fatal     |
| ERROR     | Equivalent to config.log_level = :error     |
| WARN      | Equivalent to config.log_level = :warn      |
| INFO      | Equivalent to config.log_level = :info      |
| DEBUG     | Equivalent to config.log_level = :debug     |
| NOAR      | Do not show ActiveRecord messages           |
| NOHTTP    | Do not show HTTP messages                   |
| NOHEADERS | Do not include response headers in HTTP log |
| NOBODY    | Do not include response body in HTTP log    |

### Dependencies

The examples in this document assume Loglevel is being used in a Rails
environment but it doesn't depend on Rails and can be used in other contexts.

There are specific options to handle Railsy logging scenarios: things like
controlling ActiveRecord logging. There are also specific options for handling
the HttpLogger gem.

### Rails initialization

In a Rails context, we want Loglevel to be configured *after* Rails's own logger
has been initialized but before any other app initialization has taken place.
This allows us to control the logging of other components' initialization.

The best way I have found of doing this is to create a script in the
`config/initializers` directory. These initializers are executed in alphabetical
order so you can control when Loglevel is initialized by carefully naming your
script.

To initialize Loglevel first, create a script called `01_loglevel.rb` with the
single line

```
Loglevel.setup
```

To understand which other points in the Rails initialization process you can
choose, see [The Rails Initialization Process](http://guides.rubyonrails.org/initialization.html).

### Logger

By default Loglevel will instantiate Ruby's default Logger class (in a Rails
context this will be something like ActiveSupport::TaggedLogging). If you want to
use a different logger then you can use an environment variable to tell Loglevel
which logger you use:

```sh
LOGLEVEL_LOGGER=Log4r LOGLEVEL=DEBUG rails server
```

### Log device

By default Loglevel will setup logging to the `STDOUT` device. If you want to
use a different device there's an environment variable for that:

```sh
LOGLEVEL_DEVICE=tmp/test.log LOGLEVEL=DEBUG rails server
```

### Classes with a logger

By default, Loglevel will setup the logger for Rails, ActiveRecord::Base and
HttpLogger if they are present.

It will also setup logging for any other classes that you include in an
environment variable:

```sh
LOGLEVEL_CLASSES=MyClass LOGLEVEL=DEBUG rails server
```

The only methods the class must support are `logger` and `logger=`

### Contributing

[![Developer](http://img.shields.io/badge/developer-awesome-brightgreen.svg?style=flat)](https://www.dominicsayers.com)

1.  Fork it
1.  Create your feature branch (`git checkout -b my-new-feature`)
1.  Commit your changes (`git commit -am 'Add some feature'`)
1.  Push to the branch (`git push origin my-new-feature`)
1.  Create new Pull Request
