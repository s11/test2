class Array
  
  def random_selection(num_elements = nil)
    elements = self.clone
    random_selection = []
    num_elements = self.length if num_elements.nil? or (self.length < num_elements)
    
    num_elements.times{|i| random_selection << elements.delete_at(Kernel::rand(elements.length))}
    random_selection
  end
  
end