#!/bin/bash

# Configuration variables
REPO_URL="https://github.com/your_username/your_repo.git"  # Replace with your repository URL
NEW_BRANCH="update-yaml-branch"
FILE_PATH="path/to/your/file.yaml"
TEMPLATE_PATH="path/to/your/template.yaml"

# Clone the repository
git clone $REPO_URL
cd $(basename $_ .git)

# Create and switch to a new branch
git checkout -b $NEW_BRANCH

# Copy the template to overwrite the YAML file
cp $TEMPLATE_PATH $FILE_PATH

# Add, commit, and push the changes
git add $FILE_PATH
git commit -m "Update YAML file"
git push origin $NEW_BRANCH

# Create a pull request
gh pr create --base main --head $NEW_BRANCH --title "Update YAML file" --body "This PR updates the YAML file with new changes."

echo "Pull request created."
