class SecretFile
  def initialize(secret_data, security_logger)
    @data = secret_data
    @log_entry = security_logger
  end

  def data
    @log_entry.create_log_entry
    @data
  end
end

class SecurityLogger
  def create_log_entry
    # ... implementation omitted ...
  end
end