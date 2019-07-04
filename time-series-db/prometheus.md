# prometheus tsdb stack

## introduce



## install

- source

- binary

location:
`https://github.com/prometheus/prometheus/releases/download/v2.10.0/prometheus-2.10.0.linux-amd64.tar.gz`


- docker

```
docker run -p 9090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml \
       prom/prometheus
```

- customized docker

new image like:

```
FROM prom/prometheus
ADD prometheus.yml /etc/prometheus/
```

then build and run

```
docker build -t my-prometheus .
docker run -p 9090:9090 my-prometheus
```

## basic config

the basic config file is located:`/etc/prometheus/prometheus.yml`

```
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    monitor: 'codelab-monitor'

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    static_configs:
      - targets: ['localhost:9090']
```

## work with ...

- Ansible
Cloud Alchemy/ansible-prometheus

- saltstack
arnisoph/saltstack-prometheus-formula