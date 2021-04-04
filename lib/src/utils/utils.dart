// Esta función es para validar si lo que estoy recibiendo es un numero
bool isANumber(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);
  return (n == null) ? false : true;
}
