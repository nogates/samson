# frozen_string_literal: true
require 'jenkins_api_client'
require 'singleton'
# checks jenkins staging status and publishes unstable builds checklist
class JenkinsStatusChecker
  include Singleton

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
    client.api_get_request(ENV.fetch('JENKINS_STAGING_VIEW'))
  rescue KeyError => e
    Rails.logger.warn "Missing ENV variable for jenkins #{e}"
    return nil
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
        server_url: ENV.fetch('JENKINS_URL'),
        username: ENV.fetch('JENKINS_USERNAME'),
        password: ENV.fetch('JENKINS_API_KEY')
      )
  end
end
