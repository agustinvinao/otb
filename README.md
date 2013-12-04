Notes
=====

As a first idea to solve the code exercise, I've design a Queue class to do hold all Jobs.

## Classes

### Queue

> Hold all the jobs and handle process order.

Dependencies are represented as a Hash with key => value as the relation.

For example, to represent a may depend on b:

> {a => b}

Jobs are passed to the class as a string, and dependencies as a Hash. Empty dependencies are declared, for example:

> {a => b, b => nil}

b before a, and b has no dependencies.

This new solution was after a friends points me about topological sorting. http://en.wikipedia.org/wiki/Topological_sorting
