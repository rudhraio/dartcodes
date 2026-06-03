void main(List<String> args) {
  // Interpolation
  String program = 'Dart';
  'Hello, $program!'; // Simple variable
  '2 + 2 = ${2 + 2}'; // Expression inside ${}

  // Multiline
  String multilineString = '''
Line one
Line two
''';

  // Raw strings — backslashes treated literally
  String rawString = r'No \n escape here';

  // Adjacent string literals are auto-concatenated
  String adjacentString =
      'Hello, '
      'Programmer'; // 'Hello World'

  print('multilineString: $multilineString');
  print('rawString: $rawString');
  print('adjacentString: $adjacentString');

  String stringOperations = '  Dart Programming  ';

  print('stringOperations: $stringOperations');
  print(
    'stringOperations.length: ${stringOperations.length}',
  ); // character count
  print(
    'stringOperations.trim: ${stringOperations.trim()}',
  ); // 'Dart Programming'
  print(
    'stringOperations.trimLeft: ${stringOperations.trimLeft()}',
  ); // 'Dart Programming  '
  print(
    'stringOperations.trimRight: ${stringOperations.trimRight()}',
  ); // '  Dart Programming'
  print(
    'stringOperations.toUpperCase: ${stringOperations.toUpperCase()}',
  ); // '  DART PROGRAMMING  '
  print(
    'stringOperations.toLowerCase: ${stringOperations.toLowerCase()}',
  ); // '  dart programming  '
  print(
    'stringOperations.contains: ${stringOperations.contains('Dart')}',
  ); // true
  print(
    'stringOperations.startsWith: ${stringOperations.startsWith('  ')}',
  ); // true
  print(
    'stringOperations.endsWith: ${stringOperations.endsWith('ing  ')}',
  ); // true
  print('stringOperations.indexOf: ${stringOperations.indexOf('P')}'); // 7
  print(
    'stringOperations.lastIndexOf: ${stringOperations.lastIndexOf('i')}',
  ); // 15
  print(
    'stringOperations.substring: ${stringOperations.substring(2, 6)}',
  ); // 'Dart'
  print(
    'stringOperations.replaceAll: ${stringOperations.replaceAll(' ', '_')}',
  ); // '__Dart_Programming__'
  print(
    'stringOperations.replaceFirst: ${stringOperations.replaceFirst('Dart', 'Go')}',
  ); // '  Go Programming  '
  print(
    'stringOperations.trim().split: ${stringOperations.trim().split(' ')}',
  ); // ['Dart', 'Programming']
  print('stringOperations.isEmpty: ${stringOperations.isEmpty}'); // false
  print('<string>.isEmpty ${''.isEmpty}'); // true
  print('stringOperations.isNotEmpty: ${stringOperations.isNotEmpty}'); // true

  // Checking content
  print(
    '"123".contains(RegExp(<expression>)): ${'123'.contains(RegExp(r'^\d+$'))}',
  ); // true

  // Padding
  print('"5".padLeft(3, "0"): ${"5".padLeft(3, "0")}'); // '005'
  print('"hi".padRight(5, "-"): ${"hi".padRight(5, "-")}'); // 'hi---'
}
