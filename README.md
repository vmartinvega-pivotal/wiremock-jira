# Metrics Kubernetes Configuration

Kubernetes configuration for the deployment of the ALM Multicloud Metrics.

## Jira Mock
* **Build**. Run the following command inside the folder with the Dockerfile
```
docker build -t registry.global.ccc.srvb.can.paas.cloudcenter.corp/c3alm-sgt/wiremock-jira .
```
* **Push**. Run the following command inside the folder with the Dockerfile
```
docker push registry.global.ccc.srvb.can.paas.cloudcenter.corp/c3alm-sgt/wiremock-jira
```

* **Run locally**.
```
docker run -it --rm -p 8080:8080 registry.global.ccc.srvb.can.paas.cloudcenter.corp/c3alm-sgt/wiremock-jira
```