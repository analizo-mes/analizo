Feature: mapping modules to filenames
  As a software engineering resesearcher
  I want to know in which file each module is declared
  So that I can compare that with data from the VCS

  Scenario: C++, runing against some directory
    When I run "analizo metrics -a t/samples/animals/cpp"
    Then analizo must report that module Animal has _filename = [animal.h]
    And analizo must report that module Cat has _filename = [cat.h,cat.cc]

  Scenario: C++, running against current directory
    Given I am in t/samples/animals/cpp
    When I run "analizo metrics -a ."
    Then analizo must report that module Animal has _filename = [animal.h]
    And analizo must report that module Cat has _filename = [cat.h,cat.cc]

  Scenario: Java
    When I run "analizo metrics -a t/samples/animals/java"
    Then analizo must report that module Animal has _filename = [Animal.java]

  Scenario: C
    Given I am in t/samples/hello_world/c
    When I run "analizo metrics -a ."
    Then analizo must report that module hello_world has _filename = [hello_world.c,hello_world.h]
    And analizo must report that file hello_world.c declares module hello_world
    And analizo must report that file hello_world.h declares module hello_world

  Scenario: CSharp hello_world
    Given I am in t/samples/hello_world/csharp
    When I run "analizo metrics ."
    Then analizo must report that module HelloWorld has _filename = [HelloWorld.cs]

  Scenario: CSharp polygons
    Given I am in t/samples/polygons/csharp
    When I run "analizo metrics ."
    Then analizo must report that file Polygon.cs declares module Polygon
    And analizo must report that file Rect.cs declares module Rect
    And analizo must report that file Triangle.cs declares module Triangle
