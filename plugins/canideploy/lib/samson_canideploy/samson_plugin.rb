# frozen_string_literal: true
module SamsonCanideploy
  class Engine < Rails::Engine
  end
end

Samson::Hooks.view :deploy_new, "samson_canideploy/deploys_new"
