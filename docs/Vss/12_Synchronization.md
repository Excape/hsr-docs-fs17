# Synchronization

## Motivation
- Synchronization of time is needed to coordinate events at a global level

## Physical Clocks
- Basis is a mechanical or astronomical process
- have their limits with accuracy
- Problematic usage: Leap seconds, time zones, leap years, etc.

### Example: SBB Clock
- Uhr selbst misst keine Zeit
- Jede Minute wird die Zeit synchronisiert

### One-sided Update
- Problem: Network Latency creates an offset on the client
- Estimation of latency is difficult, we don't have enough data

### NTP
- Tries to measure the network latency using the round-trip time
- Server sends back original request (`Cs`)
- Compute RTT with (Cr - Cs) - (Ss - Sr), client knows all of these
- Client can either update its time immediately or adjust the speed to gradually adjust to the correct time
    - NTP adjusts gradually. Immediate update would lead to a "jump", mayble a scheduled task is in the gap and wouldn't be executed. (Time must be continous)

## Logical Clocks
### Database Replication Example
- Problem: Lost updates
- Solution: Nodes must acknowledge updates, only perform update if it is acknowledged by all nodes
- Problem: Order of updates is not guaranteed
- Solution: Chronological Ordering with timestamps
- Problem: Time has to be synchronized between the nodes
- Solution: NTP
- Problem: Physical time has an arbitrary precision, updates could still have the same timestamp

### Motivation
- It's often more important that processes agree on an order of events (causality) rather than an exact point in time (physical clock)
- Physical clocks have a limited, arbitrary resolution (accuracy)

### Causality
- Event a happens before b - \(a \rightarrow b\)
- Can be reflexive (think DAG) - \(a \rightarrow x \rightarrow b\)
- Concurrent Relation: \(a || b \)
    - \(a\) and \(b\) are not causally related
- Not enough for Database replication: We still need an (arbitrary) order for concurrent events, a *strict total ordering* -> Lamport's Logical Clock

### Lamport's Logical Clock
- Each process maintains an internal counter for all events occuring in its process
- The current value of the counter is sent with each message
- The receiver updates its counter to the max of the sender and receiver-counter (respectively) and increments it
