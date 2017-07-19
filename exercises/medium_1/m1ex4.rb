class CircularQueue
  def initialize(slots)

    @array = Array.new(slots, Array.new(2))
    @array.each { |sub_array| sub_array[1] = Time.now }
  end

  def[](index)
    @array[index]
  end

  def enqueue(object)
    @array.sort_by! { |sub_array| sub_array[1] }
    @array[0] = ([object, Time.now])
  end

  def dequeue
    return nil if @array.all? { |subs| subs.nil? }
    @array.sort_by! { |sub_array| sub_array[1] }
    @array[0].delete_at(0)
  end
end