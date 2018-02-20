# frozen_string_literal: true
# rubocop:disable Metrics/LineLength
require_relative '../../test/test_helper'

SingleCov.covered! uncovered: 0

describe Canideploy do
  let(:green_json_response) { '{"_class":"hudson.model.ListView","description":null,"jobs":[{"_class":"hudson.model.FreeStyleProject","name":"account_service_staging_pod998","url":"https://jenkins.test.com/job/account_service_staging_pod998/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"account_service_staging_pod999","url":"https://jenkins.test.com/job/account_service_staging_pod999/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"answer_bot_pod998_staging_status","url":"https://jenkins.test.com/job/answer_bot_pod998_staging_status/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"AppDeveloper_Staging_998_Status","url":"https://jenkins.test.com/job/AppDeveloper_Staging_998_Status/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"Voice_Staging_999_Status","url":"https://jenkins.test.com/job/Voice_Staging_999_Status/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"widget_staging_status_pod998","url":"https://jenkins.test.com/job/widget_staging_status_pod998/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"widget_staging_status_pod999","url":"https://jenkins.test.com/job/widget_staging_status_pod999/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"WIP_answer_bots_on_pod999","url":"https://jenkins.test.com/job/WIP_answer_bots_on_pod999/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"WIP_csat_predictions_pod999","url":"https://jenkins.test.com/job/WIP_csat_predictions_pod999/","color":"blue"}],"name":"StagingStatus","property":[],"url":"https://jenkins.test.com/view/StagingStatus/"}' }

  let(:red_json_response) { '{"_class":"hudson.model.ListView","description":null,"jobs":[{"_class":"hudson.model.FreeStyleProject","name":"account_service_staging_pod998","url":"https://jenkins.test.com/job/account_service_staging_pod998/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"account_service_staging_pod999","url":"https://jenkins.test.com/job/account_service_staging_pod999/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"answer_bot_pod998_staging_status","url":"https://jenkins.test.com/job/answer_bot_pod998_staging_status/","color":"red"},{"_class":"hudson.model.FreeStyleProject","name":"AppDeveloper_Staging_998_Status","url":"https://jenkins.test.com/job/AppDeveloper_Staging_998_Status/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"Voice_Staging_999_Status","url":"https://jenkins.test.com/job/Voice_Staging_999_Status/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"widget_staging_status_pod998","url":"https://jenkins.test.com/job/widget_staging_status_pod998/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"widget_staging_status_pod999","url":"https://jenkins.test.com/job/widget_staging_status_pod999/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"WIP_answer_bots_on_pod999","url":"https://jenkins.test.com/job/WIP_answer_bots_on_pod999/","color":"blue"},{"_class":"hudson.model.FreeStyleProject","name":"WIP_csat_predictions_pod999","url":"https://jenkins.test.com/job/WIP_csat_predictions_pod999/","color":"red"}],"name":"StagingStatus","property":[],"url":"https://jenkins.test.com/view/StagingStatus/"}' }

  before do
  end

  describe "initialized" do
    it "has an available singleton instance" do
      assert_instance_of Canideploy, Canideploy.instance
    end
  end

  describe "checklist" do
    before do
      stub_request(:get, "http://www.test-url.com/api/json").
        with(headers: {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Basic dXNlckB0ZXN0LmNvbTpqYXBpa2V5', 'User-Agent' => 'Ruby'}).
        to_return(status: 200, body: json_response)
    end

    describe "errors" do
      let(:json_response) { "" }

      it "handles timeout errors" do
        JenkinsApi::Client.any_instance.stubs(:api_get_request).raises(Timeout::Error)
        # returns error msg
        message = ["Failed to retrieve jenkins checklist"]
        assert_equal(message, Canideploy.instance.checklist)
      end

      it "handles api errors" do
        # needs a logger to instantiate
        JenkinsApi::Client.any_instance.stubs(:api_get_request).raises(JenkinsApi::Exceptions::ApiException.new(Rails.logger))
        # returns error msg
        message = ["Failed to retrieve jenkins checklist"]
        assert_equal(message, Canideploy.instance.checklist)
      end
    end

    describe "no failing jobs" do
      let(:json_response) { green_json_response }
      it "parses the response" do
        # returns no failure message
        message = ['No failing builds :)']
        assert_equal(message, Canideploy.instance.checklist)
      end
    end

    describe "failing jobs" do
      let(:json_response) { red_json_response }
      it "parses the response" do
        # returns checklist of red jobs
        message = ["answer_bot_pod998_staging_status is not stable", "WIP_csat_predictions_pod999 is not stable"]
        assert_equal(message, Canideploy.instance.checklist)
      end
    end
  end
end
# rubocop:enable Metrics/LineLength
# rubocop:enable Layout/IndentHeredoc
