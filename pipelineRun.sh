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
#  JQ solution
# PIPELINE_RUN_NAME=$(oc get pipelinerun -n your-namespace -o json | jq -r '.items[] | select(.spec.params[] | select(.name=="issue_id" and .value=="YOUR_ISSUE_ID")).metadata.name')
# echo $PIPELINE_RUN_NAME
# Wait for the PipelineRun to complete
oc wait --for=condition=Succeeded --timeout=600s pipelinerun/$PIPELINE_RUN_NAME -n $NAMESPACE

# Get the status of the PipelineRun
STATUS=$(oc get pipelinerun $PIPELINE_RUN_NAME -n $NAMESPACE -o jsonpath='{.status.conditions[?(@.type=="Succeeded")].status}')

# Check if the PipelineRun was successful
if [ "$STATUS" == "True" ]; then
  echo "PipelineRun succeeded."
  # You can capture other details here if needed
elif [ "$STATUS" == "False" ]; then
  echo "PipelineRun failed."
  # Capture the failure details
  REASON=$(oc get pipelinerun $PIPELINE_RUN_NAME -n $NAMESPACE -o jsonpath='{.status.conditions[?(@.type=="Succeeded")].reason}')
  MESSAGE=$(oc get pipelinerun $PIPELINE_RUN_NAME -n $NAMESPACE -o jsonpath='{.status.conditions[?(@.type=="Succeeded")].message}')
  echo "Reason: $REASON"
  echo "Message: $MESSAGE"
else
  echo "PipelineRun did not complete within the timeout period."
fi



# FAILED_TASKS=$(oc get pipelinerun $PIPELINE_RUN_NAME -n $NAMESPACE -o jsonpath='{range .status.taskRuns[*]}{.status.conditions[?(@.type=="Succeeded")].status=="False"}{.pipelineTaskName}{"\n"}{end}')
#   for TASK in $FAILED_TASKS; do
#     echo "Task $TASK failed."
#     # Extract more details or logs for the failed task
#     TASK_LOG=$(oc logs $PIPELINE_RUN_NAME-$TASK -n $NAMESPACE --all-containers)
#     echo "Logs for Task $TASK:"
#     echo "$TASK_LOG"
#   done
