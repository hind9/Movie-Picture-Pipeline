#!/bin/bash
set -e -o pipefail

echo "Fetching IAM github-action-user ARN"
userarn=$(aws iam get-user --user-name github-action-user --query 'User.Arn' --output text)

echo "Updating kubeconfig for EKS cluster"
aws eks update-kubeconfig --region us-east-1 --name cluster

echo "Adding github-action-user to aws-auth ConfigMap"

kubectl patch configmap aws-auth -n kube-system --type='merge' -p "{
  \"data\": {
    \"mapUsers\": \"$(kubectl get configmap aws-auth -n kube-system -o jsonpath='{.data.mapUsers}')\n- userarn: $userarn\n  username: github-action-role\n  groups:\n    - system:masters\"
  }
}"

echo "Done! github-action-user added to system:masters"
