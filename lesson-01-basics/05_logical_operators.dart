/*
*  Logical Operators are used to check the conditions.
*  To run this program, run the following command.
*  `dart run 05_logical_operators.dart`
*/
void main(List<String> args) {
  int a = 10, b = 5;
  print('a = $a, b = $b');

  // checks both values are equal
  print('a == b ${a == b}');
  // checks both values are not equal
  print('a != b ${a != b}');
  // checks a is greater than b
  print('a > b ${a > b}');
  // checks a is less than b
  print('a < b ${a < b}');
  // checks a is greater than or equal to b
  print('a >= b ${a >= b}');
  // checks a is less than or equal to b
  print('a <= b ${a <= b}');

  bool x = true, y = false;
  // checks both values are true
  print('x && y : ${x && y}');
  // checks at least one value is true
  print('x || y : ${x || y}');
  // checks the value is not true
  print('!x : ${!x}');

  // `is` operator is used to check the type of the value
  Object anything = 'hello';
  print('anything is String: ${anything is String}');
  print('anything is int: ${anything is int}');
  print('anything is! String: ${anything is! String}');

  // Safe cast
  // `as` operator is used to cast the value to a specific type if the value is of that type
  String somestring = anything as String;
  print('somestring.runtimeType: ${somestring.runtimeType}');
}
