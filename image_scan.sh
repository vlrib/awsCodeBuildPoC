#!/bin/bash

aws ecr start-image-scan --repository-name $IMAGE_REPO_NAME  --image-id imageTag=$IMAGE_TAG
aws ecr wait image-scan-complete --repository-name $IMAGE_REPO_NAME --image-id imageTag=$IMAGE_TAG

if [ $(echo $?) -eq 0 ]; then
  SCAN_FINDINGS=$(aws ecr describe-image-scan-findings --repository-name $IMAGE_REPO_NAME --image-id imageTag=$IMAGE_TAG | jq '.imageScanFindings.findingSeverityCounts')
  CRITICAL=$(echo $SCAN_FINDINGS | jq '.CRITICAL')
  HIGH=$(echo $SCAN_FINDINGS | jq '.HIGH')
    if [ $CRITICAL != null ] || [ $HIGH != null ]; then
      echo Docker image contains vulnerabilities at CRITICAL or HIGH level
      PIPELINE_EXECUTION_ID=$(aws codepipeline list-pipeline-executions --pipeline-name poc-ws | jq '.pipelineExecutionSummaries[0].pipelineExecutionId' | sed 's/"//g')
      #aws ecr batch-delete-image --repository-name $IMAGE_REPO_NAME --image-ids imageTag=$IMAGE_TAG
      aws codepipeline stop-pipeline-execution --pipeline-name poc-ws --pipeline-execution-id $PIPELINE_EXECUTION_ID --abandon --reason "Stopping execution for find image vulnerability"
      exit 1
    fi
fi
