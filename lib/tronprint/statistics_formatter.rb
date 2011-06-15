module Tronprint
  module StatisticsFormatter
    def pounds_with_precision(number, precision = nil)
      if precision.nil?
        precision = number < 100 ? 4 : 0
      end

      number_with_precision(number * 2.2046, :precision => precision)
    end
  end
end
