require 'yaml'

class Gater

  RAILS_ENV = ENV['RAILS_ENV'] || 'development'

  @@known_gates = nil
  @@config = nil

  def self.read_conf()
    # get the features that are active etc.
    # TODO: support DB configs
    # TODO: load the file from #{RAILS_ROOT}/config/gates.yml
    # TODO: support (auto?) reloading
    @@config = YAML.load_file("gates.yml")

    # Consider it an error if an environment is unknown
    raise "Unknown environment #{ RAILS_ENV } in gates.yml" unless @@config.has_key? RAILS_ENV

    # Import gates for the current environment, defaulting to those in 'common'
    @@known_gates = @@config['common'].merge( @@config[RAILS_ENV] || {} )
  end

  def self.active_gates()
    if @@known_gates.nil?
      read_conf()
    end
    @@known_gates.select { |k,v| v }.map { |x| x[0] }
  end

  def self.junction()
    switcher = Switcher.new()
    yield switcher
    switcher.run_most_specific_match(active_gates)
  end

  def self.known_gates=(known_gates)
    @@known_gates = known_gates
  end

end

class Switcher

  def initialize()
    @branches = {}
  end

  def branch(criteria = nil, &block)
    if criteria.nil?
        criteria = []
    elsif not criteria.kind_of? Array
        criteria = [ criteria ]
    end

    @branches[criteria] = block
  end

  def run_most_specific_match(active_gates)
    possible_branches = []
    @branches.each do |criteria, block|
      if criteria.nil?
        possible_branches << [0, block]
      elsif criteria.all? {|c| active_gates.include?( c.to_s )}
        possible_branches << [criteria.length, block]
      end
    end

    # if there's a possible branch...
    if possible_branches.length > 0
      # find the max val in possible branches
      max_val = possible_branches.map { |x| x[0] }.max

      # raise if there is any ambiguity (if two matches are the most specific)
      best_branches = possible_branches.select { |x| x[0] == max_val }
      raise "Ambiguous gates in junction: #{ best_branches.inspect }" if best_branches.length != 1

      # otherwise execute block
      best_branches[0][1].call nil # TODO add reporter
    end
  end

end

