# Integration suite shape

A shape that works for a cross-service suite: Cucumber feature files describing
behaviour in the customer's language, steps that drive real dependencies, and one configuration
file per environment selected by `ENV`.

```
features/
  portfolio-summary.feature      one file per area, scenarios named for their US
src/
  steps/                         step definitions
  support/                       clients for database, HTTP, file transfer
configs/
  config-local.yaml
  config-sit.yaml
fixtures/                        readable input data
```

Run with `make test-integration ENV=sit`, which reads `configs/config-sit.yaml`. Nothing about
an environment is hard-coded into a step - if a host or credential appears in a step file, it
belongs in the config.
