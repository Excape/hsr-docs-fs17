# Consesus with the Bitcoin system
- Properties of money: Trust, store of value, acceptance
- requirement: all computers must have the same "table" of who owns what
- Double-spending attack: attacker sends two transactions to two different people to different nodes. if they just replicate, there is no way of knowing what the correct "state" of the network is
- We need a Consesus Protocol

## Consensus Protocol
- Main idea: Agree on the majority
    - But most participants would need to be "friendly"
- approach: use a random hash function, where it is extremely hard to find a collision
- the longest chain is valid
