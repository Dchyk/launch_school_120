module Moveable
  attr_accessor :speed, :heading
  attr_writer :fuel_capacity, :fuel_efficiency

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle
  include Moveable

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

###

class Boat
  attr_accessor :propeller_count, :hull_count

  include Moveable

  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end
end

class Catamaran < Boat
  
  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    @propeller_count = num_propellers
    @num_hulls = hull_count
    super(km_traveled_per_liter, liters_of_fuel_capacity)

    # ... other code to track catamaran-specific data omitted ...
  end
end

class Motorboat < Boat

  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    @propeller_count = 1
    @num_hulls = 1
    super(km_traveled_per_liter, liters_of_fuel_capacity)
  end

end