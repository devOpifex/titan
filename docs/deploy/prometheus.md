# Prometheus

Serving metrics with titan is only part of the story. Once those are served one must set up and deploy Prometheus so it can scrape those results.

There are a few ways in which Prometheus can be deployed. The easiest I find is simply to install the binary and run is a service, this way it automatically restarts when the server reboots, etc.

## Installation

Below we download the zipped [latest release](https://prometheus.io/download/) (at the time of writing this v2.23.0).

```bash
wget https://github.com/prometheus/prometheus/releases/download/v2.23.0/prometheus-2.23.0.linux-amd64.tar.gz

tar xvfz prometheus-2.23.0.linux-amd64.tar.gz
mv prometheus-2.23.0.linux-amd64 prometheus
```

This downloads, unzips the files necessary to run Prometheus, then renames the directory from `prometheus-2.23.0.linux-amd64` to `prometheus`. Next you can move into that directory and run Prometheus manually to make sure all works well.

```bash
cd ./prometheus
./prometheus
```

This should run prometheus and make it available on port `9090` by default and you should be able to see prometheus running at `<server-ip>:9090`. If you do not make sure that port `9090` is open on your server.

The `prometheus.yml` file contains the "targets" to scrape, that is the plumber APIs and shiny applications to scrape the metrics.

## Service

We can create a new service to easily have Prometheus run in the background, restart when needed, etc.

```
vi /etc/systemd/system/prometheus.service
```

In that service place the following.

```
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=root
ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/prometheus/prometheus \
  --config.file=/prometheus/prometheus.yml \
  --web.enable-lifecycle

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target
```

This essentially will create a new service, very similar to shiny-server. Note the use of `--web.enable-lifecycle` to reload the configuration file by executing a `POST` query.

This creates the service it can then be run after reloading the daemon.

```
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
```

Running `sudo systemctl status prometheus` will show whether the service is running correctly.

## Configuration file

We have yet to explore the configuration file. Below is an example of a job to scrape a shiny application.

```yml
scrape_configs:
  - job_name: my-application
    scheme: 'http'
    targets: ['shiny-server.com']
    metrics_path: 'myapp/metrics'
    basic_auth:
      username: titan
      password: secret2020!
  - job_name: my-other-application
    scheme: 'http'
    targets: ['shiny-server.com']
    metrics_path: 'anotherApp/metrics'
    basic_auth:
      username: myName
      password: securePassword
```

## Reload Configuration

Once changes have been made to the configuration we must tell prometheus to reload it. Since we set the flag `--web.enable-lifecycle` when launching the Prometheus service we can simply make a `POST` request to the `/-/reload` endpoint of Prometheus to reload the configuration file.

```
curl -X POST http://localhost:9090/-/reload
```

There is a convenience function in titan to do so from R.

```r
PromReload("http://localhost:9090")
```

!!! tip
    All functions that pertain to the Management of the Prometheus
    server start with a capital letter. 

From there onwards it's just a matter of adding jobs to the configuration file and reload it.

Happy tracking!
