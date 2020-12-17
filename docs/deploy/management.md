---
title: Management
summary: Manage the Prometheus server.
authors:
    - John Coene
---

# Management

There are different ways to manage the Prometheus server. The package provides utility functions to do so via various Prometheus endpoints.

!!! tip
    All Management-related functions start with a capital letter.

## Reload

One the [Prometheus server deployed](/deploy/prometheus), when changes are made to the configuration file `prometheus.yml` you must tell Prometheus to reload the file or the changes are not taken into account.

```r
PromReload()
```

!!! tip 
    This requires the flag `--web.enable-lifecycle` when launching the Prometheus service

## Health

You can check the health of the Prometheus service with.

```r
PromHealthy()
```

## Ready

You can check whether Prometeus is ready to serve traffic (i.e. respond to queries).

```r
PromReady()
```

## Quit

You can gracefully shut down the service with. By default it prompts the user for an input to confirm the action.

```r
PromQuit()
```

!!! tip 
    This requires the flag `--web.enable-lifecycle` when launching the Prometheus service

## Defaults

By default the management functions assume the Prometheus server is hosted at the `PROMETHEUS_URL` environment variable and if that is not set default to `http://localhost:9090`.
