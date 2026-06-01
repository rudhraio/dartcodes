# Dart Concepts Used In The Learning Secrets Vault

This guide explains the Dart concepts used in `basic.dart`.

Read this in order. Do not try to memorize everything in one pass. The goal is to understand how the syntax works and why each part exists.

## 1. How To Read Dart Syntax

Dart often follows this pattern:

```dart
Type name = value;
```

Example:

```dart
String title = 'Gmail';
int count = 3;
bool isSaved = true;
```

Meaning:

```text
String
  the type of data

title
  the variable name

=
  assignment operator

'Gmail'
  the value

;
  statement ends here
```

You can also let Dart guess the type:

```dart
var title = 'Gmail';
final count = 3;
const version = 1;
```

Dart still knows the types. You just did not write them manually.

## 2. Comments

Comments are ignored by Dart. They explain code for humans.

```dart
// One-line comment
```

```dart
/*
Multi-line comment
*/
```

In `basic.dart`, comments divide the file into learning sections.

## 3. Imports

At the top:

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
```

Imports bring existing Dart libraries into your file.

```text
dart:async
  Future, Stream, async tools

dart:convert
  JSON and UTF-8/Base64 conversion

dart:io
  terminal input/output, files, exit codes

dart:math
  Random numbers
```

## 4. The `main` Function

Dart programs start at `main`.

```dart
Future<void> main(List<String> arguments) async {
  // code
}
```

Breakdown:

```text
Future<void>
  The function finishes in the future and returns no useful value.

main
  Special entry point function name.

List<String> arguments
  Command line arguments, such as --demo or --help.

async
  This function is allowed to use await.

{ ... }
  Function body.
```

Why is `main` a `Future<void>`?

Because it uses `await`, and any function that uses `await` must be marked `async`. An `async` function returns a `Future`.

## 5. What Is `Future<T>`?

A `Future` means: "I will have a value later."

Example:

```dart
Future<String> loadName() async {
  return 'Dart';
}
```

Meaning:

```text
Future<String>
  Later, this function will produce a String.
```

The `<String>` part tells Dart what kind of value the Future will eventually contain.

In the app:

```dart
Future<List<Secret>> load() async
```

Means:

```text
This function is asynchronous.
Later, it will return a List of Secret objects.
```

```dart
Future<void> save(List<Secret> items) async
```

Means:

```text
This function is asynchronous.
It finishes later but returns no useful value.
```

## 6. What Is `<T>`?

`T` is a generic type placeholder.

Think of it as:

```text
T = "some type decided later"
```

Example:

```dart
List<String>
```

Means:

```text
A list where every item should be a String.
```

Example:

```dart
List<int>
```

Means:

```text
A list where every item should be an int.
```

In the app:

```dart
abstract class Repository<T extends JsonSerializable> {
  Future<List<T>> load();
  Future<void> save(List<T> items);
}
```

Breakdown:

```text
Repository<T>
  A repository for some type T.

T extends JsonSerializable
  T must be a type that knows how to convert itself to JSON.

Future<List<T>> load()
  Later returns a list of T objects.

save(List<T> items)
  Saves a list of T objects.
```

Then:

```dart
class SecretFileRepository implements Repository<Secret>
```

Means:

```text
This repository stores Secret objects.
So T becomes Secret.
```

## 7. Variables: `var`, `final`, `const`

### `var`

```dart
var appName = 'Learning Secrets Vault';
```

Dart infers the type as `String`.

You can change the value later, but not to another type:

```dart
appName = 'New Name'; // OK
// appName = 123;     // Not OK
```

### `final`

```dart
final startedAt = DateTime.now();
```

Assigned once. Value is known at runtime.

Use `final` when the variable should not be reassigned.

### `const`

```dart
const version = 1;
```

Compile-time constant. The value must be known before the program runs.

Use `const` for fixed values.

## 8. Basic Data Types

```dart
int count = 3;
double score = 98.5;
num flexibleNumber = count;
bool isEmpty = false;
String language = 'Dart';
```

```text
int
  whole number

double
  decimal number

num
  parent type of int and double

bool
  true or false

String
  text
```

## 9. `dynamic` vs `Object`

```dart
dynamic dynamicValue = 'Can change type';
dynamicValue = 42;
```

`dynamic` tells Dart:

```text
Do not check this strictly at compile time.
Trust me.
```

Use it rarely.

```dart
Object objectValue = 'Can hold any non-null object';
```

`Object` can hold many kinds of values, but Dart still makes you type-check before using specific methods.

Safer than `dynamic`.

## 10. Null Safety: `?`, `??`, `??=`, `!`

Dart protects you from accidentally using `null`.

```dart
String name = 'Dart';
```

This cannot be null.

```dart
String? nullableName;
```

The `?` means:

```text
This can be a String or null.
```

### `??`

```dart
nullableName ?? 'Guest'
```

Means:

```text
If nullableName is not null, use it.
Otherwise use 'Guest'.
```

### `??=`

```dart
nullableName ??= 'Assigned because it was null';
```

Means:

```text
Assign this value only if nullableName is currently null.
```

### `?.`

```dart
title?.trim()
```

Means:

```text
If title is not null, call trim().
If title is null, return null.
```

### `!`

Not used much in this app, but important.

```dart
nullableName!
```

Means:

```text
I promise this is not null.
```

Be careful. If it is actually null, your app crashes.

## 11. `late`

```dart
late String initializedLater;
initializedLater = 'Now initialized';
```

`late` means:

```text
I will assign this before using it.
```

Use it when a value cannot be assigned immediately but should not be nullable.

## 12. Strings

```dart
String value = 'Dart vault app';
```

Common operations:

```dart
value.length;
value.toUpperCase();
value.toLowerCase();
value.trim();
value.contains('vault');
value.startsWith('Dart');
value.endsWith('app');
value.indexOf('vault');
value.substring(0, 4);
value.replaceAll('vault', 'safe');
value.split(' ');
```

### String interpolation

```dart
print('Length is ${value.length}');
print('Value is $value');
```

Use `$name` for simple variables.

Use `${expression}` for calculations or property access.

### Raw strings

```dart
r'first\nsecond'
```

The `r` means backslashes are treated as normal characters.

### Multiline strings

```dart
'''Line one
Line two'''
```

Triple quotes allow text across multiple lines.

## 13. Lists

A list is an ordered collection.

```dart
final secrets = <String>['gmail', 'github', 'bank'];
```

Breakdown:

```text
final
  the variable cannot point to a different list

<String>
  this list contains strings

[ ... ]
  list literal
```

Common operations:

```dart
secrets.add('server');
secrets.addAll(['wifi', 'database']);
secrets.insert(1, 'email');
secrets.remove('bank');
secrets.removeLast();
secrets.length;
secrets.isEmpty;
secrets.first;
secrets.last;
secrets.contains('github');
secrets.indexOf('server');
secrets.sublist(1, 3);
```

Important: `final` does not make the list immutable. It only prevents reassigning the variable.

This is allowed:

```dart
final items = <String>[];
items.add('hello');
```

This is not allowed:

```dart
// items = ['new list'];
```

## 14. Sets

A set is an unordered collection of unique values.

```dart
final tags = ['personal', 'work', 'work', 'urgent'].toSet();
```

Result:

```text
{personal, work, urgent}
```

The duplicate `work` is removed.

Common operations:

```dart
tags.add('finance');
tags.remove('urgent');
tags.union({'archive', 'work'});
tags.intersection({'work', 'x'});
tags.difference({'personal'});
```

Use sets for tags, unique ids, permissions, and anything where duplicates do not make sense.

## 15. Maps

A map stores key-value pairs.

```dart
final counts = <String, int>{'password': 2, 'apiKey': 1};
```

Breakdown:

```text
String
  key type

int
  value type

{'password': 2}
  key password has value 2
```

Common operations:

```dart
counts['note'] = 3;
counts.update('password', (value) => value + 1);
counts.remove('apiKey');
counts.keys;
counts.values;
counts.containsKey('note');
counts.entries;
```

In the app, maps are also used for JSON:

```dart
Map<String, Object?> toJson()
```

Means:

```text
Return a map whose keys are strings and values can be many JSON-like types or null.
```

## 16. Collection Transformations

### `map`

```dart
secrets.map((name) => name.toUpperCase()).toList()
```

Transforms every item.

```text
gmail -> GMAIL
github -> GITHUB
```

### `where`

```dart
secrets.where((name) => name.length > 5).toList()
```

Filters items.

### `any`

```dart
secrets.any((name) => name.startsWith('g'))
```

Returns true if at least one item matches.

### `every`

```dart
secrets.every((name) => name.isNotEmpty)
```

Returns true if all items match.

### `fold`

```dart
secrets.fold<int>(0, (total, item) => total + item.length)
```

Combines items into one value.

Here it starts with `0` and adds the length of each string.

## 17. Spread, Collection `if`, Collection `for`

```dart
[
  'root',
  ...secrets,
  if (secrets.length > 2) 'many-items',
  for (final item in secrets) 'copy-$item',
]
```

Breakdown:

```text
...secrets
  put all items from secrets into this new list

if (...)
  conditionally add an item

for (...)
  add generated items
```

## 18. Enums

An enum is a fixed list of allowed values.

Simple enum:

```dart
enum VaultCommand {
  add,
  list,
  exit,
  unknown,
}
```

Use:

```dart
VaultCommand.add
```

Enhanced enum from the app:

```dart
enum SecretCategory {
  password('Password'),
  apiKey('API Key'),
  note('Secure Note'),
  card('Card'),
  other('Other');

  const SecretCategory(this.label);

  final String label;
}
```

Breakdown:

```text
enum SecretCategory
  defines a fixed type named SecretCategory

password('Password')
  enum value with extra data

;
  separates enum values from fields/methods

const SecretCategory(this.label)
  constructor for each enum value

final String label
  each category stores a display label
```

Why semicolon after enum values?

Because this enum has extra fields and a constructor. Dart needs to know where the value list ends.

## 19. Functions

Basic function:

```dart
void printBanner() {
  print('Hello');
}
```

Breakdown:

```text
void
  returns nothing

printBanner
  function name

()
  parameter list

{ ... }
  function body
```

Function with return value:

```dart
int addNumbers(int a, int b) {
  return a + b;
}
```

Arrow function:

```dart
int addNumbers(int a, int b, [int c = 0]) => a + b + c;
```

The `=>` means:

```text
return this expression
```

## 20. Function Parameters

### Required positional parameters

```dart
int add(int a, int b)
```

Call:

```dart
add(1, 2);
```

### Optional positional parameters

```dart
int addNumbers(int a, int b, [int c = 0])
```

Call:

```dart
addNumbers(1, 2);
addNumbers(1, 2, 3);
```

Square brackets mean optional positional parameters.

### Named parameters

```dart
String greetUser({
  required String name,
  String? role,
  bool excited = false,
})
```

Call:

```dart
greetUser(name: 'Beginner', role: 'Dart learner', excited: true);
```

Curly braces in parameters mean named parameters.

`required` means the caller must provide it.

## 21. Anonymous Functions And Closures

Anonymous function:

```dart
(name) => name.toUpperCase()
```

It has no name.

Closure:

```dart
String Function(String) makePrefixer(String prefix) {
  return (message) => '$prefix$message';
}
```

This returns a function.

The returned function remembers `prefix`.

`String Function(String)` means:

```text
A function that accepts a String and returns a String.
```

## 22. Typedef

```dart
typedef SecretPredicate = bool Function(Secret secret);
```

Means:

```text
SecretPredicate is a shorter name for:
a function that accepts a Secret and returns a bool.
```

Used here:

```dart
Iterable<Secret> filter(SecretPredicate predicate)
```

So you can pass logic into the function:

```dart
service.filter((secret) => secret.hasTags)
```

## 23. Classes And Objects

Class:

```dart
class Secret {
  String title;
}
```

Object:

```dart
final secret = Secret(...);
```

Think:

```text
class = blueprint
object = actual thing built from blueprint
```

In the app:

```dart
class Secret
```

defines what one secret looks like.

```dart
class VaultService
```

defines behavior for managing secrets.

## 24. Constructors

Constructor creates an object.

```dart
Secret({
  required this.id,
  required this.title,
})
```

Breakdown:

```text
Secret
  constructor name matches class name

{ ... }
  named parameters

required
  caller must pass this

this.id
  assign parameter directly to object field id
```

Call:

```dart
Secret(id: '1', title: 'Gmail', ...)
```

## 25. Initializer List

In the app:

```dart
}) : tags = tags ?? <String>{} {
```

The part after `:` runs before the constructor body.

Meaning:

```text
If tags is not null, use tags.
Otherwise use an empty Set<String>.
```

Named constructor:

```dart
Secret.sample()
```

A special constructor for creating a sample secret.

Factory constructor:

```dart
factory Secret.fromJson(Map<String, Object?> json)
```

Factory constructors can return a new object created from custom logic.

Here it converts JSON map data into a `Secret`.

## 26. Fields, Getters, Setters

Field:

```dart
String title;
```

Stores data.

Getter:

```dart
bool get hasTags => tags.isNotEmpty;
```

Looks like a property:

```dart
secret.hasTags
```

Setter:

```dart
set safeTitle(String value) {
  if (value.isBlank) {
    throw VaultException('Secret title cannot be empty.');
  }
  title = value.trim();
}
```

Used like assignment:

```dart
secret.safeTitle = 'New title';
```

## 27. Private Members With `_`

```dart
List<Secret> _secrets = <Secret>[];
void _sortSecrets() { ... }
```

In Dart, a leading underscore means private to the library/file.

Since this app is one file, `_secrets` is private inside this file.

## 28. Abstract Classes

```dart
abstract class JsonSerializable {
  Map<String, Object?> toJson();
}
```

An abstract class cannot be directly created.

It defines a contract:

```text
Any class implementing JsonSerializable must have toJson().
```

## 29. Implements

```dart
class Secret implements JsonSerializable, Identifiable
```

Means:

```text
Secret promises to provide everything required by JsonSerializable and Identifiable.
```

So `Secret` must have:

```text
toJson()
id
```

## 30. Mixins And `with`

```dart
mixin Timestamped {
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  void touch() {
    updatedAt = DateTime.now();
  }
}
```

Use it:

```dart
class Secret with Timestamped
```

Meaning:

```text
Add Timestamped fields and methods into Secret.
```

Use mixins for reusable behavior.

## 31. Inheritance And `extends`

```dart
class ApiCredential extends Secret
```

Means:

```text
ApiCredential is a specialized Secret.
```

It gets fields and methods from `Secret`.

`super` refers to the parent class.

```dart
required super.id
```

Means:

```text
Pass this id parameter to the parent Secret constructor.
```

```dart
super(category: SecretCategory.apiKey)
```

Means:

```text
Call the parent constructor and force category to apiKey.
```

## 32. Override

```dart
@override
String toString() => '$title [$category]';
```

`@override` says:

```text
This method replaces a method from a parent class or interface.
```

Common methods to override:

```text
toString()
toJson()
```

## 33. Polymorphism

In the app:

```dart
final objects = <Object>[
  Secret.sample(),
  ApiCredential(...),
];
```

Both are stored as `Object`.

At runtime, Dart still knows their real types:

```text
Secret
ApiCredential
```

Polymorphism means code can work with objects through a common type while each object keeps its own behavior.

## 34. Extensions

```dart
extension StringLearningOps on String {
  bool get isBlank => trim().isEmpty;
}
```

This adds `isBlank` to every `String`.

Use:

```dart
title.isBlank
```

The original `String` class was not modified. Dart just lets your code use extra methods in this file.

Generic extension:

```dart
extension IterableLearningOps<T> on Iterable<T>
```

Means:

```text
Add behavior to Iterable of any type T.
```

## 35. JSON

JSON is text used to store or send structured data.

Example JSON:

```json
{
  "title": "Gmail",
  "category": "password"
}
```

Dart map:

```dart
{
  'title': title,
  'category': category.name,
}
```

Convert object to JSON-friendly map:

```dart
Map<String, Object?> toJson()
```

Convert JSON text to Dart value:

```dart
final decoded = jsonDecode(content);
```

Convert Dart value to JSON text:

```dart
final encoder = JsonEncoder.withIndent('  ');
final text = encoder.convert(data);
```

`withIndent('  ')` makes the JSON pretty and readable.

## 36. Type Casting With `as`

```dart
json['id'] as String
```

Means:

```text
Treat this value as a String.
```

If the value is not a String, Dart throws an error.

```dart
json['tags'] as List<dynamic>?
```

Means:

```text
This value may be a List of dynamic values, or null.
```

## 37. Type Checking With `is` And `is!`

```dart
if (decoded is! List) {
  throw VaultException('Vault file must contain a JSON list.');
}
```

`is` means "is this type?"

`is!` means "is not this type?"

## 38. File Operations

From `dart:io`:

```dart
final file = File('.learning_secret_vault.json');
```

This creates a `File` object. It does not necessarily create the file yet.

Common operations:

```dart
await file.exists();
await file.readAsString();
await file.writeAsString(text);
await file.delete();
```

Append mode:

```dart
await file.writeAsString('Second line\n', mode: FileMode.append);
```

`await` is used because file operations can take time.

## 39. Terminal Input And Output

From `dart:io`:

```dart
stdout.write('$label > ');
```

Writes to normal output without automatically adding a newline.

```dart
print('Hello');
```

Writes to normal output with a newline.

```dart
stdin.readLineSync()
```

Reads one line of user input.

```dart
stderr.writeln(error.message);
```

Writes to error output.

It is `stderr`, not `stdder`.

Use `stderr` for errors so normal output and error output can be separated by tools.

## 40. `exitCode`

```dart
exitCode = 1;
```

Programs return an exit code to the operating system.

Common meaning:

```text
0
  success

1 or other non-zero number
  failure
```

## 41. Async, `await`, And `async`

```dart
Future<void> initialize() async {
  _secrets = await repository.load();
}
```

Breakdown:

```text
async
  this function can pause while waiting

await
  wait for a Future to finish before continuing

Future<void>
  this function completes later and returns nothing useful
```

Without `await`, Dart may continue before the file is loaded.

## 42. Streams And `await for`

A `Stream<T>` is many future values over time.

`Future<T>`:

```text
one value later
```

`Stream<T>`:

```text
many values over time
```

In the app:

```dart
Stream<String> auditTicker(List<AuditEvent> events) async* {
  for (final event in events) {
    await Future<void>.delayed(Duration(milliseconds: 10));
    yield event.toString();
  }
}
```

Breakdown:

```text
async*
  this function produces a Stream

yield
  send one value into the Stream
```

Read a stream:

```dart
await for (final eventText in auditTicker(events)) {
  print(eventText);
}
```

## 43. Generators: `sync*`, `async*`, `yield`

Synchronous generator:

```dart
Iterable<int> countdown(int from) sync* {
  for (var i = from; i >= 0; i--) {
    yield i;
  }
}
```

`sync*` means:

```text
This function lazily produces Iterable values.
```

`yield i` means:

```text
Give the next value to whoever is iterating.
```

Asynchronous generator:

```dart
Stream<String> auditTicker(...) async* { ... }
```

Produces stream values over time.

## 44. Conditions

```dart
if (count == 0) {
  print('empty');
} else if (count == 1) {
  print('one');
} else {
  print('many');
}
```

Operators:

```text
==
  equal

!=
  not equal

>
  greater than

<
  less than

>=
  greater than or equal

<=
  less than or equal
```

Logical operators:

```text
&&
  AND

||
  OR

!
  NOT
```

Ternary operator:

```dart
hasSecrets ? 'vault has data' : 'vault is empty'
```

Means:

```text
if hasSecrets is true, use first value.
otherwise use second value.
```

## 45. Switch Statements And Switch Expressions

Switch statement:

```dart
switch (command) {
  case VaultCommand.add:
    await _addFlow();
  case VaultCommand.exit:
    running = false;
}
```

It chooses code based on a value.

Switch expression:

```dart
final risk = switch (count) {
  0 => 'none',
  >= 1 && <= 3 => 'small',
  _ => 'large',
};
```

Breakdown:

```text
0 => 'none'
  if count is 0, return none

>= 1 && <= 3
  relational pattern

_
  default case
```

## 46. Loops

### `for`

```dart
for (var i = 0; i < 3; i++) {
  print(i);
}
```

Best when you need an index.

### `for-in`

```dart
for (final category in SecretCategory.values) {
  print(category.name);
}
```

Best when you want each item.

### `while`

```dart
while (running) {
  ...
}
```

Runs while condition is true.

### `do-while`

```dart
do {
  ...
} while (condition);
```

Runs at least once.

### `forEach`

```dart
items.forEach((item) => print(item));
```

Calls a function for each item.

### `break`

Stops the loop.

### `continue`

Skips to the next loop iteration.

## 47. Error Handling

```dart
try {
  service.getById('missing-id');
} on VaultException catch (error) {
  print(error.message);
} catch (error, stackTrace) {
  print(error);
} finally {
  print('always runs');
}
```

Breakdown:

```text
try
  code that might fail

on VaultException
  catch a specific error type

catch (error)
  catch the error object

catch (error, stackTrace)
  catch error and where it happened

finally
  always runs after try/catch
```

Throwing an error:

```dart
throw VaultException('Title is required.');
```

Custom exception:

```dart
class VaultException implements Exception
```

Means:

```text
VaultException is an exception type our app understands.
```

## 48. Audit Events And Logs

The app has:

```dart
final List<AuditEvent> _auditLog = <AuditEvent>[];
```

This is an in-memory list of events.

When something happens:

```dart
_audit('add', 'Added "Gmail".');
```

It creates:

```text
action: add
detail: Added "Gmail".
createdAt: current time
```

This is not a full production logging system. It is a beginner-friendly example of recording app events.

Production logging usually needs:

```text
log levels
structured logs
redaction of secrets
file or server output
rotation
monitoring
```

## 49. Records

Records group small pieces of data without creating a class.

```dart
({int total, Set<String> uniqueTags}) summarizeSecrets(...)
```

This returns a named record with:

```text
total
uniqueTags
```

Use:

```dart
final summary = summarizeSecrets(service.secrets);
print(summary.total);
print(summary.uniqueTags);
```

Destructuring:

```dart
final (:total, :uniqueTags) = summary;
```

Means:

```text
Create local variables total and uniqueTags from the record fields.
```

## 50. Pattern Matching

In:

```dart
final risk = switch (count) {
  0 => 'none',
  >= 1 && <= 3 => 'small',
  _ => 'large',
};
```

Dart is matching the value of `count` against patterns.

Patterns are a newer Dart feature. They help you inspect and destructure values clearly.

## 51. Cascade Operator `..`

In:

```dart
tags.toList()..sort()
```

The `..` is the cascade operator.

Meaning:

```text
Take the list from tags.toList(),
call sort() on that same list,
then return the list.
```

Without cascade:

```dart
final list = tags.toList();
list.sort();
return list;
```

## 52. `DateTime`

```dart
DateTime.now()
```

Current date and time.

```dart
createdAt.toIso8601String()
```

Converts a date to a standard string format useful for JSON.

```dart
DateTime.tryParse(text)
```

Tries to convert text back into a `DateTime`.

If it fails, returns `null`.

## 53. Random Numbers

```dart
Random().nextInt(999999)
```

Generates a random integer from `0` up to but not including `999999`.

In the app, this helps create demo ids.

Production note: this is not for security tokens.

## 54. Base64, UTF-8, And Runes

In `ToySecretCodec`:

```dart
plainText.runes
```

`runes` are Unicode code points of a string.

```dart
String.fromCharCode(codePoint)
```

Turns a number back into a character.

```dart
utf8.encode(text)
```

Turns text into bytes.

```dart
base64Url.encode(bytes)
```

Turns bytes into safe text.

Again: this is encoding, not real security.

## 55. Method Chaining

Example:

```dart
input
  .split(',')
  .map((tag) => tag.trim().toLowerCase())
  .where((tag) => tag.isNotEmpty)
  .toSet();
```

Read top to bottom:

```text
split input by comma
trim and lowercase each tag
keep non-empty tags
convert to a Set
```

Each method returns something that the next method uses.

## 56. Production-Grade Thinking Used Here

Even though this is one file, the app separates responsibilities.

```text
Secret
  data model

SecretFileRepository
  storage

VaultService
  business logic

VaultCli
  user interaction

ToySecretCodec
  encoding/decoding

VaultException
  app-specific errors
```

This style scales better than putting every line inside `main`.

## 57. What To Study First

Study in this order:

1. Variables and data types.
2. Strings.
3. Lists, sets, maps.
4. Functions.
5. Conditions and loops.
6. Classes and objects.
7. Constructors.
8. Enums.
9. JSON maps.
10. File operations.
11. Async, Future, await.
12. Error handling.
13. Interfaces, mixins, inheritance.
14. Generics.
15. Streams and records.

## 58. Tiny Glossary

```text
argument
  value passed into a function

parameter
  variable listed in a function definition

return
  send a value back from a function

object
  actual instance of a class

method
  function inside a class

field
  variable inside a class

property
  field or getter/setter accessed with dot syntax

constructor
  special function that creates an object

interface
  contract a class promises to follow

exception
  error object that can be thrown and caught

stack trace
  list showing where an error happened

JSON
  text format for structured data

serialization
  converting object to savable/sendable format

deserialization
  converting saved/sent data back to objects

CLI
  command line interface

stdin
  standard input, usually keyboard input

stdout
  standard output, normal program output

stderr
  standard error, error output
```

## 59. Final Mental Model

When you see a Dart line, ask:

```text
1. What type is being used?
2. What name is being created or called?
3. Is this a value, function, class, or object?
4. Is it synchronous now or asynchronous later?
5. Can it be null?
6. Can it throw an error?
7. Is it changing state or just returning a value?
```

If you can answer those questions, Dart code starts becoming readable.

