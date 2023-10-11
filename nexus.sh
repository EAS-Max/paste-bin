#!/bin/bash

# Set Nexus repository URLs
SOURCE_NEXUS="source-nexus-instance:port/repository-name"
DEST_NEXUS="destination-nexus-instance:port/repository-name"

# Set login credentials
SOURCE_USER="source-username"
SOURCE_PASS="source-password"
DEST_USER="destination-username"
DEST_PASS="destination-password"

# Login to source Nexus repository
docker login "$SOURCE_NEXUS" -u "$SOURCE_USER" -p "$SOURCE_PASS"

# Login to destination Nexus repository
docker login "$DEST_NEXUS" -u "$DEST_USER" -p "$DEST_PASS"

# List of images and tags to transfer
declare -A IMAGES
IMAGES=(
    ["image1"]="tag1 tag2 tag3"
    ["image2"]="tag1 tag2"
    ["image3"]="tag1 tag2 tag3 tag4"
)

# Iterate over images and tags, pull, tag, and push
for IMAGE in "${!IMAGES[@]}"; do
    for TAG in ${IMAGES[$IMAGE]}; do
        # Pull image from source Nexus
        docker pull "$SOURCE_NEXUS/$IMAGE:$TAG"
        
        # Tag image for destination Nexus
        docker tag "$SOURCE_NEXUS/$IMAGE:$TAG" "$DEST_NEXUS/$IMAGE:$TAG"
        
        # Push image to destination Nexus
        docker push "$DEST_NEXUS/$IMAGE:$TAG"
        
        # Optional: Remove local images after push
        docker rmi "$SOURCE_NEXUS/$IMAGE:$TAG" "$DEST_NEXUS/$IMAGE:$TAG"
    done
done
