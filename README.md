neo4ruby
========

 It's an application inserting words pulled from websites in a special kind of
graph. Each node represents one unique word, links are created according to the order of incoming words(words nearby are linked together).
Additionally, there is a component building neural network on the basis of the graph, and simulating propagation of signals.
Application consists of:

* server listening on RabbitMQ for payload (JSON consisting of url and word data)

* payload processor with pluggable components(payload processing commands), responsible for various operations on the data, i.e. stemming.

* graph builder, inserting stream of data into a graph.

* database (Neo4j, Redis) communication layer. It manages persistence of data without disclosing underlying structures.

* neural network engine, which loads the graph to memory and can simulate propagation of the signal. 
