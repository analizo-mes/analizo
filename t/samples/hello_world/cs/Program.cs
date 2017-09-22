using System;

class Program {
	static void Main() {
		HelloWorld hello1 = new HelloWorld();
		HelloWorld hello2 = new HelloWorld();

		hello1.say();
	  hello2.say();
	  hello1.destroy();
	  hello2.destroy();
	}
}