# frozen_string_literal: true

def parsed_body
  JSON.parse(last_response.body)
end
