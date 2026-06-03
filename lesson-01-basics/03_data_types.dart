/* 
 * Dart Data Types Overview
 * To run this program, `dart run 03_data_types.dart` in the terminal
 */

void main(List<String> args) {
  // Integer data type which holds a range of -2^63 to 2^63-1
  int wholeNumber = 42;

  // Double data type for floating-point numbers, which can store decimal values from -1.7976931348623157e+308 to 1.7976931348623157e+308
  double bigNumber = 12345.6789;

  // num is a supertype of both int and double, allowing it to hold either type of number with a range of -1.7976931348623157e+308 to 1.7976931348623157e+308
  num anyNumber = 3.14;

  // String data type for storing text values
  String name = '''This is a multi-line string
that can span multiple lines
without needing escape characters.''';

  // Boolean data type for true/false values
  bool isActive = true;

  // Dynamic data type that can hold any type of value and can change type at runtime
  dynamic flexibleValue = 'I can be anything';

  // Object is the base class for all Dart objects, allowing it to hold any type of value but with less flexibility than dynamic
  Object genericObject = 'I am an object';

  print('Integer: $wholeNumber. Byte Size: 8 bytes');
  print('Double: $bigNumber. Byte Size: 8 bytes');
  print('Num: $anyNumber. Byte Size: 8 bytes');
  print('String: $name. Byte Size: Variable');
  print('Boolean: $isActive. Byte Size: 1 byte');
  print('Dynamic: $flexibleValue. Byte Size: Variable');
  print('Object: $genericObject. Byte Size: Variable');
}
