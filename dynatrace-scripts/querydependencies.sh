#!/bin/bash
# Bash Script that will return the number of dependencies of the first entity that matches the tag
# This can be called from Jenkins like this
# DYNATRACE_DEPENDENCY_COUNT = sh (script: './dynatrace-scripts/querydependencies.sh SERVICE [Contextless]DeploymentGroup:Staging toRelationships calls', returnStatus)
# DYNATRACE_DEPENDENCY_COUNT = sh (script: './dynatrace-scripts/querydependencies.sh PROCESS-GROUP [Environment]Sample-NodeJs-Service fromRelationships runsOn', returnStatus)

# Either set your Dynatrace Token and URL in this script or pass it as Env Variables to this Shell Script
# DT_TOKEN=YOURAPITOKEN
# DT_URL=https://YOURTENANT.live.dynatrace.com

REST_URL = ""
if [ "$1" -eq "HOST" ]; then
    REST_URL = "/api/v1/entity/infrastructure/hosts"
fi
if [ "$1" -eq "PROCESS-GROUP" ]; then
    REST_URL = "/api/v1/entity/infrastructure/process-groups"
fi
if [ "$1" -eq "SERVICE" ]; then
    REST_URL = "/api/v1/entity/services"
fi
if [ "$1" -eq "APPLICATION" ]; then
    REST_URL = "/api/v1/entity/applications"
fi

output=$(curl -H "Content-Type: application/json" -H "Authorization: Api-Token ${DT_TOKEN}" -X GET ${DT_URL}${REST_URL}?tag=$2)
echo $output | python -c 'import json,sys;obj=json.load(sys.stdin);if(obj.length > 0): print(obj[0][\"$3\"][\"$4\"].length);'