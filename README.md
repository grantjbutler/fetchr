# fetchr
`fetchr` is a command line utility that allows for querying a Core Data store using a JavaScript API.

## Status

`fetchr` is in a basic usable state. You can create a fetch request, assign an entity to it, assign a predicate, and then execute it to get results. Things that still need to be implemented include setting a fetch limit, setting sort descriptors, setting relationship paths for prefetching, setting which properties to fetch, and setting properties to group by.

## API

### Predicate

#### Class Methods

##### `Predicate.format`

Creates a predicate with the specified format. The method mirrors `+[NSPredicate predicateWithFormat:]` See  [Predicate Format String Syntax](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795) for more details.

```js
var sign = isAdult ? '>=' : '<';
Predicate.format('age %@ 18', sign);
```

### FetchRequest

#### Properties

##### `entityName`

The name of the entity as defined in the managed object model.

```js
var request = new FetchRequest();
request.entityName = 'Person';
```

#### `predicate`

A `Predicate` instance for filtering objects from a Core Data store.

```js
var request = new FetchRequest();
request.entityName = 'Person';
request.predicate = Predicate.format('age >= 18');
```

### fetchr

#### Methods

##### `executeFetchRequest`

Executes a `FetchRequest` against a Core Data store, and returns the results, if any.

```js
var request = new FetchRequest();
request.entityName = 'Person';
request.predicate = Predicate.format('age >= 18');
var results = fetchr.executeFetchRequest(request);
```
