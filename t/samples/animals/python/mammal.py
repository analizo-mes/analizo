from animal import Animal
from abc import ABCMeta, abstractmethod

class Mammal(Animal):
    __metaclass__ = ABCMeta

    @abstractmethod
    def name(self):
        pass
