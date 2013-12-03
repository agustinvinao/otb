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