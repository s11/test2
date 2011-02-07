module Diagnostics::ScenariosHelper

  def symptom_assigned_to_scenario?(symptom)
    return true if @scenario && @scenario.symptoms.map(&:id).include?(symptom.id)
    false
  end

  def verification_assigned_to_scenario?(verification)
    return true if @scenario && @scenario.verifications.map(&:id).include?(verification.id)
    false
  end

  def identification_assigned_to_scenario?(identification)
    return true if @scenario && @scenario.identifications.map(&:id).include?(identification.id)
    false
  end

  def rectification_assigned_to_scenario?(rectification)
    return true if @scenario && @scenario.rectifications.map(&:id).include?(rectification.id)
    false
  end

end
