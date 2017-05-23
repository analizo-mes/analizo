class Polygon:
  def __init__(self, width, height):
      self.width = width
      self.height = height

  def perimeter(self):
    raise

  def area(self):
    raise

class Tetragon(Polygon):
  def perimeter(self):
    raise

  def area(self):
    raise

class Square(Tetragon):
  def perimeter(self):
    return (self.width*4)

  def area(self):
    return (self.width*self.width)

class Rectangle(Tetragon):
  def perimeter(self):
    return (self.width*2 + self.height*2)

  def area(self):
    return self.width*self.height

class Triangle(Polygon): 
  def perimeter(self):
    return (self.width*3)

  def area(self):
    return (self.width*self.height / 2)

if __name__ == "__main__":
  ppoly1 = Rectangle(4,5);
  ppoly2 = Triangle(4,5);
  print ppoly1.area()
  print ppoly2.area() 

