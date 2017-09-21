using System;
using Hello;

class Program {
	static void Main() {
		HelloWorld msg = new HelloWorld();
		if(msg.Message() != "Hello, world") {
			Console.WriteLine("Test Failed");
		}
	}

}