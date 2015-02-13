# fetchr
`fetchr` is a command line utility that allows for querying a Core Data store using a JavaScript API.

## Status

`fetchr` is in a basic usable state. You can create a fetch request, assign an entity to it, assign a predicate, set sort descriptors, set relationship paths for prefetching, and then execute it to get results. Things that still need to be implemented include setting a fetch limit, setting which properties to fetch, and setting properties to group by.

## API

### Predicate

#### Class Methods

##### `Predicate.format`

Creates a predicate with the specified format. The method mirrors `+[NSPredicate predicateWithFormat:]` See  [Predicate Format String Syntax](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795) for more details.

```js
var sign = isAdult ? '>=' : '<';
Predicate.format('%K %@ 18', 'age', sign);
```

### SortDescriptor

#### Constructor

The constructor mirrors the initializer for `NSSortDescriptor`. It takes two arguments, the name of the key to sort by, and whether the sort should be ascending (`true`) or descending (`false`).

```js
var sortDescriptor = new SortDescriptor('name', true);
```

### FetchRequest

#### Properties

##### `entityName`

The name of the entity as defined in the managed object model.

```js
var request = new FetchRequest();
request.entityName = 'Person';
```

##### `predicate`

A `Predicate` instance for filtering objects from a Core Data store.

```js
var request = new FetchRequest();
request.entityName = 'Person';
request.predicate = Predicate.format('%K >= 18', 'age');
```

##### `sortDescriptors`

An array of `SortDescriptor` instances to sort the fetch request by.

```js
var request = new FetchRequest();
request.entityName = 'Person';
request.sortDescriptors = [new SortDescriptor('name', true)];
```

##### `relationshipKeyPathsForPrefetching`

An array of strings that are key paths of relationships to fetch.

```js
var request = new FetchRequest();
request.entityName = 'Person';
request.predicate = Predicate.format('%K.@count >= 3', 'relatives');
request.relationshipKeyPathsForPrefetching = ['relatives'];
```

### fetchr

#### Methods

##### `executeFetchRequest`

Executes a `FetchRequest` against a Core Data store, and returns the results, if any.

```js
var request = new FetchRequest();
request.entityName = 'Person';
request.predicate = Predicate.format('%K >= 18', 'age');
var results = fetchr.executeFetchRequest(request);
```
