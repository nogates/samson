### Description

This plugin shows failing jenkins jobs when users try to create a new deploy. This only shows for production, same rules as the buddy check. It shares the jenkins credentials with the jenkins plugin.

### Setup

1. Required Environment Variables (see .env.example)

JENKINS_STATUS_CHECKER # /view/StagingStatus, the checklist view
JENKINS_URL            # 'https://jenkins.yourcompany.com', shared by jenkins plugin
JENKINS_USERNAME       # shared by jenkins plugin
JENKINS_API_KEY        # shared by jenkins plugin

2. Enable plugin on a per project basis by ticking the checkbox at `projects/[your-project]/edit`
