# Dart & Flutter Concepts Guide (For Programmers)

A comprehensive reference covering all fundamental Dart concepts in proper learning sequence, followed by Flutter-specific concepts. Designed for developers who already know programming basics and want to master Dart and Flutter quickly.

---

## Learning Path Overview

```
Stage 1 — Dart Basics
  1. Architecture & main()
  2. Variables & Types
  3. Operators
  4. Strings
  5. Null Safety
  6. Control Flow
  7. Functions
  8. Error Handling

Stage 2 — Data & OOP
  9. Collections (List, Set, Map)
  10. Object-Oriented Programming
  11. Generics
  12. Enums
  13. Records (Dart 3+)
  14. Pattern Matching (Dart 3+)

Stage 3 — Advanced Dart
  15. Async Programming (Future, async/await)
  16. Streams & Generators
  17. Concurrency & Isolates
  18. File I/O & Terminal
  19. JSON Serialization
  20. Math & DateTime
  21. Type System Utilities
  22. Packages, Imports & Tooling

Stage 4 — Flutter
  23. Flutter Architecture & Widgets
  24. Layouts & Common Widgets
  25. State Management
  26. Navigation & Routing
  27. Async in Flutter (FutureBuilder, StreamBuilder)
  28. Theming & Styling
```

---

## Stage 1 — Dart Basics

---

## 1. Dart Architecture & `main()`

Dart has a flexible compilation pipeline:

- **JIT (Just-In-Time):** Used in development. Powers *hot reload* — see changes instantly without losing state.
- **AOT (Ahead-Of-Time):** Used in production. Compiles to fast native machine code (ARM, x64).
- **Web:** Compiles to optimized JavaScript or WebAssembly.

Every Dart program starts at `main()`:

```dart
// Simplest entry point
void main() {
  print('Hello, Dart!');
}

// With command-line arguments
void main(List<String> args) {
  print(args); // e.g. ['--verbose', 'input.txt']
}

// Async entry point (Flutter uses this)
Future<void> main() async {
  await runApp();
}
```

---

## 2. Variables and Data Types

Dart is statically typed with powerful type inference.

### Declaration Keywords

```dart
var name = 'Dart';             // Type inferred (String); can be reassigned
final created = DateTime.now(); // Assigned once; value evaluated at runtime
const maxItems = 100;           // Compile-time constant; must be a literal value
```

| Keyword | Reassignable? | When value is decided | Typical use |
|---------|:---:|---|---|
| `var` | ✅ | Runtime | Local mutable variables |
| `final` | ❌ | Runtime | Constants known only at runtime |
| `const` | ❌ | Compile time | True constants (numbers, strings) |

### Core Built-in Types

```dart
int count = 42;         // Whole numbers
double pi = 3.14159;    // Floating-point
num flexible = 3;       // Can be int or double
String name = 'Dart';   // Text
bool isReady = true;    // true / false
```

| Type | Description | Example |
|---|---|---|
| `int` | Whole numbers | `42`, `-7` |
| `double` | Decimal numbers | `3.14`, `-0.5` |
| `num` | Supertype of int and double | `num x = 3` |
| `String` | Text | `'hello'` |
| `bool` | True or false | `true`, `false` |
| `dynamic` | Disables type checking (avoid) | `dynamic x = 'hi'` |
| `Object` | Base class of all non-null objects | `Object o = 42` |
| `void` | Signals no return value | `void run() {...}` |

---

## 3. Operators

### Arithmetic
```dart
int a = 10, b = 3;
a + b;    // 13  — addition
a - b;    // 7   — subtraction
a * b;    // 30  — multiplication
a / b;    // 3.333... — division (always double)
a ~/ b;   // 3   — integer division (truncates)
a % b;    // 1   — remainder / modulo
-a;       // -10 — unary negation
```

### Comparison and Logical
```dart
a == b;   a != b;   a > b;   a < b;   a >= b;   a <= b;

bool x = true, y = false;
x && y;   // AND — both must be true
x || y;   // OR  — at least one true
!x;       // NOT — flips boolean
```

### Assignment and Compound
```dart
int n = 5;
n += 3;    // n = 8
n -= 2;    // n = 6
n *= 4;    // n = 24
n ~/= 5;   // n = 4
n ??= 10;  // assign only if n is currently null
```

### Type Test Operators
```dart
Object val = 'hello';

val is String;    // true  — type check
val is! int;      // true  — negated type check

// Safe cast
String s = val as String; // throws if wrong type

// Checking runtime type
print(val.runtimeType); // String
```

---

## 4. String Operations

```dart
// Interpolation
String name = 'Dart';
'Hello, $name!';          // Simple variable
'2 + 2 = ${2 + 2}';      // Expression inside ${}

// Multiline
String multi = '''
Line one
Line two
''';

// Raw strings — backslashes treated literally
String raw = r'No \n escape here';

// Adjacent string literals are auto-concatenated
String s = 'Hello '
           'World'; // 'Hello World'
```

### Common String Methods
```dart
String s = '  Dart Programming  ';

s.length;                    // character count
s.trim();                    // 'Dart Programming'
s.trimLeft();                // 'Dart Programming  '
s.trimRight();               // '  Dart Programming'
s.toUpperCase();             // '  DART PROGRAMMING  '
s.toLowerCase();             // '  dart programming  '
s.contains('Dart');          // true
s.startsWith('  ');          // true
s.endsWith('ing  ');         // true
s.indexOf('P');              // first occurrence index
s.lastIndexOf('i');          // last occurrence index
s.substring(2, 6);           // 'Dart'
s.replaceAll(' ', '_');      // '__Dart_Programming__'
s.replaceFirst('Dart', 'Go'); // replace only first match
s.trim().split(' ');         // ['Dart', 'Programming']
s.isEmpty;                   // false
''.isEmpty;                  // true
s.isNotEmpty;                // true

// Checking content
'123'.contains(RegExp(r'^\d+$')); // true — regex support

// Padding
'5'.padLeft(3, '0');   // '005'
'hi'.padRight(5, '-'); // 'hi---'
```

---

## 5. Null Safety

Dart enforces sound null safety at compile time. All types are **non-nullable by default**.

```dart
String name = 'Dart';  // Cannot be null — compiler enforces this
String? alias;          // Nullable type — can be null
```

### Null Operators
```dart
String? city;

// ?? — provide a fallback if null
String display = city ?? 'Unknown';

// ??= — assign only if currently null
city ??= 'Karachi';

// ?. — safe call; returns null instead of throwing
int? len = city?.length;

// ?[] — null-safe index access
List<String>? items;
String? first = items?[0];

// ! — null assertion; throws at runtime if actually null
String definite = city!; // use sparingly

// late — non-nullable, initialized after declaration
late String token;       // must be assigned before first use
token = fetchToken();
```

### Type Promotion
Dart automatically narrows a nullable type once you check it:

```dart
String? maybeNull;

if (maybeNull != null) {
  // Inside here, Dart treats maybeNull as String (not String?)
  print(maybeNull.toUpperCase()); // No ! needed
}
```

---

## 6. Control Flow

### If / Else
```dart
int score = 75;

if (score >= 90) {
  print('A');
} else if (score >= 70) {
  print('B');
} else {
  print('C');
}

// Ternary operator
String result = score >= 70 ? 'Pass' : 'Fail';
```

### Switch
```dart
// Switch statement (Dart 3+ — no break needed, no implicit fallthrough)
String command = 'start';
switch (command) {
  case 'start':
    print('Starting');
  case 'stop':
    print('Stopping');
  default:
    print('Unknown command');
}

// Switch expression — returns a value
String grade = switch (score) {
  >= 90 => 'A',
  >= 70 => 'B',
  >= 50 => 'C',
  _     => 'F', // _ is the wildcard / default
};
```

### Loops
```dart
// Classic for loop
for (int i = 0; i < 5; i++) {
  print(i); // 0 1 2 3 4
}

// for-in — iterate over any Iterable
for (final item in ['a', 'b', 'c']) {
  print(item);
}

// while
int i = 0;
while (i < 3) {
  print(i++);
}

// do-while — body runs at least once
do {
  print('at least once');
} while (false);

// break and continue
for (int n = 0; n < 10; n++) {
  if (n == 3) continue; // skip 3
  if (n == 7) break;    // stop at 7
  print(n);
}
```

---

## 7. Functions

Functions are first-class objects in Dart — they can be stored in variables, passed as arguments, and returned from other functions.

### Syntax Variants
```dart
// Standard block body
int add(int a, int b) {
  return a + b;
}

// Arrow — for single-expression functions
int multiply(int a, int b) => a * b;

// Void — no return value
void greet(String name) => print('Hello, $name');

// Top-level and local functions both work the same way
```

### Parameter Types
```dart
// Required positional
void log(String message) { print(message); }

// Optional positional — wrap in []
void log2(String msg, [String level = 'info']) {
  print('[$level] $msg');
}
log2('Server started');           // [info] Server started
log2('Auth failed', 'error');     // [error] Auth failed

// Named parameters — wrap in {}
void configure({
  required String host,
  int port = 8080,
  bool ssl = false,
}) {
  print('$host:$port ssl=$ssl');
}
configure(host: 'localhost');
configure(host: 'prod.com', port: 443, ssl: true);
```

### Anonymous Functions (Lambdas)
```dart
final double = (int n) => n * 2;

// Multi-line anonymous function
final greet = (String name) {
  final msg = 'Hello, $name!';
  return msg;
};
```

### Closures
A closure captures variables from its surrounding scope.

```dart
Function makeCounter() {
  int count = 0;             // This variable is captured
  return () => ++count;      // Each call remembers count
}

final c = makeCounter();
print(c()); // 1
print(c()); // 2
print(c()); // 3
```

### Higher-Order Functions
```dart
int apply(int x, int Function(int) transform) => transform(x);

print(apply(5, (n) => n * n)); // 25
print(apply(10, (n) => n + 1)); // 11
```

### Typedefs
```dart
// Create readable names for function types
typedef Transformer = int Function(int);
typedef Predicate<T> = bool Function(T);
typedef JsonFactory<T> = T Function(Map<String, dynamic>);

Transformer triple = (n) => n * 3;
Predicate<String> isLong = (s) => s.length > 10;
```

---

## 8. Error Handling

### Try / Catch / Finally
```dart
try {
  // Code that might fail
  int result = int.parse('not a number');
} on FormatException catch (e) {
  // Catch a specific exception type
  print('Format error: ${e.message}');
} on RangeError {
  // Catch type without binding variable
  print('Out of range');
} catch (e, stackTrace) {
  // Catch anything else; stackTrace shows origin
  print('Unknown: $e');
  print(stackTrace);
} finally {
  // Always runs — use for cleanup
  print('Done (runs regardless of success or failure)');
}
```

### Throwing Exceptions
```dart
// Throw built-in types
throw FormatException('Invalid input');
throw ArgumentError.value(-1, 'count', 'Must be positive');

// Throw any object (not recommended; use Exception types)
throw 'Something went wrong'; // works but poor practice
```

### Custom Exceptions
```dart
class AppException implements Exception {
  final String message;
  final int? code;

  AppException(this.message, {this.code});

  @override
  String toString() => 'AppException($code): $message';
}

// Usage
throw AppException('User not found', code: 404);
```

### Rethrowing
```dart
void process() {
  try {
    riskyOperation();
  } catch (e) {
    logError(e);
    rethrow; // Re-throw the same exception up the call stack
  }
}
```

---

## Stage 2 — Data & OOP

---

## 9. Collections (List, Set, Map)

### List — Ordered, allows duplicates
```dart
final nums = <int>[1, 2, 3];

// Adding
nums.add(4);               // append one item
nums.addAll([5, 6]);        // append multiple
nums.insert(0, 0);         // insert at index

// Removing
nums.remove(3);            // by value (first match)
nums.removeAt(0);          // by index
nums.removeLast();         // remove last
nums.removeWhere((n) => n.isEven); // conditional
nums.clear();              // remove all

// Reading
nums.length;
nums.isEmpty;
nums.isNotEmpty;
nums.first;
nums.last;
nums[2];                   // index access
nums.contains(5);
nums.indexOf(5);           // -1 if not found
nums.lastIndexOf(2);
nums.sublist(1, 3);        // slice [1, 3)

// Sorting
nums.sort();               // ascending in-place
nums.sort((a, b) => b.compareTo(a)); // descending

// Reversing
nums.reversed.toList();

// Utility
List.filled(3, 0);         // [0, 0, 0]
List.generate(5, (i) => i * 2); // [0, 2, 4, 6, 8]
```

### Set — Unordered, unique values
```dart
final roles = <String>{'admin', 'user', 'admin'}; // {'admin', 'user'}

roles.add('moderator');
roles.addAll({'viewer', 'editor'});
roles.remove('user');
roles.contains('admin');    // true
roles.length;
roles.isEmpty;

// Set math
roles.union({'guest'});                  // all from both
roles.intersection({'admin', 'guest'});  // only common items
roles.difference({'admin'});             // in roles, not in argument

// Convert to/from List
[1, 2, 2, 3].toSet();     // {1, 2, 3} — remove duplicates
roles.toList();            // back to List
```

### Map — Key-value pairs
```dart
final scores = <String, int>{'Alice': 95, 'Bob': 80};

// Reading
scores['Alice'];           // 95
scores['Nobody'];          // null (safe; doesn't throw)
scores.containsKey('Bob'); // true
scores.containsValue(80);  // true
scores.keys;               // Iterable of keys
scores.values;             // Iterable of values
scores.entries;            // Iterable<MapEntry<String, int>>
scores.length;
scores.isEmpty;

// Writing
scores['Charlie'] = 70;
scores.update('Alice', (v) => v + 5); // 95 → 100
scores.putIfAbsent('Dave', () => 60); // only adds if key absent
scores.remove('Bob');
scores.removeWhere((k, v) => v < 70);

// Iterating
for (final entry in scores.entries) {
  print('${entry.key}: ${entry.value}');
}
scores.forEach((key, val) => print('$key: $val'));

// Convert to map from a list
final map = {for (var s in ['a', 'b']) s: s.toUpperCase()};
// {'a': 'A', 'b': 'B'}
```

### Collection Literals: Spread, if, for
```dart
final extra = [4, 5];
final list = [
  1, 2, 3,
  ...extra,                        // Spread — inserts all items
  ...?nullableList,                 // Null-aware spread — safe if null
  if (extra.length > 1) 99,        // Conditional inclusion
  for (var i = 6; i <= 8; i++) i,  // Inline generation
];
// [1, 2, 3, 4, 5, 99, 6, 7, 8]
```

### Collection Transformations
```dart
final nums = [1, 2, 3, 4, 5];

nums.map((n) => n * 2).toList();         // [2, 4, 6, 8, 10]
nums.where((n) => n.isEven).toList();    // [2, 4]
nums.fold<int>(0, (acc, n) => acc + n);  // 15 (with seed)
nums.reduce((a, b) => a + b);            // 15 (no seed, needs non-empty list)
nums.any((n) => n > 4);                  // true
nums.every((n) => n > 0);               // true
nums.take(3).toList();                   // [1, 2, 3]
nums.skip(2).toList();                   // [3, 4, 5]
nums.firstWhere((n) => n > 3);           // 4
nums.lastWhere((n) => n < 4);            // 3
nums.firstWhere((n) => n > 10, orElse: () => -1); // -1 (safe fallback)
nums.expand((n) => [n, n]).toList();     // [1,1,2,2,3,3,4,4,5,5]
nums.toSet();                            // {1, 2, 3, 4, 5}
nums.join(', ');                         // '1, 2, 3, 4, 5'
```

---

## 10. Object-Oriented Programming (OOP)

### Classes and Objects
```dart
class Animal {
  // Instance fields
  String name;
  String species;

  // Static (class-level) field
  static int totalCount = 0;

  // Constructor
  Animal(this.name, this.species) {
    totalCount++;
  }

  // Instance method
  void speak() => print('$name says nothing.');

  // Static method — called on the class, not an instance
  static void showCount() => print('Total: $totalCount');
}

// Creating objects
final dog = Animal('Rex', 'Dog');
dog.speak();
Animal.showCount();
```

### Constructors
```dart
class Point {
  final double x, y;

  // 1. Generative constructor (this.x shorthand auto-assigns fields)
  Point(this.x, this.y);

  // 2. Named constructor
  Point.origin() : x = 0, y = 0; // initializer list after :

  // 3. Named constructor with custom logic in initializer list
  Point.fromMap(Map<String, double> m)
      : x = m['x'] ?? 0,
        y = m['y'] ?? 0;

  // 4. Factory constructor — can return existing instance or subtype
  factory Point.unit(String axis) {
    return axis == 'x' ? Point(1, 0) : Point(0, 1);
  }

  // 5. Const constructor — object becomes a compile-time constant
  const Point.zero() : x = 0, y = 0;
}

const origin = Point.zero(); // Compile-time constant object
```

### Getters, Setters, and Private Members
In Dart, privacy is **file-level** (library-level). A `_` prefix makes a member private to its file.

```dart
class BankAccount {
  double _balance = 0; // Private field

  // Getter — access like a property
  double get balance => _balance;

  // Setter — validate before assigning
  set deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Must be positive');
    _balance += amount;
  }

  void _audit() { /* private method */ }
}

final account = BankAccount();
account.deposit = 1000; // calls setter
print(account.balance); // calls getter
```

### Cascade Operator (`..`)
```dart
// Without cascade:
final sb = StringBuffer();
sb.write('Hello');
sb.write(' Dart');
sb.writeln('!');

// With cascade — chains calls on the same object:
final sb2 = StringBuffer()
  ..write('Hello')
  ..write(' Dart')
  ..writeln('!');

print(sb2.toString()); // 'Hello Dart!\n'
```

### Abstract Classes
Define a contract. Cannot be instantiated directly.

```dart
abstract class Shape {
  double get area;      // Abstract: must be implemented by subclass
  double get perimeter;

  // Concrete method — shared implementation
  void describe() => print('area=${area.toStringAsFixed(2)}');
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);

  @override double get area => 3.14159 * radius * radius;
  @override double get perimeter => 2 * 3.14159 * radius;
}
```

### Inheritance (`extends`)
```dart
class Vehicle {
  String brand;
  int speed;
  Vehicle(this.brand, this.speed);

  void describe() => print('$brand at $speed km/h');
}

class Car extends Vehicle {
  int doors;
  // super.brand, super.speed forwards to parent constructor
  Car(super.brand, super.speed, this.doors);

  @override
  void describe() {
    super.describe();       // call parent's version first
    print('Doors: $doors');
  }
}
```

### Interfaces (`implements`)
Every class implicitly defines an interface. Use `implements` to adopt a contract without inheriting implementation.

```dart
abstract class Serializable {
  Map<String, dynamic> toMap();
}

abstract class Loggable {
  String get logTag;
}

class Product implements Serializable, Loggable {
  String name;
  double price;
  Product(this.name, this.price);

  @override Map<String, dynamic> toMap() => {'name': name, 'price': price};
  @override String get logTag => 'Product:$name';
}
```

### Mixins (`with`)
Mixins add reusable behavior to any class without inheritance.

```dart
mixin Timestamps {
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  void touch() => updatedAt = DateTime.now();
}

mixin Validatable {
  bool validate(); // abstract — implementer must provide
}

class User with Timestamps, Validatable {
  String name;
  User(this.name);

  @override bool validate() => name.isNotEmpty;
}

// Restrict a mixin to a specific supertype:
mixin AnimalSounds on Animal {
  void roar() => print('${name} roars!');
}
```

### Extensions
Add methods and properties to existing types without modifying them.

```dart
extension StringExtensions on String {
  bool get isBlank => trim().isEmpty;
  String capitalize() =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
  String repeat(int times) => List.filled(times, this).join();
}

extension ListExtensions<T> on List<T> {
  T? get secondOrNull => length >= 2 ? this[1] : null;
  List<T> get shuffled => [...this]..shuffle();
}

// Usage
'hello'.capitalize(); // 'Hello'
'ab'.repeat(3);       // 'ababab'
'  '.isBlank;         // true
[1, 2, 3].secondOrNull; // 2
```

---

## 11. Generics

Generics let you write type-safe, reusable code.

### Generic Functions
```dart
T identity<T>(T value) => value;

// Type argument inferred automatically:
print(identity(42));       // int
print(identity('hello'));  // String

// Or specified explicitly:
print(identity<double>(3.14));
```

### Generic Classes
```dart
class Box<T> {
  T value;
  Box(this.value);
  T unwrap() => value;
  @override String toString() => 'Box<$T>($value)';
}

final stringBox = Box<String>('hello');
final intBox = Box(42); // inferred as Box<int>
```

### Bounded Generics (Type Constraints)
```dart
// T must extend num — ensures numeric operations are available
class NumberBox<T extends num> {
  T value;
  NumberBox(this.value);
  double asDouble() => value.toDouble();
}

// T must implement a specific interface
class Repository<T extends Serializable> {
  List<T> _items = [];
  void add(T item) => _items.add(item);
  List<Map<String, dynamic>> toJsonList() =>
      _items.map((i) => i.toMap()).toList();
}
```

---

## 12. Enums

### Simple Enum
```dart
enum Direction { north, south, east, west }

Direction dir = Direction.north;
print(dir.name);   // 'north'
print(dir.index);  // 0

for (final d in Direction.values) {
  print(d);
}
```

### Enhanced Enum (with fields and methods)
```dart
enum HttpStatus {
  ok(200, 'OK'),
  created(201, 'Created'),
  notFound(404, 'Not Found'),
  serverError(500, 'Internal Server Error');

  final int code;
  final String message;
  const HttpStatus(this.code, this.message);

  bool get isError => code >= 400;
  bool get isSuccess => code >= 200 && code < 300;

  @override
  String toString() => '$code $message';
}

// Usage
print(HttpStatus.notFound.code);       // 404
print(HttpStatus.serverError.isError); // true

// Look up by name
HttpStatus.values.byName('ok'); // HttpStatus.ok
```

---

## 13. Records (Dart 3+)

Records are anonymous, immutable, lightweight data structures — like typed tuples.

```dart
// Positional record
var coords = (10.5, 20.0);
print(coords.$1); // 10.5
print(coords.$2); // 20.0

// Named fields
var user = (name: 'Alice', age: 30);
print(user.name); // 'Alice'
print(user.age);  // 30

// Returning multiple values cleanly
(String name, int age) parseUser(String raw) {
  final parts = raw.split(':');
  return (parts[0], int.parse(parts[1]));
}

final (name, age) = parseUser('Bob:25'); // Destructuring

// Mixed positional + named
var entry = ('dart', version: 3, stable: true);
print(entry.$1);       // 'dart'
print(entry.version);  // 3
```

---

## 14. Pattern Matching (Dart 3+)

Patterns match and destructure values in switch expressions, variable declarations, and if-case statements.

```dart
// Variable patterns
final [first, second, ...rest] = [1, 2, 3, 4, 5];
print(first);  // 1
print(rest);   // [3, 4, 5]

// Map pattern
final {'name': String n, 'age': int a} = {'name': 'Alice', 'age': 30};

// if-case pattern
Object response = {'status': 200, 'body': 'OK'};
if (response case {'status': int code, 'body': String body}) {
  print('$code: $body');
}

// Sealed classes + exhaustive switch
sealed class Shape {}
class Circle extends Shape { double radius; Circle(this.radius); }
class Rect extends Shape { double w, h; Rect(this.w, this.h); }

double area(Shape s) => switch (s) {
  Circle(:var radius)  => 3.14 * radius * radius,
  Rect(:var w, :var h) => w * h,
  // No default needed — sealed class is exhaustive
};
```

---

## Stage 3 — Advanced Dart

---

## 15. Asynchronous Programming

Dart's async model uses an **event loop**. The `async`/`await` syntax makes async code look synchronous.

### Future — One value, later
```dart
// Declaring an async function
Future<String> fetchUser(int id) async {
  await Future.delayed(Duration(seconds: 1)); // Simulate network
  return 'User $id';
}

// Consuming it
void main() async {
  final user = await fetchUser(42);     // Waits for the value
  print(user);

  // Parallel futures — run all at once, wait for all to finish
  final results = await Future.wait([
    fetchUser(1),
    fetchUser(2),
    fetchUser(3),
  ]);
  print(results); // ['User 1', 'User 2', 'User 3']

  // First to complete wins
  final first = await Future.any([fetchUser(5), fetchUser(6)]);
  print(first);

  // Handle errors in async code
  try {
    await Future.error('Network failed');
  } catch (e) {
    print('Caught: $e');
  }
}
```

### async / await rules
```dart
// Any function using await must be marked async
Future<int> compute() async {
  int a = await getA();
  int b = await getB();
  return a + b; // async functions auto-wrap return in Future
}
```

---

## 16. Streams and Generators

### Streams — Multiple values over time
```dart
// Creating a stream with async*
Stream<int> ticker(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    yield i; // emit one value into the stream
  }
}

// Consuming: await for (best for sequential processing)
void listen() async {
  await for (final val in ticker(5)) {
    print(val); // 1, 2, 3, 4, 5 (with delays)
  }
}

// Consuming: .listen() (best for persistent/UI subscriptions)
final sub = ticker(3).listen(
  (val) => print(val),
  onError: (e) => print('Error: $e'),
  onDone: () => print('Stream finished'),
  cancelOnError: false,
);

// Cancel subscription when done
sub.cancel();

// Stream transformations
ticker(10)
  .where((n) => n.isEven)
  .map((n) => n * 10)
  .listen(print); // 20, 40, 60, 80, 100
```

### sync* Generators — Lazy Iterables
```dart
Iterable<int> range(int start, int end) sync* {
  for (int i = start; i <= end; i++) {
    yield i; // values are computed one at a time, on demand
  }
}

print(range(1, 5).toList()); // [1, 2, 3, 4, 5]

// Useful for large sequences without creating the full list in memory
Iterable<int> fibonacci() sync* {
  int a = 0, b = 1;
  while (true) {
    yield a;
    final next = a + b;
    a = b;
    b = next;
  }
}

print(fibonacci().take(10).toList()); // [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
```

---

## 17. Concurrency and Isolates

Dart is single-threaded (one event loop). For CPU-intensive work that would freeze the thread, use **Isolates** — fully independent workers with separate memory, communicating only via message passing.

```dart
import 'dart:isolate';

// Simple API (Dart 2.19+) — preferred way
void main() async {
  final result = await Isolate.run(() {
    // This runs on a separate thread
    return List.generate(1000000, (i) => i).fold(0, (a, b) => a + b);
  });
  print(result); // 499999500000
}

// Manual API — for long-lived isolates or bidirectional communication
void heavyTask(SendPort sendPort) {
  int sum = 0;
  for (int i = 0; i < 100000000; i++) sum += i;
  sendPort.send(sum);
}

void runManually() async {
  final receivePort = ReceivePort();
  await Isolate.spawn(heavyTask, receivePort.sendPort);

  receivePort.listen((message) {
    print('Result from isolate: $message');
    receivePort.close();
  });
}
```

---

## 18. File I/O and Terminal (`dart:io`)

`dart:io` works only on native platforms (macOS, Linux, Windows, iOS, Android) — not on the web.

```dart
import 'dart:io';

void fileExamples() async {
  final file = File('notes.txt');

  // Write (creates file, overwrites if exists)
  await file.writeAsString('First line\n');

  // Append
  await file.writeAsString('Second line\n', mode: FileMode.append);

  // Check existence
  if (await file.exists()) {
    // Read full content
    String content = await file.readAsString();
    print(content);

    // Read as lines
    List<String> lines = await file.readAsLines();
    lines.forEach(print);

    // Read as bytes
    List<int> bytes = await file.readAsBytes();
    print('${bytes.length} bytes');
  }

  // Delete
  await file.delete();
}

void terminalExamples() {
  // Output
  print('Adds newline automatically');
  stdout.write('No newline');
  stderr.writeln('Error to stderr stream');

  // Input
  stdout.write('Enter name: ');
  String? input = stdin.readLineSync();
  print('You entered: $input');

  // Exit code (0 = success, non-zero = failure)
  exitCode = 0;
}
```

---

## 19. JSON Serialization (`dart:convert`)

```dart
import 'dart:convert';

// --- Encoding and Decoding ---
String jsonStr = '{"name": "Alice", "scores": [95, 87, 100]}';

// Decode: JSON string → Dart Map/List
Map<String, dynamic> data = jsonDecode(jsonStr);
print(data['name']);        // 'Alice'
print(data['scores'][0]);  // 95

// Encode: Dart object → JSON string
String encoded = jsonEncode({'user': 'Bob', 'active': true});
// '{"user":"Bob","active":true}'

// Pretty-print with indentation
final encoder = JsonEncoder.withIndent('  ');
print(encoder.convert(data));

// --- Manual Serialization Pattern (no code generation) ---
class User {
  final String name;
  final int age;
  User(this.name, this.age);

  Map<String, dynamic> toJson() => {'name': name, 'age': age};

  factory User.fromJson(Map<String, dynamic> json) =>
      User(json['name'] as String, json['age'] as int);
}

// Encode a list of objects
final users = [User('Alice', 30), User('Bob', 25)];
final jsonList = jsonEncode(users.map((u) => u.toJson()).toList());

// Decode a list of objects
final rawList = jsonDecode(jsonList) as List;
final parsed = rawList.map((e) => User.fromJson(e)).toList();
```

---

## 20. Math and DateTime (`dart:math`)

```dart
import 'dart:math';

// Math functions
max(10, 20);          // 20
min(10, 20);          // 10
pow(2, 10);           // 1024.0
sqrt(144);            // 12.0
log(e);               // 1.0
sin(pi / 2);          // 1.0
pi;                   // 3.14159265...
e;                    // 2.71828...

// Random
final rng = Random();
rng.nextInt(100);     // Random int 0 to 99
rng.nextDouble();     // Random double 0.0 to 1.0
rng.nextBool();       // Random bool

Random.secure();      // Cryptographically secure random

// DateTime
final now = DateTime.now();
now.year; now.month; now.day;
now.hour; now.minute; now.second;
now.millisecondsSinceEpoch;

// Parse
DateTime.parse('2026-06-01T10:30:00');
DateTime.tryParse('invalid'); // null (safe)

// Format
now.toIso8601String(); // '2026-06-01T10:30:00.000'

// Arithmetic with Duration
final tomorrow = now.add(Duration(days: 1));
final lastWeek = now.subtract(Duration(days: 7));
final diff = tomorrow.difference(now);
print(diff.inHours);   // 24
print(diff.inMinutes); // 1440

// Comparison
now.isBefore(tomorrow);  // true
now.isAfter(lastWeek);   // true
```

---

## 21. Type System Utilities

```dart
Object value = 'hello world';

// is — type check; also promotes type inside the block
if (value is String) {
  print(value.toUpperCase()); // Dart knows it's String here; no cast needed
}

// is! — negated type check
if (value is! int) print('Not an int');

// as — forced cast; throws CastError if wrong
String text = value as String;

// runtimeType — get actual type at runtime
print(value.runtimeType); // String

// Type promotion with if-else
String? maybeNull = getValue();
if (maybeNull != null) {
  print(maybeNull.length); // promoted to non-nullable String
}
```

---

## 22. Packages, Imports, and Tooling

### `pubspec.yaml` — Project Manifest
```yaml
name: my_app
description: A sample Dart application
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  http: ^1.2.0       # ^ means: compatible with 1.2.0
  path: ^1.9.0

dev_dependencies:
  test: ^1.24.0      # Only needed for development/testing
  lints: ^3.0.0
```

### Import Variants
```dart
import 'dart:io';                          // Core Dart library
import 'dart:convert';                     // JSON/encoding tools
import 'package:http/http.dart' as http;   // External package with alias
import '../utils/helpers.dart';            // Local file (relative path)
import 'dart:math' show max, min;          // Only import specific names
import 'dart:math' hide Random;            // Import all except Random
```

### Dart CLI Commands

| Command | What it does |
|---|---|
| `dart run file.dart` | Run a Dart script |
| `dart pub get` | Download dependencies |
| `dart pub add http` | Add a package |
| `dart pub upgrade` | Upgrade all packages |
| `dart format .` | Auto-format all Dart files |
| `dart analyze` | Run static analysis / linter |
| `dart test` | Run tests in `test/` directory |
| `dart compile exe main.dart` | Compile to a standalone binary |
| `dart doc` | Generate HTML API documentation |

---

## Stage 4 — Flutter

> Flutter is a UI framework built on Dart. Understanding Dart well is the prerequisite. Here are the key Flutter-specific concepts.

---

## 23. Flutter Architecture & Widgets

In Flutter, **everything is a Widget** — buttons, layouts, text, padding, animations. The UI is described declaratively as a tree of widgets.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart & Flutter Guide',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
```

### StatelessWidget vs StatefulWidget

```dart
// StatelessWidget — UI that never changes after creation
class Greeting extends StatelessWidget {
  final String name;
  const Greeting({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!'); // Rebuilt with new data = new widget
  }
}

// StatefulWidget — UI that can change dynamically
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0; // Mutable state lives here

  void _increment() {
    setState(() {
      _count++; // setState triggers a rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Count: $_count'),
      ElevatedButton(onPressed: _increment, child: const Text('+')),
    ]);
  }
}
```

### Widget Lifecycle (StatefulWidget)
```dart
class _MyState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Called once when widget is inserted into the tree
    // Good for: fetching initial data, setting up controllers
  }

  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Called when parent rebuilds and passes new props
  }

  @override
  void dispose() {
    // Called when widget is permanently removed from tree
    // Good for: cancelling subscriptions, disposing controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container();
}
```

---

## 24. Layouts and Common Widgets

### Layout Widgets
```dart
// Column — vertical layout
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [Text('First'), Text('Second')],
)

// Row — horizontal layout
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [Icon(Icons.home), Text('Home')],
)

// Stack — overlapping layers
Stack(
  alignment: Alignment.center,
  children: [Image.asset('bg.png'), Text('Overlay')],
)

// Expanded — fills available space inside Row/Column
Row(children: [
  Expanded(flex: 2, child: Container(color: Colors.red)),
  Expanded(flex: 1, child: Container(color: Colors.blue)),
])

// Container — box with decoration, padding, margin
Container(
  width: 200,
  height: 100,
  margin: const EdgeInsets.all(8),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
  ),
  child: Text('Hello'),
)
```

### Common Widgets
```dart
// Text
Text('Hello', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))

// Buttons
ElevatedButton(onPressed: () {}, child: Text('Click'))
TextButton(onPressed: () {}, child: Text('Link'))
IconButton(icon: Icon(Icons.add), onPressed: () {})

// Images
Image.asset('assets/logo.png')
Image.network('https://example.com/photo.jpg')

// Input
TextField(
  decoration: InputDecoration(labelText: 'Name', hintText: 'Enter name'),
  onChanged: (value) => print(value),
)

// Scrollable list of many items (lazy, efficient)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(title: Text(items[index])),
)

// Scaffold — provides AppBar, body, FAB, drawer
Scaffold(
  appBar: AppBar(title: Text('My App')),
  body: Center(child: Text('Content')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
)
```

---

## 25. State Management

### Local State — `setState()`
Best for simple, self-contained UI state.

```dart
class ToggleButton extends StatefulWidget {
  const ToggleButton({super.key});
  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isOn,
      onChanged: (val) => setState(() => _isOn = val),
    );
  }
}
```

### Shared State — Provider (Most Popular)
When state needs to be shared across multiple widgets, lift it out of the widget tree.

```dart
// 1. Add to pubspec.yaml: provider: ^6.0.0
import 'package:provider/provider.dart';

// 2. Define a ChangeNotifier
class AppState extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners(); // Tells widgets that subscribed to rebuild
  }
}

// 3. Provide it at the top of the tree
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}

// 4. Read and write from any widget
class CounterDisplay extends StatelessWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>(); // Rebuilds when state changes
    return Text('${state.counter}');
  }
}

class IncrementButton extends StatelessWidget {
  const IncrementButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.read<AppState>().increment(), // No rebuild needed
      child: const Text('Increment'),
    );
  }
}
```

---

## 26. Navigation and Routing

### Basic Navigation
```dart
// Push — go to a new screen
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const DetailScreen()),
);

// Push and get a result back
final result = await Navigator.of(context).push<String>(
  MaterialPageRoute(builder: (_) => const InputScreen()),
);
print('Got back: $result');

// Pop — go back, optionally returning a value
Navigator.of(context).pop('some result');

// Replace current screen
Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (_) => const HomeScreen()),
);

// Clear the entire stack and go to a new screen (e.g., after login)
Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (_) => const HomeScreen()),
  (route) => false, // Remove all previous routes
);
```

### Named Routes
```dart
// Define in MaterialApp
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const HomeScreen(),
    '/details': (context) => const DetailScreen(),
    '/settings': (context) => const SettingsScreen(),
  },
)

// Navigate using name
Navigator.pushNamed(context, '/details');

// Pass arguments
Navigator.pushNamed(context, '/details', arguments: {'id': 42});

// Receive arguments
final args = ModalRoute.of(context)!.settings.arguments as Map;
```

---

## 27. Async in Flutter (FutureBuilder & StreamBuilder)

Flutter provides widgets that automatically rebuild the UI when async data arrives.

### FutureBuilder
```dart
FutureBuilder<String>(
  future: fetchUser(1), // the Future to observe
  builder: (context, snapshot) {
    // snapshot.connectionState: waiting, done, error
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    return Text('Hello, ${snapshot.data}!');
  },
)
```

### StreamBuilder
```dart
StreamBuilder<int>(
  stream: ticker(10), // the Stream to observe
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Text('Waiting...');
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    return Text('Tick: ${snapshot.data}');
  },
)
```

---

## 28. Theming and Styling

```dart
// Define your app theme once in MaterialApp
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.grey[700]),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    useMaterial3: true,
  ),
  darkTheme: ThemeData.dark(useMaterial3: true),
  themeMode: ThemeMode.system, // Follows device setting
)

// Access theme anywhere in the widget tree
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;

  return Text(
    'Themed text',
    style: theme.textTheme.displayLarge?.copyWith(color: colors.primary),
  );
}
```

---

## Quick Reference: Dart → Flutter Mental Map

| Dart Concept | Flutter Usage |
|---|---|
| `class` | Every Widget is a class |
| `final` / `const` | Widget properties are usually `final`; const widgets improve performance |
| `async` / `await` | API calls, loading data in `initState` |
| `Stream` | Used with `StreamBuilder`, real-time data |
| `Future` | Used with `FutureBuilder`, one-time data loads |
| Error handling | `try/catch` in `initState`, `onError` in StreamBuilder |
| Generics `<T>` | `Provider<T>`, `FutureBuilder<T>`, `List<Widget>` |
| Closures | `onPressed: () => doSomething()` callbacks |
| Extensions | Custom widget helpers and style utilities |
| `ChangeNotifier` | Core of Provider state management |
