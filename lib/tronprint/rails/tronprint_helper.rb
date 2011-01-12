module TronprintHelper
  def total_footprint
    emission_estimate.to_f
  end
  def footprint_methodology
    emission_estimate.methodology
  end

  def emission_estimate
    @emission_estimate ||= Tronprint.emission_estimate
  end
end
