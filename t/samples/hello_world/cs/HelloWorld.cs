using System;

class HelloWorld {
	private static int _id_seq = 0;
  	private int _id;
  	public static int hello = 1;

  	public HelloWorld() {
    	this._id = (_id_seq++);
  	}

  	public void say() {
    	Console.WriteLine("Hello, world! My is id {0}",  _id);
  	}

  	public void destroy() {
    	Console.WriteLine("Goodbye, world! My id is {0}", _id);
  	}

  	private void private_method() {
     	hello = 2;
     	Console.WriteLine(hello);
  	}
}