module API
  module ErrorFormatter
    def self.call message, _backtrace, _options, _env, _original_exception
      {response_type: "There was an error", response: message}.to_json
    end
  end
end
