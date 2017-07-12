class KrispyKreme
  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end

  def to_s
    string = ''
    if @filling_type.nil?
      string << "Plain"
    else
      string << @filling_type
    end

    if !@glazing.nil?
      string << " with #{@glazing}"
    end

    string
  end
end