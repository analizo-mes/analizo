from mammal import Mammal

class Dog(Mammal):
    dog_name = ""

    def __init__(self, name):
        self.dog_name = name

    def name(self):
        return self.dog_name
