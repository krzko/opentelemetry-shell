# opentelemetry-shell

**Logs**, **metrics**, and **traces** are often known as the three pillars of observability. We take great care to ensure we cover these pillars in our services.

But, underpinning these services is usually a script. `Bash` has been around for many decades now and other shells for even longer. This is usually the glue that ensures we can manage, deploy and perform many tasks around the services that we develop.

Why not ensure that these scripts are observable and send back telemery data as well? This is the aim of [opentelemetry.sh](https://opentelemetry.io/), a set of [OpenTelemetry](https://opentelemetry.io/) functions for shells.

The functions utilise the [OpenTelemetry Protocol Specification (OTLP)](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/otlp.md) to send telemtry data back to any service that supports [OTLP (HTTP)](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/otlp.md#otlphttp). This is traditionally via an [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/) or a vendor that supports this API specification.

## Requirements

These functions have been tested on several `bash` versions, the list is as follows:

- `3.x`
- `4.x`
- `5.x`

Other versions and shells, your mileage may vary.

Whilst all effort has been made to limit the use of external binaries from the standard `bash` built-in commands, this is the list of binaries required or this library:

- `curl`: a tool for transfering data from or to a server
- `date`: display or set date and time
- `hostname`: set or print name of current host system
- `jq`: Command-line JSON processor
- `uname`: Print operating system name

As a future enhancement all effort will be made to remove the need for as many external binaries as possible and just utilise the built-in functions.

## Supported Specifications

Whilst the specifications [OpenTelemetry Protocol Specification (OTLP)](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/otlp.md) are extensive and too much to implementint in their entirety in a shell environment, a select few have been added, and will continue to expand as time goes on.

The following features are supported.

### Logs

Yet to be implenented.

### Metrics

You can currently create the following metric types;

- Gauge, double and int values
- Sum, double and int values

### Traces

Tracing is supported with a rudimentory, parent/child relationship. The following attributes are being associated to each span:

- Calling function, whether in main() or an outer function
- Invoked command within script
- Invoking line number wihtin script
- Script name
- Line number
- Custom attributes can be applied via an associative'esque array

## Howto

The easiest way to get started is to clone the respository and then `.` source the functions you need. More [examples](#examples) follow after this basic howto.

```sh
git@github.com:krzko/opentelemetry-shell.git
```

Once cloned in your shell script you can simple `.` source as follows, assuming the script is a level down from `library`:

```sh
#!/usr/bin/env bash

# Service variables
service_version="0.0.1-dev"

# Import functions
. opentelemetry-shell/library/log.sh
. opentelemetry-shell/library/otel_trace.sh

# Functions
sleep_for() {
  local sec=$1

  log_info "Sleeping for ${sec} sec..."
  sleep $sec
}

# Start a parent span
otel_trace_start_parent_span sleep_for 1
# Start a child span, associatd to the parent
otel_trace_start_child_span sleep_for 2

log_info "TraceId: ${TRACE_ID}"
```

## Examples

A set of examples have been created to show case the ease of use, in creating traces and custom metrics. Please have a look at the [examples](https://github.com/krzko/opentelemetry-shell/tree/main/examples).

## Environment Variables

The project aims to follow the standards of the the [OpenTelemetry Environment Variable Specification](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/sdk-environment-variables.md)

The following environment variables will be currentl used:

**[General SDK Configuration](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/sdk-environment-variables.md#general-sdk-configuration)**

<!-- - `OTEL_RESOURCE_ATTRIBUTES` - Key-value pairs to be used as resource attributes -->
- `OTEL_SERVICE_NAME`: Sets the value of the `service.name` resource attribute
- `OTEL_LOG_LEVEL`: Log level used by the logger, `debug`. Unset variable to disable verbose logging

**[Exporter Selection](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/sdk-environment-variables.md#exporter-selection)**

<!-- - `OTEL_TRACES_EXPORTER`: Trace exporter to be used
- `OTEL_METRICS_EXPORTER`: Metrics exporter to be used
- `OTEL_LOGS_EXPORTER`: Logs exporter to be used -->
- `OTEL_EXPORTER_OTEL_ENDPOINT`: Exporter endpoint
