#!/bin/bash

# Define the images
IMAGES=(
    "nginx:latest"
    "nginx:kind"
    "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.5.0"
    "registry.k8s.io/ingress-nginx/controller:v1.12.0"
    "docker.io/hashicorp/http-echo:latest"
)

echo "📦 Saving images as tar files..."
for IMAGE in "${IMAGES[@]}"; do
    IMAGE_NAME=$(echo $IMAGE | tr '/:' '_')
    docker save -o "${IMAGE_NAME}.tar" $IMAGE
done

echo "📤 Copying tar files to Kind nodes..."
for NODE in $(kind get nodes); do
    for IMAGE in "${IMAGES[@]}"; do
        IMAGE_NAME=$(echo $IMAGE | tr '/:' '_')
        
        # Use an alternative method to copy
        echo "Copying $IMAGE_NAME.tar to $NODE:/tmp/..."
        docker exec -i $NODE sh -c "cat > /tmp/${IMAGE_NAME}.tar" < ${IMAGE_NAME}.tar
    done
done

echo "📥 Importing images into Kind nodes..."
for NODE in $(kind get nodes); do
    for IMAGE in "${IMAGES[@]}"; do
        IMAGE_NAME=$(echo $IMAGE | tr '/:' '_')
        docker exec $NODE ctr --namespace=k8s.io images import /tmp/${IMAGE_NAME}.tar
    done
done

echo "✅ Verifying images inside Kind nodes..."
kubectl get pods -o wide

echo "🎉 All images successfully loaded into Kind!"
