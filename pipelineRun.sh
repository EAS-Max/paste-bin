#!/bin/bash

# Variables
NAMESPACE="your-namespace" # The namespace of your Tekton pipeline
ISSUE_ID="your-issue-id"   # The GitHub issue ID to match

# Function to get the pipeline run name by matching spec.params
get_pipeline_run_name_by_param() {
  oc get pipelinerun -n "$NAMESPACE" -o json | jq -r \
    --arg ISSUE_ID "$ISSUE_ID" \
    '.items[] | select(.spec.params[] | select(.name == "issue-id" and .value == $ISSUE_ID)).metadata.name'
}

# Retrieve the pipeline run name
PIPELINE_RUN_NAME=$(get_pipeline_run_name_by_param)

# Check if we got a pipeline run name
if [ -n "$PIPELINE_RUN_NAME" ]; then
  echo "Pipeline run name matching issue ID $ISSUE_ID: $PIPELINE_RUN_NAME"
else
  echo "No pipeline run found for issue ID $ISSUE_ID"
  exit 1
fi

# PIPELINE_RUN_NAME=$(oc get pipelinerun -n your-namespace -o jsonpath="{.items[?(@.spec.params[?(@.name=='issue_id')].value=='YOUR_ISSUE_ID')].metadata.name}")
