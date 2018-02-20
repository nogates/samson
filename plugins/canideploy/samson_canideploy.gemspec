# frozen_string_literal: true
Gem::Specification.new 'samson_canideploy', '0.0.0' do |s|
  s.summary = 'Samson canideploy plugin'
  s.authors = ['Yi Fei Wu']
  s.email = ['ywu@zendesk.com']
  s.files = Dir['{app,config,db,lib}/**/*']
  s.add_runtime_dependency "jenkins_api_client", "~> 1.3"
end
