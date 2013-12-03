require_relative 'minitest_helper'
require 'queue'
class QueueTest < Minitest::Test

  def test_run_with_empty_string
    queue = Queue.new({:jobs => ''})
    assert_equal '', queue.run
  end

  def test_run_for_single_job
    queue = Queue.new({:jobs => 'a'})
    assert_equal 'a', queue.run
  end

  def test_run_for_tree_jobs_without_parents
    queue = Queue.new({:jobs => 'abc'})
    assert_equal 'abc', queue.run
  end

end
