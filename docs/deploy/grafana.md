# Grafana

Prometheus does an amazing job of collecting metrics but the dashboard and tracking is provides is rather ugly. [Grafana](https://grafana.com/) on the other make for great monitoring, dashboards, alerts, etc.

Moreover it connects very easily with Prometheus; hence you leave prometheus collect the metrics and have Grafana read those metrics to provide monitoring.

## Install

We can follow the [official documentation to install grafana on Ubuntu 20](https://grafana.com/docs/grafana/latest/installation/debian).

```
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

sudo apt-get update
sudo apt-get install grafana
```

## Run

Grafana actually create the service for you already so you can simply run it.

```
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
sudo systemctl status grafana-server
```

You can then login on port `3000`!

Click the cog icon to import Prometheus data and you're good to go; create dashboards and alerts, etc.
