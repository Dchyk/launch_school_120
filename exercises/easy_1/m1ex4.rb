class CircularQueue
  attr_accessor :queue

  def initialize(max_size)
    @max_size = max_size
    @queue = []
  end

  def enqueue(value)
    @current_item = Item.new(value)

    if @queue.size < @max_size
      @queue.each { |item| item.increment }
      @queue << @current_item
    elsif @queue.size >= @max_size
      dequeue
      @queue.each { |item| item.increment }
      @queue << @current_item
    end
  end

  def dequeue
    return nil if queue.empty?

    @queue.delete(@queue.max_by { |item| item.number }).value
  end
end

class Item
  attr_accessor :number
  attr_reader :value

  def initialize(value)
    @value = value
    @number = 1
  end

  def increment
    self.number += 1
  end
end

# add item to the queue with number 1
# add next item to the queue with number 1, all other items += 1
# delete item with the highest number, as it's been there the longest
# if items == max queue size, delete item with highest number, new == 1,
# other += 1
# return nil if no items in queue