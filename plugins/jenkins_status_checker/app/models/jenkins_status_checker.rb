# frozen_string_literal: true
require 'jenkins_api_client'
require 'singleton'
# checks jenkins staging status and publishes unstable builds checklist
class JenkinsStatusChecker
  include Singleton

  URL = ENV['JENKINS_URL'] # 'https://jenkins.yourcompany.com'
  USERNAME = ENV['JENKINS_USERNAME']
  API_KEY = ENV['JENKINS_API_KEY']
  JENKINS_CHECKLIST = ENV['JENKINS_STAGING_VIEW'] # '/view/StagingStatus'

  def checklist
    items = []
    results = check_jenkins

    if results.nil?
      items << "Failed to retrieve jenkins checklist"
    else
      results["jobs"].each do |job|
        items << "#{job["name"]} is not stable" if job["color"] != "blue"
      end
    end
    items << "All projects stable!" if items.empty?
    items
  end

  private

  def check_jenkins
    client.api_get_request(JENKINS_CHECKLIST)
  rescue Timeout::Error => e
    Rails.logger.warn "Timeout while fetching jenkins checklist.  #{e.class} #{e}"
    return nil
  rescue JenkinsApi::Exceptions::ApiException => e
    # Jenkins Api threw an error at us
    Rails.logger.warn "ApiException while fetching jenkins checklist.  #{e.class} #{e}"
    return nil
  end

  def client
    @client ||= \
      JenkinsApi::Client.new(
        server_url: URL,
        username: USERNAME,
        password: API_KEY
      )
  end
end
