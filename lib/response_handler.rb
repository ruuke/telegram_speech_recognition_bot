# frozen_string_literal: true

module ResponseHandler
  class ClientError < StandardError; end
  class RedirectionError < StandardError; end
  class ServerError < StandardError; end

  def handle_response(response)
    case response.status
    when 100..199
      response
    when 200..299
      response
    when 300..399
      raise RedirectionError, "#{class_name}::Error Unexpected redirection from api response."
    when 400
      raise ClientError, "#{class_name}::Error Bad request: #{response.body}"
    when 401
      raise ClientError, "#{class_name}::Error Unauthorized request: #{response.headers['www-authenticate']}"
    when 402..499
      raise ClientError, "#{class_name}::Error Bad request: #{response.body}"
    when 500..599
      raise ServerError, "#{class_name}::Error #{class_name} server error: #{response.body}"
    end
  end

  private

  def class_name
    self
  end
end
