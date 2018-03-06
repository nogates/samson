### Description

This plugin shows failing jenkins jobs when users try to create a new deploy. This only shows for production, same rules as the buddy check. It shares the jenkins credentials of the jenkins plugin.

### Setup

Required Environment Variables (see .env.example)
JENKINS_STATUS_CHECKER # set to true for projects that require this check
JENKINS_URL            # 'https://jenkins.yourcompany.com', should already be set by jenkins plugin
JENKINS_USERNAME	   # should already be set by jenkins plugin
JENKINS_API_KEY		   # should already be set by jenkins plugin
JENKINS_STAGING_VIEW   # '/view/StagingStatus'
