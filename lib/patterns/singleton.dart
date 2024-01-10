class Singleton {
  static Singleton? _instance;
  Singleton._();

  factory Singleton() => _instance ??= Singleton._();
}