require 'yaml'

class Gater

  RAILS_ENV = ENV['RAILS_ENV'] || 'development'

  def initialize
    read_conf
  end

  def read_conf()
    # get the features that are active etc.
    # TODO: support DB configs
    # TODO: load the file from #{RAILS_ROOT}/config/gates.yml
    # TODO: support (auto?) reloading
    config = YAML.load_file("gates.yml")

    # Consider it an error if an environment is unknown
    raise "Unknown environment #{ RAILS_ENV } in gates.yml" unless config.has_key? RAILS_ENV

    # Import gates for the current environment, defaulting to those in 'common'
    @known_gates = config['common'].merge( config[RAILS_ENV] || {} )
  end

  def active_gates()
    @known_gates.select { |k,v| v }.map { |x| x[0] }
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
