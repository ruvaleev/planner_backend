# frozen_string_literal: true

def parsed_body
  JSON.parse(last_response.body)
end

def authorized_headers(headers = {})
  { 'HTTP_AUTHORIZATION' => "Bearer #{ENV['API_KEY']}" }.merge(headers)
end
