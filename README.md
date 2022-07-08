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

- `date`: display or set date and time
- `hostname`: set or print name of current host system
- `tr`: translate characters
- `uuidgen`: generates new UUID strings
- `uname`: Print operating system name

As a future enhancement all effort will be made to remove the need for external binaries and just utilise the built-in functons.

## Howto

...

## Examples

...

## Environment Variables

The project aims to follow the standards of the the [OpenTelemetry Environment Variable Specification](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/sdk-environment-variables.md)

The following environment variables will be currentl used:

**[General SDK Configuration](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/sdk-environment-variables.md#general-sdk-configuration)**

<!-- - `OTEL_RESOURCE_ATTRIBUTES` - Key-value pairs to be used as resource attributes -->
- `OTEL_SERVICE_NAME`: Sets the value of the `service.name` resource attribute
- `OTEL_LOG_LEVEL`: Log level used by the logger, `info|debug`

**[Exporter Selection](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/sdk-environment-variables.md#exporter-selection)**

<!-- - `OTEL_TRACES_EXPORTER`: Trace exporter to be used
- `OTEL_METRICS_EXPORTER`: Metrics exporter to be used
- `OTEL_LOGS_EXPORTER`: Logs exporter to be used -->
- `OTEL_EXPORTER_OTEL_ENDPOINT`: Exporter endpoint
