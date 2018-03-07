#!/bin/bash

set -x
set -e

source script-utils/deploy-utils.bash

oc new-build --name base -D - < dockerfiles/base/Dockerfile && retry oc logs -f bc/base
oc new-build --name chipster https://github.com/chipster/chipster.git -D - < dockerfiles/chipster/Dockerfile && retry oc logs -f bc/chipster
oc new-build --name chipster-web-server https://github.com/chipster/chipster-web-server.git -D - < dockerfiles/chipster-web-server/Dockerfile  && retry oc logs -f bc/chipster-web-server
oc new-build --name chipster-web-server-js https://github.com/chipster/chipster-web-server.git -D - < dockerfiles/chipster-web-server-js/Dockerfile && retry oc logs -f bc/chipster-web-server-js
oc new-build --name toolbox https://github.com/chipster/chipster-tools.git -D - < dockerfiles/toolbox/Dockerfile && retry oc logs -f bc/toolbox
oc new-build --name web-server https://github.com/chipster/chipster-web.git -D - < dockerfiles/web-server/Dockerfile && retry oc logs -f bc/web-server
oc new-build --name comp-base -D - < dockerfiles/comp-base/Dockerfile  && retry oc logs -f bc/comp-base
oc new-build --name comp --source-image=chipster-web-server --source-image-path=/opt/chipster-web-server:chipster-web-server -D - < dockerfiles/comp/Dockerfile  && retry oc logs -f bc/comp
oc new-build --name h2 . -D - < dockerfiles/h2/Dockerfile  && retry oc logs -f bc/comp

echo ""
echo "# Build automatically on push"
echo ""
echo "# Go to the OpenShift's Configuration tab of each build which has a GitHub source, copy the Github webhook URL" 
echo "# and paste it to the GitHub's settings page of the repository. Content type should be Application/json"
echo ""
echo "# How to update builds later?"
echo ""
echo "# Replace the dockerfile with your local version"
echo "update_dockerfile BUILD_NAME"
echo ""
echo "# Build the latest github code"
echo "oc start-build bc/BUILD_NAME --follow"
echo ""
echo "# Build your local code"
echo "oc start-build BUILD_NAME --from-dir ../REPOSITORY --follow"
echo ""
echo "# Remove the build (prefer the above commands for updates instead, because this will break the GitHub webhook)"
echo "oc delete is BUILD_NAME && oc delete bc BUILD_NAME"
echo ""
