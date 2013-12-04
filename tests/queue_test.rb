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
    dependencies  = {'a' => nil}
    queue         = Queue.new({:jobs => jobs, :dependencies => dependencies})
    assert_equal 'a', queue.run
  end

  # jobs
  # a =>
  # b =>
  # c =>
  def test_run_for_tree_jobs_without_parents
    jobs          = 'abc'
    dependencies  = {'a' => nil, 'b' => nil, 'c' => nil}
    queue         = Queue.new({:jobs => jobs, :dependencies => dependencies})
    assert_equal 'abc', queue.run
  end

  # jobs
  # a =>
  # b => c
  # c =>
  def test_run_with_one_dependency
    dependencies  = {'a' => nil, 'b' => 'c', 'c' => nil}
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
    dependencies  = {'a' => nil, 'b' => 'c', 'c' => 'f', 'd' => 'a', 'e' => 'b', 'f' => nil}
    jobs          = 'abcdef'
    queue         = Queue.new({:jobs => jobs, :dependencies => dependencies})
    assert_equal 'afcbde', queue.run
  end

  # jobs
  # a =>
  # b =>
  # c => c
  def test_same_dependency
    dependencies  = {'a' => nil, 'b' => nil, 'c' => 'c'}
    jobs          = 'abc'
    assert_raises(RuntimeError) do
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
    dependencies  = {'a' => nil, 'b' => 'c', 'c' => 'f', 'd' => 'a', 'e' => nil, 'f' => 'b'}
    jobs          = 'abcdef'
    assert_raises(RuntimeError) do
      Queue.new({:jobs => jobs, :dependencies => dependencies}).run
    end
  end

  # jobs
  # a =>
  # b => c
  # c => f
  # d => a
  # e =>
  # f => c
  # new case where the circular dependency is not at the beginning of the cycle
  # c => f - f => c
  def test_circular_dependency_two
    dependencies  = {'a' => nil, 'b' => 'c', 'c' => 'f', 'd' => 'a', 'e' => nil, 'f' => 'c'}
    jobs          = 'abcdef'
    assert_raises(RuntimeError) do
      Queue.new({:jobs => jobs, :dependencies => dependencies}).run
    end
  end
end
