class Queue
  attr_reader :jobs, :dependencies, :result
  def initialize(args={})
    args          = defaults.merge(args)
    @jobs         = args[:jobs]
    @dependencies = args[:dependencies]
    @unvisited    = dependencies.keys
    @marked       = []
  end
  def defaults
    {:jobs => '', :dependencies => {}}
  end

  def run
    @result    = []
    while not unvisited.empty?
      visit(unvisited.first)
    end
    result.join('')
  end

  private
  attr_reader :unvisited, :marked
  def visit(job)
    raise 'job self dependency'      if dependencies[job] == job
    raise 'jobs circular dependency' if marked.include? job

    if unvisited.include? job
      @marked << job
      visit dependencies[job] if not dependencies[job].nil?
      @unvisited.delete job
      @marked.delete job
      @result << job
    end
  end
end