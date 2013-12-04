require 'circular_dependency_exception'
require 'same_dependency_exception'
class Queue
  attr_reader :jobs, :dependencies

  def initialize(args={})
    args          = defaults.merge(args)
    @jobs         = args[:jobs].chars
    @dependencies = args[:dependencies]
  end

  # Im using a defaults method to set an empty string if the user dont sent jobs.
  # This is necessary because im going to do args[:jobs].chars to initialize jobs.
  def defaults
    {:jobs => ''}
  end

  def run
    return unless has_same_dependencies? # we only continue if we have valid dependencies.

    ordered_jobs = []
    while jobs.size > 0
      job = jobs[0] # we check first job in our queue, we only remove the job from the queue
                    # depending of the dependencies.
      unless (dependency = last_job_in_dependency(job, ordered_jobs, job)) == job
        # we have a dependency and we need to extract it from our jobs array.
        ordered_jobs << jobs.delete_at(jobs.index(dependency))
      else
        # we move our job to the final ordered jobs.
        ordered_jobs << jobs.shift
      end
    end
    # becasue we hare using a string and chars to represent our jobs I show it as a string
    # to check results.
    ordered_jobs.join('')
  end

  private

  def last_job_in_dependency(job, queued, job_start, previous=[])
    previous << job
    dependency = has_dependency?(job)
    if dependency.nil? || queued.include?(dependency)
      # if we dont have a dependency or our dependency was added before, we return the job evaluated
      job
    else
      # we continue with the recursive call to the the rest of the dependencies if is not processed
      # before and if is not a ciruclar dependency
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

  # we check circular dependencies in two ways:
  # 1. started job with the current dependency
  # 2. any previous job with current dependency
  def is_not_circular_dependency?(dependency, start_job, previous)
    raise CircularDependencyException if dependency == start_job || previous.include?(dependency)
    true
  end
end
