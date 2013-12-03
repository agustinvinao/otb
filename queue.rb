class Queue
  attr_reader :jobs
  def initialize(args={})
    args       = defaults.merge(args)
    @jobs      = args[:jobs].chars
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