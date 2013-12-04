Notes
=====

As a first idea to solve the code exercise, I've design a Queue class to do hold all Jobs.

## Classes

### Queue

> Hold all the jobs and handle process order.

Dependencies are represented as a Hash with key => value as the relation.

For example, to represent a may depend on b:

> {a => b}

Jobs are sended to Queue class as a string, inside queue this string is going to be passed
to a chars array by .chars method.


### About some decisions:

#### Class: Queue

#### Method: defaults

Using a method to handle defaults values ensure your initialization process for an object.

#### Method: run

```ruby
return unless has_same_dependencies?
```

First line of this method checks if we have a SameDependencyException in our dependencies; this
dependency it's easy to check and is one of the rules to raise an exception if we have one. Is
not necessary continue with the process if we have this case.
The rule for circular dependencies is not so easy to check, we need to follow dependencies in
dependencies hash and if we check it when this method start and then we do all the process we
will move over all dependencies more times than the minimal and necessary.

> while jobs.size > 0

Our process it should be running while we have chars to process. We have two possibilities to
extract a job from our jobs array:

1. the job doesn't have any dependencies.
2. the job has dependencies and we need to find the last dependency after all the tree.

This process is handle from line 25 to 31.

#### Method: last_job_in_dependency

This method gets the last step in dependencies for a job. For example, if we have a => b, b => c
this process returns c.

#### Method: has_dependency?

Our dependencies are handle in an Hash, this is the place where I check if a job has a dependency.
In this simple example is very easy to check when a job has a dependency, but in a more complex
example we need an isolated place to check things like that and if we have this kind of check in
a different method I think it helps to understand how the object works.
