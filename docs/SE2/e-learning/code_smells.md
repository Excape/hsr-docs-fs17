# Code Smells
## Oddball Solutions
- Two or more working solution for the same problem
- "inconsistent solution"
- Use the best solution everywhere, even if it's the "minority" solution

## Primitive Obsession
- Primitive Obsession exists when code solves a problem
in a primitive way using low-level instructions
- Primitive Principles like `substring() == -1`
- Example: Don't use a StringBuilder to build XML, but a dedicated XML-Builder (higher abstraction!)

## Switch statements
- Often it's useful to turn switch-statements (or long `if... else if...`) into polymorphic solutions (class-hierarchy)
- Not useful when the switch "branches" contain very little code
- Consider a map instead of a switch statement

## Speculative Generality
- Writing code that isn't actually needed today
- "I think we will need the ability to do that someday"

## Combinatorial Explosion
- When new combinations of data or behavior further bloat an already bloated design, you've got a Combinatorial Explosion smell.

## Inappropriate Intimacy
- "Sometimes classes become far too intimate and spend too much time delving in each others' private parts." - Fowler and Beck
- When internals of a class are exposed, high coupling with clients can be a result
- Use "Tell, don't ask"
- Similar to "Indecent Exposure", where classes are public that ought not to be

## Refused Bequest
- Occurs when a subclass doesn't support the interface of it's superclass
- e.g. overriding a method from the superclass interface and provide a "do-nothing" implementation, "refusing" what it has inherited
- "Bequest" = "Erbschaftsgut"

## Black Sheep
- A subclass or a method doesn't fit in well with its family
- Consider moving it to a more appropriate place

## Data Class
- Data Classes that have no own functionality may or may not be code smells

## Solution Sprawl
- Code or data used to perform the responsibility are sprawled across numerous classes
- Solution could be to create a factory that handles a certain complex responsibility, instead of the client directly communication with multiple, "sprawled-out" classes

## Feature Envy
- “A classic smell is a method that seems more interested
in a class other than the one it actually is in.”
- e.g. a method that relies too much on other objects
- Delegate these responsibilities to the other class - "tell, don't ask"

## Temporary Field
- An object's field should have meaning during the full lifetime of the object
- e.g. a method sets a field (as a side effect), that is later used in another method

## Side effect
- "A method with a side effect is like an airplane's exhaust: a possibly harmful pollutant."
- Give methods single responsibilities and avoid side effects that are not obvious to the client
