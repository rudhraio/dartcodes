/* 
 * Variable Declarations in Dart
 * To run this program, `dart run 02_variables.dart` in the terminal
 */

void main(List<String> args) {
  var appName =
      'CLI App'; // Using var for type inference meaning the type is determined by the assigned value
  const num VERSION =
      1.0; // Using const for compile-time constant values, which cannot be changed after compilation
  final currentTime =
      DateTime.now(); // Using final for runtime constants, which can be assigned once and cannot be changed afterwards

  String output =
      'App Name: $appName'
      '\nVersion: $VERSION'
      '\nCurrent Time: $currentTime';

  print(output);
}
