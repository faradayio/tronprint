# Rails helper for displaying footprint data.
module TronprintHelper

  # The total amount of CO2e generated by the application.
  def total_footprint
    emission_estimate.to_f
  end
  # A URL for the methodology statement of the emissions calculation.
  def footprint_methodology
    emission_estimate.methodology
  end

  # The Carbon::EmissionEstimate object representing the 
  # estimate processed by CM1.
  def emission_estimate
    @emission_estimate ||= Tronprint.emission_estimate
  end
end
