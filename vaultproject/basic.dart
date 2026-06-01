// Dart Fundamentals in one meaningful CLI app: "Learning Secrets Vault".
//
// Run:
//   dart basic.dart --demo          -> non-interactive tour of Dart concepts
//   dart basic.dart                 -> interactive CLI vault
//   dart basic.dart --help          -> quick help
//
// Important production note:
// This is a teaching app. It saves data as JSON and uses a deliberately simple
// reversible text transform so beginners can study the code. For real secrets,
// use audited cryptography, key management, secure storage, logging discipline,
// tests, and threat modeling.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

// ---------------------------------------------------------------------------
// 1. Enums: a fixed set of named values. Enhanced enums can store extra data.
// ---------------------------------------------------------------------------

enum SecretCategory {
  password('Password'),
  apiKey('API Key'),
  note('Secure Note'),
  card('Card'),
  other('Other');

  const SecretCategory(this.label);

  final String label;

  @override
  String toString() => label;
}

enum VaultCommand {
  add,
  list,
  view,
  update,
  delete,
  search,
  stats,
  demo,
  help,
  exit,
  unknown,
}

// ---------------------------------------------------------------------------
// 2. Typedefs: aliases for function types make higher-order APIs readable.
// ---------------------------------------------------------------------------

typedef SecretPredicate = bool Function(Secret secret);
typedef SecretFormatter = String Function(Secret secret);

// ---------------------------------------------------------------------------
// 3. Exceptions: create domain-specific errors instead of throwing strings.
// ---------------------------------------------------------------------------

class VaultException implements Exception {
  VaultException(this.message);

  final String message;

  @override
  String toString() => 'VaultException: $message';
}

// ---------------------------------------------------------------------------
// 4. Extensions: add useful methods to existing types without subclassing.
// ---------------------------------------------------------------------------

extension StringLearningOps on String {
  bool get isBlank => trim().isEmpty;

  String mask({int visible = 2}) {
    if (length <= visible) return '*' * length;
    return '${substring(0, visible)}${'*' * (length - visible)}';
  }

  String titleCase() {
    if (isBlank) return this;
    return split(RegExp(r'\s+'))
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

extension IterableLearningOps<T> on Iterable<T> {
  String joinWithIndex() {
    var index = 0;
    return map((item) => '${index++}: $item').join(', ');
  }
}

// ---------------------------------------------------------------------------
// 5. Mixins, interfaces, inheritance, abstract classes, and polymorphism.
// ---------------------------------------------------------------------------

mixin Timestamped {
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  void touch() {
    updatedAt = DateTime.now();
  }
}

abstract class JsonSerializable {
  Map<String, Object?> toJson();
}

abstract class Identifiable {
  String get id;
}

class AuditEvent with Timestamped implements JsonSerializable {
  AuditEvent(this.action, this.detail);

  final String action;
  final String detail;

  @override
  Map<String, Object?> toJson() => {
    'action': action,
    'detail': detail,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  String toString() => '$action -> $detail';
}

class Secret with Timestamped implements JsonSerializable, Identifiable {
  Secret({
    required this.id,
    required this.title,
    required this.encryptedValue,
    required this.category,
    Set<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : tags = tags ?? <String>{} {
    if (createdAt != null) this.createdAt = createdAt;
    if (updatedAt != null) this.updatedAt = updatedAt;
  }

  // Named constructor: convenient sample object for demo code.
  Secret.sample()
    : id = 'sample-${DateTime.now().microsecondsSinceEpoch}',
      title = 'Demo Login',
      encryptedValue = 'not-real-encryption',
      category = SecretCategory.password,
      tags = {'demo', 'login'};

  // Factory constructor: build an object from JSON.
  factory Secret.fromJson(Map<String, Object?> json) {
    return Secret(
      id: json['id'] as String,
      title: json['title'] as String,
      encryptedValue: json['encryptedValue'] as String,
      category: parseCategory(json['category'] as String?),
      tags: ((json['tags'] as List<dynamic>?) ?? const [])
          .map((tag) => tag.toString())
          .toSet(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
    );
  }

  @override
  final String id;

  String title;
  String encryptedValue;
  SecretCategory category;
  final Set<String> tags;

  // Getter: computed property.
  bool get hasTags => tags.isNotEmpty;

  // Setter: validate before assignment.
  set safeTitle(String value) {
    if (value.isBlank) {
      throw VaultException('Secret title cannot be empty.');
    }
    title = value.trim();
    touch();
  }

  @override
  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'encryptedValue': encryptedValue,
    'category': category.name,
    'tags': tags.toList()..sort(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  Secret copyWith({
    String? title,
    String? encryptedValue,
    SecretCategory? category,
    Set<String>? tags,
  }) {
    return Secret(
      id: id,
      title: title ?? this.title,
      encryptedValue: encryptedValue ?? this.encryptedValue,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    final tagText = tags.isEmpty ? 'no tags' : tags.join(', ');
    return '$title [$category] ($tagText)';
  }
}

// Inheritance example: ApiCredential is a specialized Secret.
class ApiCredential extends Secret {
  ApiCredential({
    required super.id,
    required super.title,
    required super.encryptedValue,
    required this.provider,
    super.tags,
  }) : super(category: SecretCategory.apiKey);

  final String provider;

  @override
  String toString() => '${super.toString()} provider=$provider';
}

// Generic repository contract: works with any JSON serializable identifiable.
abstract class Repository<T extends JsonSerializable> {
  Future<List<T>> load();
  Future<void> save(List<T> items);
}

class SecretFileRepository implements Repository<Secret> {
  SecretFileRepository(this.file);

  final File file;

  @override
  Future<List<Secret>> load() async {
    if (!await file.exists()) return <Secret>[];

    try {
      final content = await file.readAsString();
      if (content.trim().isEmpty) return <Secret>[];

      final decoded = jsonDecode(content);
      if (decoded is! List) {
        throw VaultException('Vault file must contain a JSON list.');
      }

      return decoded
          .cast<Map<String, Object?>>()
          .map(Secret.fromJson)
          .toList(growable: true);
    } on FormatException catch (error) {
      throw VaultException('Vault JSON is invalid: ${error.message}');
    }
  }

  @override
  Future<void> save(List<Secret> items) async {
    final encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(
      encoder.convert(items.map((s) => s.toJson()).toList()),
    );
  }
}

class VaultService {
  VaultService(this.repository, this.codec);

  final Repository<Secret> repository;
  final ToySecretCodec codec;
  final List<AuditEvent> _auditLog = <AuditEvent>[];

  List<Secret> _secrets = <Secret>[];

  List<Secret> get secrets => List.unmodifiable(_secrets);
  List<AuditEvent> get auditLog => List.unmodifiable(_auditLog);

  Future<void> initialize() async {
    _secrets = await repository.load();
    _audit('init', 'Loaded ${_secrets.length} secrets.');
  }

  Future<Secret> addSecret({
    required String title,
    required String value,
    required SecretCategory category,
    Set<String>? tags,
  }) async {
    if (title.isBlank) throw VaultException('Title is required.');
    if (value.isBlank) throw VaultException('Secret value is required.');

    final secret = Secret(
      id: createId(),
      title: title.trim(),
      encryptedValue: codec.encode(value),
      category: category,
      tags: tags,
    );

    _secrets.add(secret);
    _sortSecrets();
    await _persist('add', 'Added "${secret.title}".');
    return secret;
  }

  Secret getById(String id) {
    return _secrets.firstWhere(
      (secret) => secret.id == id,
      orElse: () => throw VaultException('No secret found for id "$id".'),
    );
  }

  String reveal(String id) => codec.decode(getById(id).encryptedValue);

  Future<void> updateSecret({
    required String id,
    String? title,
    String? value,
    SecretCategory? category,
    Set<String>? tags,
  }) async {
    final index = _secrets.indexWhere((secret) => secret.id == id);
    if (index == -1) throw VaultException('No secret found for id "$id".');

    final current = _secrets[index];
    final updated = current.copyWith(
      title: title?.trim().isEmpty == true ? current.title : title?.trim(),
      encryptedValue: value == null || value.isBlank
          ? current.encryptedValue
          : codec.encode(value),
      category: category,
      tags: tags,
    );

    _secrets[index] = updated;
    _sortSecrets();
    await _persist('update', 'Updated "${updated.title}".');
  }

  Future<void> deleteSecret(String id) async {
    final before = _secrets.length;
    _secrets.removeWhere((secret) => secret.id == id);

    if (_secrets.length == before) {
      throw VaultException('No secret found for id "$id".');
    }

    await _persist('delete', 'Deleted secret id "$id".');
  }

  List<Secret> search(String query) {
    final normalized = query.toLowerCase().trim();
    if (normalized.isEmpty) return secrets;

    return _secrets.where((secret) {
      return secret.title.toLowerCase().contains(normalized) ||
          secret.category.label.toLowerCase().contains(normalized) ||
          secret.tags.any((tag) => tag.toLowerCase().contains(normalized));
    }).toList();
  }

  Map<SecretCategory, int> countByCategory() {
    final counts = <SecretCategory, int>{};
    for (final category in SecretCategory.values) {
      counts[category] = _secrets
          .where((secret) => secret.category == category)
          .length;
    }
    return counts;
  }

  Iterable<Secret> filter(SecretPredicate predicate) sync* {
    for (final secret in _secrets) {
      if (predicate(secret)) yield secret;
    }
  }

  void _sortSecrets() {
    _secrets.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );
  }

  Future<void> _persist(String action, String detail) async {
    await repository.save(_secrets);
    _audit(action, detail);
  }

  void _audit(String action, String detail) {
    _auditLog.add(AuditEvent(action, detail));
  }
}

class ToySecretCodec {
  ToySecretCodec(this.key);

  final String key;

  String encode(String plainText) {
    final shifted = plainText.runes
        .map((codePoint) => codePoint + key.length)
        .map(String.fromCharCode)
        .join();
    return base64Url.encode(utf8.encode(shifted));
  }

  String decode(String encodedText) {
    final shifted = utf8.decode(base64Url.decode(encodedText));
    return shifted.runes
        .map((codePoint) => codePoint - key.length)
        .map(String.fromCharCode)
        .join();
  }
}

// ---------------------------------------------------------------------------
// 6. Small classes that group string/list/map/set operations for learning.
// ---------------------------------------------------------------------------

class StringWorkshop {
  StringWorkshop(this.value);

  final String value;

  void run() {
    section('String operations');

    final words = value.split(' ');
    final csv = 'dart,cli,json,files';

    print('Original: "$value"');
    print('Length: ${value.length}');
    print('Upper/lower: ${value.toUpperCase()} / ${value.toLowerCase()}');
    print('Trim: "${'  secret vault  '.trim()}"');
    print('Contains "vault": ${value.contains('vault')}');
    print(
      'Starts/ends: ${value.startsWith('Dart')} / ${value.endsWith('app')}',
    );
    print('Index of "vault": ${value.indexOf('vault')}');
    print('Substring 0..4: ${value.substring(0, 4)}');
    print('Replace: ${value.replaceAll('vault', 'safe')}');
    print('Split words: $words');
    print('Join words with hyphen: ${words.join('-')}');
    print(
      'CSV split and title case: ${csv.split(',').map((s) => s.titleCase()).join(' | ')}',
    );
    print('Interpolation: The phrase has ${words.length} words.');
    print('Raw string keeps slash n: ${r'first\nsecond'}');
    print(
      'Multiline string:\n${'''Line one
Line two'''}',
    );
  }
}

class CollectionWorkshop {
  void run() {
    section('List, Set, and Map operations');

    final secrets = <String>['gmail', 'github', 'bank'];
    secrets.add('server');
    secrets.addAll(['wifi', 'database']);
    secrets.insert(1, 'email');
    secrets.remove('bank');
    final removedLast = secrets.removeLast();

    print('List after add/insert/remove: $secrets');
    print('Removed last item: $removedLast');
    print(
      'Length/isEmpty/first/last: ${secrets.length}, ${secrets.isEmpty}, ${secrets.first}, ${secrets.last}',
    );
    print('Search contains github: ${secrets.contains('github')}');
    print('Index of server: ${secrets.indexOf('server')}');
    print('Sublist 1..3: ${secrets.sublist(1, 3)}');
    print(
      'Map to uppercase: ${secrets.map((name) => name.toUpperCase()).toList()}',
    );
    print(
      'Where length > 5: ${secrets.where((name) => name.length > 5).toList()}',
    );
    print('Any starts with g: ${secrets.any((name) => name.startsWith('g'))}');
    print('Every is not blank: ${secrets.every((name) => name.isNotEmpty)}');
    print(
      'Fold total characters: ${secrets.fold<int>(0, (total, item) => total + item.length)}',
    );
    print(
      'Spread + collection-if/for: ${['root', ...secrets, if (secrets.length > 2) 'many-items', for (final item in secrets) 'copy-$item']}',
    );

    final tags = ['personal', 'work', 'work', 'urgent'].toSet();
    tags.add('finance');
    tags.remove('urgent');
    print('Set removes duplicates: $tags');
    print('Set union: ${tags.union({'archive', 'work'})}');
    print('Set intersection: ${tags.intersection({'work', 'x'})}');
    print('Set difference: ${tags.difference({'personal'})}');

    final counts = <String, int>{'password': 2, 'apiKey': 1};
    counts['note'] = 3;
    counts.update('password', (value) => value + 1);
    counts.remove('apiKey');
    print('Map keys: ${counts.keys.toList()}');
    print('Map values: ${counts.values.toList()}');
    print('Map contains key note: ${counts.containsKey('note')}');
    print(
      'Map entries: ${counts.entries.map((entry) => '${entry.key}=${entry.value}').join(', ')}',
    );
  }
}

// ---------------------------------------------------------------------------
// 7. CLI controller: input/output, conditionals, switch, loops, async/await.
// ---------------------------------------------------------------------------

class VaultCli {
  VaultCli(this.service);

  final VaultService service;

  Future<void> start() async {
    printBanner();
    printHelp();

    // while loop: repeats until the user exits.
    var running = true;
    while (running) {
      final input = prompt('\ncommand').toLowerCase();
      final command = parseCommand(input);

      try {
        // switch statement with enum values.
        switch (command) {
          case VaultCommand.add:
            await _addFlow();
          case VaultCommand.list:
            _list(service.secrets);
          case VaultCommand.view:
            _viewFlow();
          case VaultCommand.update:
            await _updateFlow();
          case VaultCommand.delete:
            await _deleteFlow();
          case VaultCommand.search:
            _searchFlow();
          case VaultCommand.stats:
            _stats();
          case VaultCommand.demo:
            await runLearningTour(service);
          case VaultCommand.help:
            printHelp();
          case VaultCommand.exit:
            running = false;
          case VaultCommand.unknown:
            print('Unknown command. Type "help" to see choices.');
        }
      } on VaultException catch (error) {
        stderr.writeln(error.message);
      } catch (error, stackTrace) {
        stderr.writeln('Unexpected error: $error');
        stderr.writeln(
          'Top stack frame: ${stackTrace.toString().split('\n').first}',
        );
      } finally {
        // finally always runs after try/catch.
      }
    }

    print('Goodbye. Your learning vault is saved.');
  }

  Future<void> _addFlow() async {
    final title = prompt('title');
    final value = prompt('secret value');
    final category = promptCategory();
    final tags = parseTags(prompt('tags comma separated'));

    final secret = await service.addSecret(
      title: title,
      value: value,
      category: category,
      tags: tags,
    );

    print('Added ${formatSecretRow(secret)}');
  }

  void _list(List<Secret> secrets) {
    if (secrets.isEmpty) {
      print('No secrets yet. Add one with "add".');
      return;
    }

    // for loop with index.
    for (var i = 0; i < secrets.length; i++) {
      print('${i + 1}. ${formatSecretRow(secrets[i])}');
    }
  }

  void _viewFlow() {
    final id = prompt('id');
    final secret = service.getById(id);
    print(formatSecretDetails(secret, service.reveal(id)));
  }

  Future<void> _updateFlow() async {
    final id = prompt('id to update');
    final current = service.getById(id);

    print('Press enter to keep the current value.');
    final title = prompt('new title (${current.title})');
    final value = prompt('new secret value (${service.reveal(id).mask()})');
    final categoryInput = prompt('new category ${categoryMenu()}');
    final tagsInput = prompt(
      'new tags comma separated (${current.tags.join(', ')})',
    );

    await service.updateSecret(
      id: id,
      title: title.isBlank ? null : title,
      value: value.isBlank ? null : value,
      category: categoryInput.isBlank ? null : parseCategory(categoryInput),
      tags: tagsInput.isBlank ? null : parseTags(tagsInput),
    );

    print('Updated.');
  }

  Future<void> _deleteFlow() async {
    final id = prompt('id to delete');
    final confirm = prompt('type DELETE to confirm');
    if (confirm == 'DELETE') {
      await service.deleteSecret(id);
      print('Deleted.');
    } else {
      print('Cancelled.');
    }
  }

  void _searchFlow() {
    final query = prompt('search query');
    _list(service.search(query));
  }

  void _stats() {
    final counts = service.countByCategory();
    print('Total secrets: ${service.secrets.length}');

    // for-in loop over map entries.
    for (final entry in counts.entries) {
      print('${entry.key.label}: ${entry.value}');
    }

    print('Audit events: ${service.auditLog.length}');
  }
}

// ---------------------------------------------------------------------------
// 8. Functions: required/named/optional params, arrow funcs, recursion,
// closures, anonymous funcs, generators, async functions, records, patterns.
// ---------------------------------------------------------------------------

void printBanner() {
  print('''
============================================================
 Dart Learning Secrets Vault
 A single-file CLI app for studying Dart fundamentals.
============================================================''');
}

void printHelp() {
  print('''
Commands:
  add      Add a new secret
  list     List saved secrets
  view     Reveal one secret by id
  update   Update one secret
  delete   Delete one secret
  search   Search title/category/tags
  stats    Show category counts
  demo     Run the learning tour
  help     Show this help
  exit     Quit
''');
}

String prompt(String label) {
  stdout.write('$label > ');
  return stdin.readLineSync()?.trim() ?? '';
}

VaultCommand parseCommand(String input) {
  return switch (input) {
    'add' || 'a' => VaultCommand.add,
    'list' || 'ls' => VaultCommand.list,
    'view' || 'v' => VaultCommand.view,
    'update' || 'u' => VaultCommand.update,
    'delete' || 'del' || 'd' => VaultCommand.delete,
    'search' || 's' => VaultCommand.search,
    'stats' => VaultCommand.stats,
    'demo' => VaultCommand.demo,
    'help' || 'h' => VaultCommand.help,
    'exit' || 'quit' || 'q' => VaultCommand.exit,
    _ => VaultCommand.unknown,
  };
}

SecretCategory parseCategory(String? input) {
  final normalized = (input ?? '').trim().toLowerCase();

  for (final category in SecretCategory.values) {
    if (category.name.toLowerCase() == normalized ||
        category.label.toLowerCase() == normalized) {
      return category;
    }
  }

  return SecretCategory.other;
}

SecretCategory promptCategory() {
  final input = prompt('category ${categoryMenu()}');
  return parseCategory(input);
}

String categoryMenu() {
  return SecretCategory.values.map((c) => c.name).join('/');
}

Set<String> parseTags(String input) {
  return input
      .split(',')
      .map((tag) => tag.trim().toLowerCase())
      .where((tag) => tag.isNotEmpty)
      .toSet();
}

String createId() {
  final random = Random().nextInt(999999).toString().padLeft(6, '0');
  return '${DateTime.now().microsecondsSinceEpoch}-$random';
}

String formatSecretRow(Secret secret) {
  final tags = secret.tags.isEmpty ? '-' : secret.tags.join(', ');
  return '${secret.id} | ${secret.title} | ${secret.category.label} | tags: $tags';
}

String formatSecretDetails(Secret secret, String revealedValue) {
  return '''
Id: ${secret.id}
Title: ${secret.title}
Category: ${secret.category.label}
Tags: ${secret.tags.isEmpty ? '-' : secret.tags.join(', ')}
Secret: $revealedValue
Created: ${secret.createdAt}
Updated: ${secret.updatedAt}
''';
}

void section(String title) {
  print('\n--- $title ---');
}

// Optional positional parameter and default value.
int addNumbers(int a, int b, [int c = 0]) => a + b + c;

// Named parameters, required parameters, nullable parameter, and default value.
String greetUser({required String name, String? role, bool excited = false}) {
  final roleText = role == null ? '' : ' the $role';
  final punctuation = excited ? '!' : '.';
  return 'Hello, $name$roleText$punctuation';
}

// Recursion: a function calling itself.
int factorial(int n) {
  if (n < 0) throw ArgumentError('n must be >= 0');
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

// Closure: a function that remembers variables from its surrounding scope.
String Function(String) makePrefixer(String prefix) {
  return (message) => '$prefix$message';
}

// sync* generator returns values lazily.
Iterable<int> countdown(int from) sync* {
  for (var i = from; i >= 0; i--) {
    yield i;
  }
}

// async* generator returns a stream over time.
Stream<String> auditTicker(List<AuditEvent> events) async* {
  for (final event in events) {
    await Future<void>.delayed(Duration(milliseconds: 10));
    yield event.toString();
  }
}

// Records: lightweight grouped values without defining a class.
({int total, Set<String> uniqueTags}) summarizeSecrets(List<Secret> secrets) {
  final tags = <String>{};
  for (final secret in secrets) {
    tags.addAll(secret.tags);
  }
  return (total: secrets.length, uniqueTags: tags);
}

Future<void> runLearningTour(VaultService service) async {
  section('Variables and data types');

  // var infers the type. final is assigned once at runtime. const is compile-time.
  var appName = 'Learning Secrets Vault';
  final startedAt = DateTime.now();
  const version = 1;

  int count = service.secrets.length;
  double score = 98.5;
  num flexibleNumber = count;
  bool isEmpty = service.secrets.isEmpty;
  String language = 'Dart';
  dynamic dynamicValue = 'Can change type';
  dynamicValue = 42;
  Object objectValue = 'Can hold any non-null object, but needs type checks';
  String? nullableName;
  late String initializedLater;
  initializedLater = 'Now initialized';

  print('var/final/const: $appName, $startedAt, v$version');
  print(
    'int/double/num/bool/String: $count, $score, $flexibleNumber, $isEmpty, $language',
  );
  print(
    'dynamic/Object/null safety/late: $dynamicValue, $objectValue, $nullableName, $initializedLater',
  );

  section('Operators, logical operations, and conditions');
  final hasSecrets = count > 0;
  final strongScore = score >= 80;
  print('AND: ${hasSecrets && strongScore}');
  print('OR: ${hasSecrets || strongScore}');
  print('NOT: ${!isEmpty}');
  print('Ternary: ${hasSecrets ? 'vault has data' : 'vault is empty'}');
  print('Null coalescing: ${nullableName ?? 'Guest'}');
  nullableName ??= 'Assigned because it was null';
  print('After ??=: $nullableName');

  if (count == 0) {
    print('if/else: no secrets are saved yet.');
  } else if (count == 1) {
    print('if/else-if: exactly one secret exists.');
  } else {
    print('if/else: multiple secrets exist.');
  }

  final risk = switch (count) {
    0 => 'none',
    >= 1 && <= 3 => 'small',
    _ => 'large',
  };
  print('Switch expression with relational pattern: $risk');

  section('Loops');
  print('for loop:');
  for (var i = 0; i < 3; i++) {
    print('  i=$i');
  }

  print('for-in loop:');
  for (final category in SecretCategory.values) {
    print('  ${category.name}');
  }

  print('while loop:');
  var whileCount = 0;
  while (whileCount < 2) {
    print('  whileCount=$whileCount');
    whileCount++;
  }

  print('do-while loop:');
  var doCount = 0;
  do {
    print('  doCount=$doCount');
    doCount++;
  } while (doCount < 2);

  print('forEach with anonymous function:');
  SecretCategory.values.forEach((category) => print('  ${category.label}'));

  print('break/continue:');
  for (var i = 0; i < 5; i++) {
    if (i == 1) continue;
    if (i == 4) break;
    print('  kept $i');
  }

  section('Functions');
  print('Arrow function addNumbers: ${addNumbers(1, 2, 3)}');
  print(greetUser(name: 'Beginner', role: 'Dart learner', excited: true));
  print('Recursion factorial(5): ${factorial(5)}');
  final warn = makePrefixer('WARNING: ');
  print('Closure: ${warn('keep real secrets out of demo apps')}');
  print('Generator countdown: ${countdown(3).join(', ')}');

  final formatter = (Secret secret) =>
      '${secret.title} -> ${secret.category.label}';
  print(
    'Higher-order filter + formatter: ${service.filter((s) => true).map(formatter).join(' | ')}',
  );

  section('Strings');
  StringWorkshop('Dart vault app').run();

  section('Collections');
  CollectionWorkshop().run();

  section('OOP and polymorphism');
  final objects = <Object>[
    Secret.sample(),
    ApiCredential(
      id: createId(),
      title: 'Maps API',
      encryptedValue: service.codec.encode('demo-api-key'),
      provider: 'ExampleCloud',
      tags: {'api', 'cloud'},
    ),
  ];

  for (final object in objects) {
    print('Runtime type: ${object.runtimeType}; value: $object');
  }

  section('JSON');
  final sample = Secret.sample();
  final jsonText = JsonEncoder.withIndent('  ').convert(sample.toJson());
  print('Encoded JSON:\n$jsonText');
  final decodedSecret = Secret.fromJson(
    jsonDecode(jsonText) as Map<String, Object?>,
  );
  print('Decoded object: $decodedSecret');

  section('Files');
  final demoFile = File('dart_learning_demo.txt');
  await demoFile.writeAsString('Dart file write at ${DateTime.now()}\n');
  await demoFile.writeAsString('Second line\n', mode: FileMode.append);
  print('File exists: ${await demoFile.exists()}');
  print('File contents: ${(await demoFile.readAsString()).trim()}');
  await demoFile.delete();
  print('File deleted: ${!await demoFile.exists()}');

  section('Async, Future, Stream, await-for');
  final delayedMessage = await Future<String>.delayed(
    Duration(milliseconds: 20),
    () => 'Future completed',
  );
  print(delayedMessage);

  await for (final eventText in auditTicker(
    service.auditLog.take(3).toList(),
  )) {
    print('Stream event: $eventText');
  }

  section('Records and destructuring patterns');
  final summary = summarizeSecrets(service.secrets);
  print('Record fields: total=${summary.total}, tags=${summary.uniqueTags}');
  final (:total, :uniqueTags) = summary;
  print('Destructured record: total=$total, tagCount=${uniqueTags.length}');

  section('Error handling');
  try {
    service.getById('missing-id');
  } on VaultException catch (error) {
    print('Caught expected custom exception: ${error.message}');
  } finally {
    print('finally block ran.');
  }
}

Future<void> seedDemoDataIfEmpty(VaultService service) async {
  if (service.secrets.isNotEmpty) return;

  await service.addSecret(
    title: 'Gmail',
    value: 'gmail-password-123',
    category: SecretCategory.password,
    tags: {'email', 'personal'},
  );
  await service.addSecret(
    title: 'GitHub Token',
    value: 'ghp_demo_token',
    category: SecretCategory.apiKey,
    tags: {'code', 'work'},
  );
  await service.addSecret(
    title: 'Recovery Note',
    value: 'Store real recovery codes offline.',
    category: SecretCategory.note,
    tags: {'backup'},
  );
}

Future<void> main(List<String> arguments) async {
  final vaultFile = File('.learning_secret_vault.json');
  final repository = SecretFileRepository(vaultFile);
  final service = VaultService(repository, ToySecretCodec('learning-key'));

  try {
    await service.initialize();

    if (arguments.contains('--help') || arguments.contains('-h')) {
      printBanner();
      printHelp();
      print('Demo file path: ${vaultFile.absolute.path}');
      return;
    }

    if (arguments.contains('--demo')) {
      await seedDemoDataIfEmpty(service);
      await runLearningTour(service);
      print('\nDemo complete. Vault JSON file: ${vaultFile.absolute.path}');
      return;
    }

    await VaultCli(service).start();
  } on VaultException catch (error) {
    stderr.writeln(error.message);
    exitCode = 1;
  } on IOException catch (error) {
    stderr.writeln('File operation failed: $error');
    exitCode = 1;
  } catch (error, stackTrace) {
    stderr.writeln('Unexpected fatal error: $error');
    stderr.writeln(stackTrace);
    exitCode = 1;
  }
}
