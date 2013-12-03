require_relative 'minitest_helper'
require 'queue'
class QueueTest < Minitest::Test

  def test_run_with_empty_string
    jobs          = ''
    queue         = Queue.new({:jobs => jobs})
    assert_equal '', queue.run
  end

  # jobs
  # a =>
  def test_run_for_single_job
    jobs          = 'a'
    queue         = Queue.new({:jobs => jobs})
    assert_equal 'a', queue.run
  end

  # jobs
  # a =>
  # b =>
  # c =>
  def test_run_for_tree_jobs_without_parents
    jobs          = 'abc'
    queue         = Queue.new({:jobs => jobs})
    assert_equal 'abc', queue.run
  end

  # jobs
  # a =>
  # b => c
  # c =>
  def test_run_with_one_dependency
    dependencies  = {'b' => 'c'}
    jobs          = 'abc'
    queue         = Queue.new({:jobs => jobs, :dependencies => dependencies})
    assert_equal 'acb', queue.run
  end

  # jobs
  # a =>
  # b => c
  # c => f
  # d => a
  # e => b
  # f =>
  def test_run_with_many_dependencies
    dependencies  = {'b' => 'c', 'c' => 'f', 'd' => 'a', 'e' => 'b'}
    jobs          = 'abcdef'
    queue         = Queue.new({:jobs => jobs, :dependencies => dependencies})
    assert_equal 'afcbde', queue.run
  end

  # jobs
  # a =>
  # b =>
  # c => c
  def test_same_dependency
    dependencies  = {'c' => 'c'}
    jobs          = 'abc'
    assert_raises(SameDependencyException) do
      Queue.new({:jobs => jobs, :dependencies => dependencies}).run
    end
  end

  # jobs
  # a =>
  # b => c
  # c => f
  # d => a
  # e =>
  # f => b
  def test_circular_dependency
    dependencies  = {'b' => 'c', 'c' => 'f', 'd' => 'a', 'f' => 'b'}
    jobs          = 'abcdef'
    assert_raises(CircularDependencyException) do
      Queue.new({:jobs => jobs, :dependencies => dependencies}).run
    end
  end


end
