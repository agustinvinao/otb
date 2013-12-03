require 'debugger'
require 'circular_dependency_exception'
require 'same_dependency_exception'
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
    valid_dependencies?
    result = []
    while jobs.size > 0
      unless (dependency = last_job_in_dependency(jobs[0], result, jobs[0])) == jobs[0]
        if dependency && jobs.index(dependency)
          result << jobs.delete_at(jobs.index(dependency))
        end
      else
        result << jobs.shift
      end
    end
    result.join('')
  end
  private
  def last_job_in_dependency(job, queued, jobStart)
    dependency = has_dependency(job)
    if dependency.nil? || queued.include?(dependency)
      job
    else
      raise CircularDependencyException if dependency == jobStart
      queued.include?(dependency) ? dependency : last_job_in_dependency(dependency, queued, jobStart)
    end
  end

  def has_dependency(job)
    if dependencies
      if dependencies.keys.include?(job)
        return dependencies[job]
      else
        return nil
      end
    end
  end
  def valid_dependencies?
    raise SameDependencyException if dependencies && dependencies.select{|k,v| k==v}.size > 0
  end
end
