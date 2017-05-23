from mammal import Mammal

class Cat(Mammal):
    cat_name = ""

    def __init__(self, name):
        self.cat_name = name

    def name(self):
        return self.cat_name
