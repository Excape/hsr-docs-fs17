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

#### Iterative Resolution
- Like DNS, every step the client has to ask first the root, then its child, and so on...
- Uses more resources on the server, but better caching is possible

#### Recursive Resolution
- The client just sends its request to the root, which then recursively resolves the complete name before returning the result


### Attribute-based Naming
- The user searches for entities based on a description
- Search is performed with attribute-value-pairs
- used in Directory Services
    - Each entry is a collection of attributes
- in LDAP, each Entry has a Distinguished Name `DN`
    - entries build ab hierarichal trees

## Case Study: Bonjour / Zeroconf
- Allows to add and use devices in a network without manual configuration
- combines various protocols like DHCP, mDNS, SDP (Service Discovery Protocol)
- Only works in a local network, users must trust the entire network!

## Übung 10
> KE1: Give an example of where an address of an entity E needs to be further resolved into another address to actually access E.

DNS-ARP: A name is resolved to an IP, which needs to be resolved into a MAC-Adress

> KE2: Would you consider a URL such as http://www.acme.org/index.html to be location independent? What about http://www.acme.nl/index.html?

No, they are both not location-independent, because the name contains a structure to determine its location. If it ends in `org` or `nl` is irrelevant here.

> KE3: Give some examples of true identifiers.

- MAC-Adresses (at least in theory)
-

> KE4: Is an identifier allowed to contain information on the entity it refers to?

yes, as long as it is unique

> KE5: Outline an efficient implementation of globally unique identifiers.



> KE6: Consider the Chord system as shown in Fig. 5-4 (ch. 5 in Tannenbaum et al.) and assume that node 7 has just joined the network. What would its finger table be and would there be any changes to other finger tables?

- Its finger table would contain `{1, 1, 5}` (same as `p6` before)
- The finger table of `p7`s predecessor (`p6`) has to be changed to `{7, 1, 5}`

> KE8: High-level name servers in DNS, that is, name servers implementing nodes in the DNS name space that are close to the root, generally do not support recursive name resolution. Can we expect much performance improvement if they did?


No, this would mean a huge increase in server resource requirement

> KE9: Explain how DNS can be used to implement a home-based approach to locating mobile hosts.



