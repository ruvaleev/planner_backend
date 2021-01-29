# frozen_string_literal: true

def return_unauthorized
  halt([401, { errors: ['Unauthorized'] }.to_json])
end

def return_success(body = {})
  halt([200, body.to_json])
end

def return_errors(errors)
  halt([403, { errors: errors }.to_json])
end

def return_not_found
  halt([404, { errors: { record: 'Not Found' } }.to_json])
end
