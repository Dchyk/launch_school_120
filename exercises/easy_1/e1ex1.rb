class Banner
  def initialize(message)
    @message = message
    @width = @message.size
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+-" + "-"*@width + "-+"
  end

  def empty_line
    "| " + " "*@width + " |"
  end

  def message_line
    "| #{@message} |"
  end
end