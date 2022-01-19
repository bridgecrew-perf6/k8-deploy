# k8-deploy

This projects implements deploying an express app to Google Kubernetes Engine (GKE) using Terraform to configure GKE and Github Actions to run CI jobs.

The app can be accessed at https://k8-deploy.otseobande.com

# Terraform Config

Terraform configuration files can be found in the `infra/terraform` directory. This specifies a Google provider and uses Google Storage bucket as a backend to sync Terraform state. The Terraform team provided a detailed guide to integrate with GCP in their [GCP learning resources](https://learn.hashicorp.com/collections/terraform/gcp-get-started).

# Kubernetes Config using Helm

Kubernetes manifest files are managed with a Helm chart which allows us to create manifest templates with variables which we can change at deploy time. The chart can be found at `infra/service-chart`. Helm also helps to manage dependencies for the Kubernetes cluster. For this project, ingress-nginx and cert-manager were installed using Helm to add SSL certificate management to the cluster.

To deploy the application manually:


- Use the [Kubernetes documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) and install Kubectl
- Follow this [detailed guide](https://helm.sh/docs/intro/install/) to install Helm on your machine.
- [Configure kubectl access to the Kuberenetes cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl)
- Run this command from the project directory

  ```bash
  helm upgrade --install --atomic --timeout 20m \
    -f deployment-values.yml \
    --set image.tag=latest \
    k8-deploy infra/service-chart
  ```

  This deploys a new version of the application to the kubernetes cluster.
# Getting full insight into Kubernetes resource deployment

Helm helps to manage the kubernetes cluster state well but during upgrades things can fail. We use Helm's `--atomic` flag to rollback the cluster state. We are however not able to see the errors or reasons for failure until we perform an inspection of the cluster ourselves. To ease this process and give more visibility into the upgrade process, [Werf](https://werf.io/) is used along with Helm.
