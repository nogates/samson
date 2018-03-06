# frozen_string_literal: true
module SamsonJenkinsStatusChecker
  class Engine < Rails::Engine
  end
end

Samson::Hooks.view :deploy_form, "samson_jenkins_status_checker/deploys_form"
