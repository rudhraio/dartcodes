# Learning Secrets Vault: CLI App Flow

This guide explains the app first, not the Dart language. Read this before reading `README_DART_CONCEPTS.md`.

The file `basic.dart` is a single-file command line app called **Learning Secrets Vault**. It lets you save fake/demo secrets, list them, view them, update them, delete them, search them, and see stats.

Important: this is a learning app. It is not a real production secrets manager. The `ToySecretCodec` is intentionally simple so you can understand it. Real secrets need proper encryption and secure key handling.

## 1. How To Run It

From this folder:

```bash
dart basic.dart --help
```

Shows available commands.

```bash
dart basic.dart --demo
```

Runs a non-interactive learning tour. This is the best first command.

```bash
dart basic.dart
```

Starts the interactive CLI.

## 2. What Files Exist

```text
basic.dart
README_APP_FLOW.md
README_DART_CONCEPTS.md
```

When you run the app normally or with `--demo`, it may create:

```text
.learning_secret_vault.json
```

That JSON file stores saved demo secrets.

## 3. What The App Does

The app has two modes.

### Demo Mode

Command:

```bash
dart basic.dart --demo
```

This does four things:

1. Loads secrets from `.learning_secret_vault.json`.
2. Adds sample data if the vault is empty.
3. Runs many Dart concept demos.
4. Prints output to your terminal.

### Interactive Mode

Command:

```bash
dart basic.dart
```

This opens a loop where you type commands:

```text
add
list
view
update
delete
search
stats
demo
help
exit
```

## 4. The App In One Sentence

The CLI reads user input, converts that input into commands, calls service methods, stores data in a JSON file, and prints useful output.

## 5. Big Picture Flow

```text
main()
  creates File('.learning_secret_vault.json')
  creates SecretFileRepository
  creates ToySecretCodec
  creates VaultService
  loads existing secrets
  checks command line arguments
    if --help -> print help
    if --demo -> seed sample data and run learning tour
    otherwise -> start interactive CLI
```

## 6. Main Classes And Their Jobs

### `Secret`

Represents one saved secret.

Example data:

```text
id: 123456-789000
title: Gmail
encryptedValue: encoded text
category: password
tags: email, personal
createdAt: date/time
updatedAt: date/time
```

In real thinking: `Secret` is the shape of one record.

### `SecretCategory`

An enum that limits category choices.

Allowed categories:

```text
password
apiKey
note
card
other
```

Instead of allowing random strings like `"pass"`, `"pwd"`, `"PASSWORD"`, the enum keeps categories consistent.

### `VaultCommand`

An enum that represents commands typed by the user.

Example:

```text
"add" -> VaultCommand.add
"list" -> VaultCommand.list
"q" -> VaultCommand.exit
```

### `SecretFileRepository`

Handles file storage.

Its job:

1. Read JSON from `.learning_secret_vault.json`.
2. Convert JSON into `Secret` objects.
3. Convert `Secret` objects back into JSON.
4. Write JSON to disk.

### `VaultService`

Contains the main app logic.

Its job:

1. Add secrets.
2. Update secrets.
3. Delete secrets.
4. Search secrets.
5. Reveal secret values.
6. Count secrets by category.
7. Save changes through the repository.
8. Keep a small audit log in memory.

### `VaultCli`

Handles terminal interaction.

Its job:

1. Print the banner and help text.
2. Ask the user for input.
3. Convert input into a command.
4. Call the correct `VaultService` method.
5. Print results or errors.

### `ToySecretCodec`

Encodes and decodes secret values.

Again: this is not secure encryption. It is here so you can learn how data moves through an app.

## 7. End-To-End Example: Adding A Secret

User types:

```text
add
```

Then the app asks:

```text
title > Gmail
secret value > my-password
category password/apiKey/note/card/other > password
tags comma separated > email,personal
```

Flow:

```text
VaultCli.start()
  reads "add"
  parseCommand("add") returns VaultCommand.add
  switch command calls _addFlow()

_addFlow()
  asks for title
  asks for secret value
  asks for category
  asks for tags
  calls service.addSecret(...)

VaultService.addSecret(...)
  validates title and value
  creates a Secret object
  encodes the secret value
  adds Secret to the in-memory list
  sorts the list
  saves list to file
  records audit event

SecretFileRepository.save(...)
  converts Secret objects to maps
  converts maps to JSON text
  writes JSON text into .learning_secret_vault.json

VaultCli._addFlow()
  prints "Added ..."
```

## 8. End-To-End Example: Listing Secrets

User types:

```text
list
```

Flow:

```text
VaultCli.start()
  reads "list"
  parseCommand("list") returns VaultCommand.list
  switch command calls _list(service.secrets)

_list(...)
  if there are no secrets, prints empty message
  otherwise loops through secrets
  prints each row
```

## 9. End-To-End Example: Viewing A Secret

User types:

```text
view
```

Then enters an id:

```text
id > 123456-789000
```

Flow:

```text
VaultCli._viewFlow()
  asks for id
  calls service.getById(id)
  calls service.reveal(id)
  prints full secret details

VaultService.getById(id)
  searches the in-memory list
  returns matching Secret
  throws VaultException if not found

VaultService.reveal(id)
  gets the Secret
  decodes encryptedValue using ToySecretCodec
  returns readable secret value
```

## 10. End-To-End Example: Updating A Secret

User types:

```text
update
```

Flow:

```text
_updateFlow()
  asks for secret id
  loads current secret
  asks for new title
  asks for new secret value
  asks for new category
  asks for new tags
  blank input means "keep old value"
  calls service.updateSecret(...)

VaultService.updateSecret(...)
  finds secret index
  creates updated copy using copyWith(...)
  replaces old object in list
  sorts list
  saves file
  records audit event
```

Why use `copyWith`?

Because it is a clean way to create a modified version of an object while keeping old values you did not change.

## 11. End-To-End Example: Deleting A Secret

User types:

```text
delete
```

Flow:

```text
_deleteFlow()
  asks for id
  asks user to type DELETE
  if confirmed, calls service.deleteSecret(id)

VaultService.deleteSecret(id)
  removes matching item from list
  if nothing was removed, throws VaultException
  saves file
  records audit event
```

## 12. End-To-End Example: Searching

User types:

```text
search
```

Flow:

```text
_searchFlow()
  asks for search query
  calls service.search(query)
  prints matching secrets

VaultService.search(query)
  normalizes query to lowercase
  checks title
  checks category label
  checks tags
  returns matches
```

## 13. End-To-End Example: Stats

User types:

```text
stats
```

Flow:

```text
_stats()
  calls service.countByCategory()
  prints total secrets
  prints count for each category
  prints audit event count
```

## 14. Data Flow Diagram

```text
User
  types command
    |
    v
VaultCli
  reads input and chooses action
    |
    v
VaultService
  applies business rules
    |
    v
SecretFileRepository
  reads/writes JSON file
    |
    v
.learning_secret_vault.json
```

## 15. What Happens When The App Starts

The `main` function is the entry point.

```text
Future<void> main(List<String> arguments) async
```

Meaning:

```text
Future<void>
  main can use await and finishes later

main
  program entry function

List<String> arguments
  command line arguments like --demo or --help

async
  this function contains await
```

Startup pseudocode:

```text
create a File object for .learning_secret_vault.json
create a repository using that file
create a service using repository and codec

try:
  load secrets from file

  if arguments include --help:
    print help
    stop

  if arguments include --demo:
    add sample secrets if file is empty
    run learning tour
    stop

  otherwise:
    start interactive CLI

catch known app errors:
  print error to stderr
  set exitCode = 1

catch file errors:
  print file error to stderr
  set exitCode = 1

catch unexpected errors:
  print full error and stack trace
  set exitCode = 1
```

## 16. How To Build This From Scratch

If you want to rebuild this app without looking at the final code, follow this sequence.

### Step 1: Create A Tiny CLI

Pseudocode:

```text
define main()
print app name
print help text
```

Goal:

```bash
dart basic.dart
```

Should print a title and available commands.

### Step 2: Read User Input

Pseudocode:

```text
function prompt(label):
  print label without newline
  read one line from stdin
  trim spaces
  return string
```

Then:

```text
ask user for command
print what user typed
```

### Step 3: Add A Command Loop

Pseudocode:

```text
running = true

while running:
  command = prompt("command")

  if command == "exit":
    running = false
  else:
    print "unknown command"
```

### Step 4: Create Command Enum

Pseudocode:

```text
enum VaultCommand:
  add
  list
  view
  update
  delete
  search
  stats
  help
  exit
  unknown
```

Create `parseCommand(input)`:

```text
if input is "add" or "a", return add
if input is "list" or "ls", return list
...
otherwise return unknown
```

### Step 5: Create Secret Model

Pseudocode:

```text
class Secret:
  id
  title
  encryptedValue
  category
  tags
  createdAt
  updatedAt
```

Add:

```text
toJson()
fromJson()
toString()
copyWith()
```

### Step 6: Create Category Enum

Pseudocode:

```text
enum SecretCategory:
  password
  apiKey
  note
  card
  other
```

Later, enhance it with a display label like `"API Key"`.

### Step 7: Create Codec

Pseudocode:

```text
class ToySecretCodec:
  encode(text):
    transform text
    base64 encode
    return encoded string

  decode(text):
    base64 decode
    reverse transform
    return original string
```

For production, replace this with real security.

### Step 8: Create Repository

Pseudocode:

```text
class SecretFileRepository:
  load():
    if file does not exist:
      return empty list
    read file as string
    decode JSON
    convert each map to Secret
    return list

  save(secrets):
    convert each Secret to map
    convert list of maps to JSON
    write JSON to file
```

### Step 9: Create Service Layer

Pseudocode:

```text
class VaultService:
  secrets = empty list

  initialize():
    secrets = repository.load()

  addSecret(...):
    validate input
    create Secret
    add to list
    save

  getById(id):
    find matching secret or throw error

  updateSecret(...):
    find secret
    update values
    save

  deleteSecret(id):
    remove secret
    save

  search(query):
    return matching secrets

  countByCategory():
    return map of category -> count
```

### Step 10: Connect CLI To Service

Pseudocode:

```text
switch command:
  add:
    ask for fields
    service.addSecret(...)

  list:
    print service.secrets

  view:
    ask id
    print service.reveal(id)

  update:
    ask id and new fields
    service.updateSecret(...)

  delete:
    ask id
    service.deleteSecret(id)

  search:
    ask query
    print service.search(query)

  stats:
    print service.countByCategory()
```

### Step 11: Add Error Handling

Pseudocode:

```text
try:
  run command
on VaultException:
  print friendly error
catch any other error:
  print unexpected error
finally:
  optional cleanup
```

### Step 12: Add Demo Mode

Pseudocode:

```text
if app started with --demo:
  seed demo data if empty
  run learning examples
```

### Step 13: Add Concept Workshops

Pseudocode:

```text
class StringWorkshop:
  run string examples

class CollectionWorkshop:
  run list, set, map examples
```

### Step 14: Format And Analyze

Always run:

```bash
dart format basic.dart
dart analyze basic.dart
```

`format` makes the code style consistent.

`analyze` finds mistakes before runtime.

## 17. Recommended Reading Order

Read the project like this:

1. Start at `main`.
2. Read `VaultCli.start`.
3. Read one flow, such as `_addFlow`.
4. Follow it into `VaultService.addSecret`.
5. Follow saving into `SecretFileRepository.save`.
6. Read the `Secret` class.
7. Read `SecretCategory` and `VaultCommand`.
8. Read `runLearningTour`.
9. Read `StringWorkshop`.
10. Read `CollectionWorkshop`.
11. Read `README_DART_CONCEPTS.md`.

## 18. Mental Model

Think of the app as four layers:

```text
CLI layer
  Talks to the user.

Service layer
  Decides what the app should do.

Model layer
  Defines what data looks like.

Storage layer
  Saves and loads data.
```

That layered thinking is important for production-grade apps. Even in one file, the responsibilities are separated.

