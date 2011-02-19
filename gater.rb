class Gater

  def read_conf()
    # get the features that are active etc.
  end

  def active_gates()
    # get from conf
    []
  end

  def junction()
    switcher = Switcher.new()
    yield switcher
    switcher.run_most_specific_match(active_gates)
  end

end

class Switcher

  def branch(criteria = nil, &block)
    @branches ||= {}
    # use nil to indicate the "default" branch?
    if !criteria.nil? and !criteria.kind_of?(Array)
      criteria = [criteria]
      @branches[criteria] = block
    end
  end

  def run_most_specific_match(active_gates)
    possible_branches = []
    @branches.each do |criteria, block|
      if criteria.nil?
        possible_branches << [0, block]
      elsif criteria.all? {|c| active_gates.include?(c)}
        possible_branches << [criteria.length, block]
      end
    end

    # find the max val in possible branches
    # raise if there is any ambiguity (if two matches are the most specific)
    # otherwise execute block
  end

end
