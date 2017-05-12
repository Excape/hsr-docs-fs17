# Distributed Hash Tables
## Chord
- Each node is responsible for nodes with values less or equal to itself
- Each node has a link to its successor node (first node clockwise from p)
- Goal: \(O(log(n))\) search

### Finger Table
- Store successor of every next \(2^i\)th node from itself,  e.g. the first, second, fourth, eighth, ...
- every finger table has \(2^m\) rows

### Lookup
- "nearest predecessor": Why not nearest successor?
    - successor would possibly be too far, since only powers of 2 nodes are stored in the finger table
    - it's better to send it to p's vicinity, since it knows more about closer nodes than nodes far away
    - if the looked up key = p in finger table, the target node could be unavailable, so it is safer to send it *near* this node

### Correctness
- If successor pointers are correct, lookup wil always yield the correct result
    - even if not all finger tables are correct, lookup will never fail, it is just more inefficient
    - intiuitive, because the worst case is linear search through each node
- Each node periodically runs a stabilization procedure
- In most practical settings, the stabilization *eventually* leads the newtork to a stable state

### Stabilization
- Update node p's successor: If the predecessor of it's current successor is between p and p.successor, this is the new successor of p
    - Repeat this procedure while condition is true
- Update predecessor: Each node o notifies p of its existence. if o is between p and p.predecessor, o is the actual new predecessor
- update finger table: take a random entry in the finger table, and update its value (= \(succ(n+2^{i-1}\)
    - can't be calculated directly, because `succ()` is a global function
    - done with lookup: `successor.lookup(n + 2^(i-1), p)`

### Fault tolerance
#### Leaving unplanned
- Resources of node are lost
- Ring is broken
- We need redundancy to accept a number of failing nodes
- idea: store more than 1 successor - still a problem of lost resources

### Replication
- Store resources on multiple nodes (uniformly distributed)
- uniform distribution is easy, because hash functions are random

## Examples
- memcached: Cache frequently used database queries
- DynamoDB

## Exercises
### KE6: Consider the Chord system as shown in Fig. 5-4 (ch. 5 in Tannenbaum et al.) and assume that node 7 has just joined the network. What would its finger table be and would there be any changes to other finger tables?
- Its finger table would be `{9, 9, 11, 18, 28}`
- Every finger table entry with the value `9` has to be reconsidered
    - 4 has an outdated finger table. the new should be `{7, 7, 9, 14, 20`}
    - `21.finger[5] = 7`
    - `1.finger[3] = 7`

### KE7: If we insert a node into a Chord system, do we need to instantly update all the finger tables?
- No, we just need to update the successor of the new node's predecessor. If this is correct, every lookup will yield a correct result, worst case is linear search
