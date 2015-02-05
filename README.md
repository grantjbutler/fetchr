# fetchr
`fetchr` is a command line utility that allows for querying a Core Data store using a JavaScript API.

## Status

As of right now, functionality is very limited. The utility can load a managed object model and a persistent store. It displays a prompt and can execute JavaScript. For some reason, we cannot create a `FetchRequest` JavaScript object, as that fails with the error `TypeError: '[object GJBFetchRequestConstructor]' is not a constructor (evaluating 'new FetchRequest()')`. Some digging into WebKit will probably be required to see how to make Objective-C classes work as constructors for JavaScript objects.
