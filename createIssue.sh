#!/bin/bash

# Variables
TOKEN="YOUR_GITHUB_TOKEN"
REPO="username/repository"
TITLE="Issue Title"
BODY="Issue Description"
API_URL="https://api.github.com/repos/$REPO/issues"

# Create Issue
create_issue() {
    curl -s -X POST "$API_URL" \
    -H "Authorization: token $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "'"$TITLE"'",
        "body": "'"$BODY"'"
    }'
}

# Execute the function
create_issue

# s/"/\\"/g; s/$/\\n/; s/\\n$//

# ISSUE_NUMBER=$(echo "$RESPONSE" | grep -o '"number": [0-9]*' | awk '{print $2}')

