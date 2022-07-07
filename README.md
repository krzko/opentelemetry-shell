# opentelemetry-shell

🚦 OpenTelemetry functions for shells

## Why

...

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

[Exporter Selection](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/sdk-environment-variables.md#exporter-selection)

<!-- - `OTEL_TRACES_EXPORTER`: Trace exporter to be used
- `OTEL_METRICS_EXPORTER`: Metrics exporter to be used
- `OTEL_LOGS_EXPORTER`: Logs exporter to be used -->
- `OTEL_EXPORTER_OTEL_ENDPOINT`: Exporter endpoint
