require 'circular_dependency_exception'
require 'same_dependency_exception'
class Queue
  attr_reader :jobs, :dependencies

  def initialize(args={})
    args          = defaults.merge(args)
    @jobs         = args[:jobs].chars
    @dependencies = args[:dependencies]
  end
  def defaults
    {:jobs => ''}
  end

  def run
    return unless has_same_dependencies?

    ordered_jobs = []
    while jobs.size > 0
      job = jobs[0]
      unless (dependency = last_job_in_dependency(job, ordered_jobs, job)) == job
        ordered_jobs << jobs.delete_at(jobs.index(dependency))
      else
        ordered_jobs << jobs.shift
      end
    end
    ordered_jobs.join('')
  end

  private

  def last_job_in_dependency(job, queued, job_start, previous=[])
    previous << job
    dependency = has_dependency?(job)
    if dependency.nil? || queued.include?(dependency)
      job
    else
      queued.include?(dependency) ? dependency : last_job_in_dependency(dependency, queued, job_start, previous) if is_not_circular_dependency?(dependency, job_start, previous)
    end
  end

  def has_dependency?(job)
    dependencies && dependencies.keys.include?(job) ? dependencies[job] : nil
  end
  def has_same_dependencies?
    raise SameDependencyException if dependencies && dependencies.select{|k,v| k==v}.size > 0
    true
  end

  def is_not_circular_dependency?(dependency, start_job, previous)
    raise CircularDependencyException if dependency == start_job || previous.include?(dependency)
    true
  end
end
