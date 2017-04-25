# Naming

- Name things to find Resources that interest me
- Assign names to entities to identify them, e.g. assign phone numbers to customers
- Name Resolution is the problem of accessing a resource using a name

## Naming in a Distributed System
- e.g. processes on a single computer
- a centralized name resolution for the telephone system would be a single phonebook in existence
    - not robust (what if you lose it?)
    - not scalable
    - high "network latency"
- Possible Solution: Hand everyone a copy -> Distributed Name Resolution System

## Terminology
- Normally, each entity (e.g. a person) has an access point (e.g. a phone) through which the entity can be accessed
- *Name*: String to identify an entity
- *Entity*: Physical or logical object
- *Access Point*: Entity that is used to access another entity
    - Often given through physical connection, e.g. a customers owns his phone
- *Address*: Name of an Access Point
    - often defined at another level, e.g. a MAC-Adress to a NIC
- Advantages
    - Very flexible: Adress and access points can change, but it is still accessible through it's name
    - Entity can listen to multiple access points
- *Location Independent Name*: Name is independent of address

## Naming Overview
### Flat Naming
- Names are unstructured identifiers
- Names may have internal structure, but it's not used in name resolution (e.g. IP-Adress)
- Used with broadcasting
    - Every entity knows it's (flat) name and address
    - Resolution is done with broadcasting: "Where is X?" - X answers with his address
- Used in ARP
- Pros
    - Simplicity
    - Location independent
- Cons
    - Not scalable, e.g. wouldn't work for a phone system
    - Easy to impersonate someone else
### Structured Naming
- Names are hierarchical structured
- Name represents a path in a tree, e.g. `unterricht.hsr.ch`
- Resolution is split into sepparate layers with different responsibilities
- e.g. DNS
- Highly scalable

## Attribute-based Naming
