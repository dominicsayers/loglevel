# loglevel
Control logging at runtime with an environment variable

Usage:

```sh
LOGLEVEL=WARN rails server
```

### Features

Control which components create visible log entries by simply setting an
environment variable. For instance:

```sh
LOGLEVEL=DEBUG,NOAR,NOHTTP rails server
```

would set the Rails logger level to `:debug` but would suppress messages from
the ActiveRecord logger and the HttpLogger gem.

The full range of features is itemized if you use the `HELP` option:

```sh
LOGLEVEL=HELP rails server
```

### Dependencies

The examples in this document assume Loglevel is being used in a Rails
environment but it doesn't depend on Rails and can be used in other contexts.
