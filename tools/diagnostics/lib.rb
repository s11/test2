def populate_system(system, csv_filename)
  
  # Import the contents of the system
  FasterCSV.foreach(csv_filename, :headers => :first_row, :skip_blanks => true) do |row|
    
    system.problems.create!({:description => row['Problem']}) unless row['Problem'].nil?
    
    unless row['Faults'].nil? or row['Rating'].nil?
      system.faults.create!({:description => row['Faults'], :rating => row['Rating']})
    end
    
    system.symptoms.create!({:description => row['Symptoms']}) unless row['Symptoms'].nil?
    
    unless row['Verification Tests'].nil?
      data          = {:description => row['Verification Tests']}
      data[:result] = row['Default Verification Tests Result'] unless row['Default Verification Tests Result'].nil?
      system.verifications.create!(data)
    end

    unless row['Identification Tests'].nil?
      data          = {:description => row['Identification Tests']}
      data[:result] = row['Default Identification Tests Result'] unless row['Default Identification Tests Result'].nil?
      system.identifications.create!(data)
    end

    unless row['Rectification Actions'].nil?
      data          = {:description => row['Rectification Actions']}
      data[:result] = row['Default Rectification Actions Result'] unless row['Default Rectification Actions Result'].nil?
      system.rectifications.create!(data)
    end

  end
  
end

def create_scenario(scenario, csv_filename)
  
  system = scenario.system
  
  # Import the contents of the system
  FasterCSV.foreach(csv_filename, :headers => :first_row, :skip_blanks => true) do |row|
    
    unless row['Problem'].nil?
      problem = system.problems.find_by_description(row['Problem'].strip)
      if problem.nil?
        puts("Unable to find a problem '#{row['Problem']}'. Creating ...")
        problem = system.problems.create!({:description => row['Problem'].strip})
      end
      scenario.problem = problem
    end
    
    unless row['Fault'].nil?
      fault = system.faults.find_by_description(row['Fault'].strip)
      if fault.nil?
        puts("Unable to find a fault '#{row['Fault']}'. Creating ...")
        fault = system.faults.create!({ :description  => row['Fault'].strip,
                                        :rating       => row['Frating']})
      end
      scenario.fault = fault
    end
    
    # Create the scenario so the association saving will work
    scenario.save!
    
    unless row['Symptoms'].nil?
      symptom = system.symptoms.find_by_description(row['Symptoms'].strip)
      if symptom.nil?
        puts("Unable to find a symptom '#{row['Symptoms']}'. Creating ...")
        symptom = system.symptoms.create!({:description => row['Symptoms'].strip})
      end
      scenario.scenarios_symptoms.create!({:symptom_id => symptom.id})
    end
    
    unless row['Verification Tests'].nil?
      verification = system.verifications.find_by_description(row['Verification Tests'].strip)
      if verification.nil?
        # Create the verification
        puts "Unable to find verification '#{row['Verification Tests']}'. Creating ..."
        verification = system.verifications.create!({ :description  => row['Verification Tests'].strip,
                                                      :result       => nil})
      end
      data = {
        :result           => row['Verification Result'],
        :rating           => row['Vrating'],
        :pass             => row['Vpass'],
        :verification_id  => verification.id,
      }
      scenario.scenarios_verifications.create!(data)
    end
    
    unless row['Verification Hint'].nil?
      scenario.hints.create!({:classification => 'verification', :message => row['Verification Hint'], :penalty => 1})
    end
    
    unless row['Identification Tests'].nil?
      identification = system.identifications.find_by_description(row['Identification Tests'].strip)
      if identification.nil?
        puts "Unable to find identification test '#{row['Identification Tests']}'. Creating ..."
        identification = system.identifications.create!({ :description  => row['Identification Tests'].strip,
                                                          :result       => nil})
      end
      data = {
        :result             => row['Identification Result'],
        :rating             => row['Irating'],
        :pass               => row['Ipass'],
        :identification_id  => identification.id,
      }
      scenario.scenarios_identifications.create!(data)
    end
    
    unless row['Identification Hint'].nil?
      scenario.hints.create!({:classification => 'identification', :message => row['Identification Hint'], :penalty => 1})
    end
    
    unless row['Rectification Actions'].nil?
      rectification = system.rectifications.find_by_description(row['Rectification Actions'].strip)
      if rectification.nil?
        puts "Unable to find rectification test '#{row['Rectification Actions']}'. Creating ..."
        rectification = system.rectifications.create!({ :description  => row['Rectification Actions'].strip,
                                                        :result       => nil})
      end
      data = {
        :result           => row['Rectification Result'],
        :rating           => row['Rrating'],
        :pass             => row['Rpass'],
        :rectification_id => rectification.id,
      }
      scenario.scenarios_rectifications.create!(data)
    end
    
    unless row['Rectification Hint'].nil?
      scenario.hints.create!({:classification => 'rectification', :message => row['Rectification Hint'], :penalty => 1})
    end
    
  end
  
  
end