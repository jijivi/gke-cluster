# jijivi-gcp
IaC using Terrafrom


* Login to GCP
  ```
  gcloud auth activate-service-account --key-file=/Users/ram/Downloads/jijivi-87924690fa94.json
  gcloud config set project jijivi
  gcloud services enable container.googleapis.com
  gcloud config set compute/region us-west2
  gcloud config set compute/zone us-west2-a

  gcloud info
  ```

* Install Terraform
  ```
  brew install terraform
  ```

* Initilize and Lint
  ```
  cd src
  terraform init
  terraform fmt
  terraform validate
  ```

* Plan and apply
  ```
  terraform plan
  terraform apply
  ```