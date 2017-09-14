using System;

public class Program {
  static void Main(string[] args) {
    Animal dog = new Dog("Odie");
    Mammal cat = new Cat("Garfield");
    Console.WriteLine(dog.name());
    Console.WriteLine(cat.name());
  }

}
