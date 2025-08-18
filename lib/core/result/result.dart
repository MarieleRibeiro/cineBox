sealed class Result<T> {
  // classe pai de todo mundo
  // classe celada que pode retornar qualquer coisa por isso o <T> generica
}

class Unit {} // ausencia de valor, similar ao void em outras linguagens

class Success<T> extends Result<T> {
  final T value;

  Success(this.value);
}

class Failure<T> extends Result<T> {
  final Exception error;
  final Object? value;

  Failure(this.error, [this.value]);
}

Result<Unit> successOfUnit() => Success(Unit());
