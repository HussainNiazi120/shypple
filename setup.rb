# frozen_string_literal: true

# Load all Ruby files from the 'classes' and 'services' directories
Dir[File.join(__dir__, 'classes', '**', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'services', '**', '*.rb')].each { |file| require file }

require 'net/http'
require 'rspec'

DEFAULT_CURRENCY = 'EUR'

# Enable WebMock and set up a stub for the API request
module WebMockSetup
  require 'webmock'
  require 'erb'
  include WebMock::API

  def self.setup
    WebMock.enable!
    mock_response_template = File.read('mock_response.json.erb')
    mock_response = ERB.new(mock_response_template)
    WebMock.stub_request(:get, ShippingData::GetService::API_URL)
           .to_return(status: 200, body: mock_response.result, headers: { 'Content-Type' => 'application/json' })
  end
end

WebMockSetup.setup
