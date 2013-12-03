class Queue
  attr_reader :jobs, :structure
  def initialize(args={})
    args       = defaults.merge(args)
    @jobs      = args[:jobs].chars
    @structure = args[:structure]
  end

  def defaults
    {:jobs => ''}
  end

  def run
    result = []
    jobs.each do |job|
      result << job
    end
    result.join('')
  end



end