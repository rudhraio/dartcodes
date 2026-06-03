/* 
 * Dart Arithmatic Operators
 * To run this program, `dart run 04_arithmatic_operators.dart` in the terminal
 */

void main(List<String> args) {
  int a = 10, b = 5;

  // Addition
  int sum = a + b;
  print('Addition: $a + $b = $sum');

  // Subtraction
  int difference = a - b;
  print('Subtraction: $a - $b = $difference');

  // Multiplication
  int product = a * b;
  print('Multiplication: $a * $b = $product');

  // Division
  double quotient = a / b;
  print('Division: $a / $b = $quotient');

  // Integer Division
  int intQuotient = a ~/ b;
  print('Integer Division: $a ~/ $b = $intQuotient');

  // Modulo
  int remainder = a % b;
  print('Modulo: $a % $b = $remainder');

  // In Line Assigment & Compound Assignment
  print('a += b: ${a += b}'); // a = a + b
  print('a -= b: ${a -= b}'); // a = a - b
  print('a *= b: ${a *= b}'); // a = a * b
  print('a ~/= b: ${a ~/= b}'); // a = a ~/ b
}
