Feature: number of methods
  As a software developer
  I want analizo to report the number of methods of each module
  So that I can evaluate it

  Scenario: number of methods of the polygon java sample
    Given I am in t/samples/<sample>/<language>
    When I run "analizo metrics ."
    Then analizo must report that module <module> has nom = <nom>
    Examples:
      | sample   | language |  module    | nom  |
      | polygons | cpp      |  CPolygon  | 3    |
      | polygons | cpp      |  CTetragon | 2    |
      | polygons | java     |  Polygon   | 3    |
      | polygons | cs       |  Polygon   | 2    |
      | polygons | cs       |  Tetragon  | 2    |
      | animals  | cpp      |  Animal    | 1    |
      | animals  | cpp      |  Cat       | 2    |
      | animals  | cpp      |  Dog       | 2    |
      | animals  | java     |  Animal    | 1    |
      | animals  | java     |  Cat       | 2    |
      | animals  | java     |  Dog       | 2    |
      | animals  | cs       |  Animal    | 1    |
      | animals  | cs       |  Cat       | 3    |
      | animals  | cs       |  Dog       | 3    |
