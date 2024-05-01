# Terraform-AWS-EFS-CSI-Driver
This repository contains Terraform code for deploying an AWS EFS CSI Driver.

## Getting Started

To get started, follow these instructions:

### Prerequisites

- Terraform installed on your local machine. You can download it from [here](https://www.terraform.io/downloads.html).
- An AWS account with appropriate permissions to create resources.
- Set the following Terraform variables as environment variables on your machine:

    ```bash
    export TF_VAR_cluster_name="cluster_name"
    ```


### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/mohamedezz96/Terraform-AWS-EFS-CSI-Driver.git
    ```
2. Change into the project directory:

    ```bash
    cd Terraform-AWS-EFS-CSI-Driver
    ```
3. Configurations:
      #### aws_efs_csi_driver.tf
      - `aws_efs_csi_driver_version`: The version of the EFS CSI Driver Helm Chart to use.
      - `values_file`: The path to the YAML file containing additional configuration values for the AWS EFS CSI Driver.
    
        ##### aws_efs_csi_driver.yaml
        ```yaml
        storageClasses: 
          - name: efs-sc
            annotations:
              # Use that annotation if you want this to your default storageclass
              storageclass.kubernetes.io/is-default-class: "true"
            mountOptions:
            - tls
            parameters:
              provisioningMode: "efs-ap"
              fileSystemId: "fs-08f760ed42ea4848f"
              directoryPerms: "700"
              gidRangeStart: "1000"
              gidRangeEnd: "2000"
              basePath: "/dynamic_provisioning"
              subPathPattern: "/subPath"
              ensureUniqueDirectory: "true"
            reclaimPolicy: Delete
            volumeBindingMode: Immediate
        ```
        - `fileSystemId`: File System ID you have Created, Follow This Link for creating one:
                          https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/efs-create-filesystem.md
4. Install: 

    Once configured, you can install the EFS CSI Driver by running:
    
    ```bash
    terraform init
    terraform plan
    terraform apply --auto-approve
    ```

### Usage
To test your driver follow the following steps:

1. Apply the following pvc.yaml file on your cluster:
    ```bash
    kubectl apply -f pvc.yaml
    ```
    #### pvc.yaml
    ```yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: efs-claim
    spec:
      accessModes:
        - ReadWriteMany
      storageClassName: efs-sc
      resources:
        requests:
          storage: 5Gi
    ```

2. Apply the following pod.yaml file on your cluster:
    ```bash
    kubectl apply -f pod.yaml
    ```
    #### pod.yaml
    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: efs-app
    spec:
      containers:
        - name: app
          image: centos
          command: ["/bin/sh"]
          args: ["-c", "while true; do echo $(date -u) >> /data/out; sleep 5; done"]
          volumeMounts:
            - name: persistent-storage
              mountPath: /data
      volumes:
        - name: persistent-storage
          persistentVolumeClaim:
            claimName: efs-claim
    ```

3. Check that there is a pv created on your cluster:
    ```bash
    kubectl get pv
    ```
   the output should be like this:
```bash
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM               STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-c517e00d-dfa1-4609-99d8-e7d2599cf3bc   5Gi        RWX            Retain           Bound    default/efs-claim   efs-sc         <unset>
```
    
4. Check the status of your pvc:
    ```bash
    kubectl get pvc
    ```
   the output should be like this:
```bash
NAME        STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
efs-claim   Bound    pvc-73a13bb1-5372-4fc8-8143-91f16144d3b2   5Gi        RWX            efs-sc         <unset>                 12m
```

5. Check the status of your application:
    ```bash
    kubectl get pods -o wide
    ```
   the output should be like this:
   ```bash
NAME      READY   STATUS    RESTARTS   AGE     IP             NODE                            NOMINATED NODE   READINESS GATES
efs-app   1/1     Running   0          2m52s   172.31.65.57   ip-172-31-70-202.ec2.internal   <none>           <none>
   ```
# Note

## Pod Stuck in ContainerCreating Status

If a Pod doesn't have an IP address listed, make sure that you added a mount target for the subnet that your node is in. Otherwise, the Pod won't leave ContainerCreating status. When an IP address is listed, it may take a few minutes for a Pod to reach the Running status.

## Confirming Data Write to the Volume

To confirm that the data is written to the volume, follow these steps:

1. Execute the following command to access the Pod:
   ```bash
   kubectl exec efs-app -- bash -c "cat data/out"
   ```
   The example output is as follows.
   ```bash
   [...]
    Tue Mar 23 14:29:16 UTC 2021
    Tue Mar 23 14:29:21 UTC 2021
    Tue Mar 23 14:29:26 UTC 2021
    Tue Mar 23 14:29:31 UTC 2021
    [...]
   ```
