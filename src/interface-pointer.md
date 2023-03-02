# Pointers to Interfaces

You almost never need a pointer to an interface. You should be passing
interfaces as values—the underlying data can still be a pointer.

An interface is two fields:

1. A pointer to some type-specific information. You can think of this as
  "type."
2. Data pointer. If the data stored is a pointer, it’s stored directly. If
  the data stored is a value, then a pointer to the value is stored.

If you want interface methods to modify the underlying data, you must use a
pointer.
