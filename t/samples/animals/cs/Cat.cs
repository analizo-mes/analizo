public class Cat:Mammal {
  
  private string _name;
  public Cat(string name) {
    _name = name;
  }

  public override void close() {
    System.Console.ReadLine();
  }

  public override string name() {
    return _name;
  }

}
