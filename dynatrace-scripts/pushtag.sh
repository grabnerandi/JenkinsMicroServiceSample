#!/bin/bash
# Bash Script that will push a custom deployment event to Dynatrace. Here is an example on how to call it
# ./pushtag.sh JenkinsTutorial DemoDeploy 1.0 MyProject Jenkins http://myjenkins http://myjenkins/job http://myjenins/build gitcommitid
# or when called from Jenkins it could be like this
# ./home/ec2-user/pushtag.sh JenkinsTutorial ${BUILD_TAG} ${BUILD_NUMBER} ${JOB_NAME} Jenkins ${JENKINS_URL} ${JOB_URL} ${BUILD_URL} ${GIT_COMMIT}

# Either set your Dynatrace Token and URL in this script or pass it as Env Variables to this Shell Script
# DT_TOKEN=YOURAPITOKEN
# DT_URL=https://YOURTENANT.live.dynatrace.com

PAYLOAD=$(cat <<EOF
{
  "eventType": "CUSTOM_DEPLOYMENT",
  "attachRules" : {
    "tagRule" : [
      {
        "meTypes" : ["HOST"],
        "tags" : [
          {
            "context" : "AWS",
            "key" : "Environment",
            "value" : "$1"
          }]
      }]
  },
  "deploymentName" : "$2",
  "deploymentVersion" : "$3",
  "deploymentProject" : "$4",
  "source" : "$5",
  "ciBackLink" : "$6",
  "customProperties" : {
    "JenkinsUrl" : "$7",
    "BuildUrl" : "$8",
    "GitCommit" : "$9"
  }
}
EOF
)

echo $PAYLOAD
echo ${DT_URL}/api/v1/events
curl -H "Content-Type: application/json" -H "Authorization: Api-Token ${DT_TOKEN}" -X POST -d "${PAYLOAD}" ${DT_URL}/api/v1/events