require 'debugger'
class Queue
  attr_reader :jobs, :dependencies
  def initialize(args={})
    args          = defaults.merge(args)
    @jobs         = args[:jobs].chars
    @dependencies  = args[:dependencies]
  end

  def defaults
    {:jobs => ''}
  end

  def run
    result = []
    while jobs.size > 0
      job    = jobs.shift
      parent = has_parent(job)
      result << jobs.delete_at(jobs.index(parent)) if parent
      result << job
    end
    result.join('')
  end

  private
  def has_parent(job)
    return dependencies[job] if dependencies && dependencies.keys.include?(job)
  end

end