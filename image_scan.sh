#!/bin/bash

aws ecr start-image-scan --repository-name $REPOSITORY_NAME  --image-id imageTag=$IMAGE_TAG
aws ecr wait image-scan-complete --repository-name $REPOSITORY_NAME --image-id imageTag=$IMAGE_TAG

if [ $(echo $?) -eq 0 ]; then
  SCAN_FINDINGS=$(aws ecr describe-image-scan-findings --repository-name $REPOSITORY_NAME --image-id imageTag=$IMAGE_TAG | jq '.imageScanFindings.findingSeverityCounts')
  CRITICAL=$(echo $SCAN_FINDINGS | jq '.CRITICAL')
  HIGH=$(echo $SCAN_FINDINGS | jq '.HIGH')
    if [ $CRITICAL != null ] || [ $HIGH != null ]; then
      echo Docker image contains vulnerabilities at CRITICAL or HIGH level
      aws ecr batch-delete-image --repository-name $REPOSITORY_NAME --image-ids imageTag=$IMAGE_TAG
      exit 1
    fi
fi
