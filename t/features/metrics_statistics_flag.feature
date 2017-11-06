Feature: Analizo statistics metrics flag

	Scenario: Run analizo with --mean flag
		When I run "analizo metrics --mean t/samples/animals/java"
		Then the output must match "_mean:"
		Then the output must not match "_mode:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_sum:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_skewness:"

	Scenario: Run analizo with --mode flag
		When I run "analizo metrics --mode t/samples/animals/java"
		Then the output must match "_mode:"
		Then the output must not match "_meam:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_sum:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_skewness:"
		
	Scenario: Run analizo with --standard flag
		When I run "analizo metrics --standard t/samples/animals/java"
		Then the output must match "_standard_deviation:"
		Then the output must not match "_mode:"
	    Then the output must not match "_mean:"
	    Then the output must not match "_sum:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_skewness:"

	Scenario: Run analizo with --sum flag
		When I run "analizo metrics --sum t/samples/animals/java"
		Then the output must match "_sum:"
		Then the output must not match "_mode:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_mean:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_skewness:"

	Scenario: Run analizo with --variance flag
		When I run "analizo metrics --variance t/samples/animals/java"
		Then the output must match "_variance:"
		Then the output must not match "_mode:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_sum:"
	    Then the output must not match "_mean:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_skewness:"

	Scenario: Run analizo with --min flag
		When I run "analizo metrics --min t/samples/animals/java"
		Then the output must match "_quantile_min:"
		Then the output must not match "_mode:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_sum:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_mean:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_skewness:"

	Scenario: Run analizo with --lower flag
		When I run "analizo metrics --lower t/samples/animals/java"
		Then the output must match "_quantile_lower:"
		Then the output must not match "_meam:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_sum:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_mode:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_skewness:"
		
	Scenario: Run analizo with --median flag
		When I run "analizo metrics --median t/samples/animals/java"
		Then the output must match "_quantile_median:"
		Then the output must not match "_mode:"
	    Then the output must not match "_mean:"
	    Then the output must not match "_sum:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_skewness:"

	Scenario: Run analizo with --upper flag
		When I run "analizo metrics --upper t/samples/animals/java"
		Then the output must match "_quantile_upper:"
		Then the output must not match "_mode:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_mean:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_sum:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_skewness:"

	Scenario: Run analizo with --ninety flag
		When I run "analizo metrics --ninety t/samples/animals/java"
		Then the output must match "_quantile_ninety:"
		Then the output must not match "_mode:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_sum:"
	    Then the output must not match "_mean:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_skewness:"

	Scenario: Run analizo with --ninety_five flag
		When I run "analizo metrics --ninety_five t/samples/animals/java"
		Then the output must match "_quantile_ninety_five:"
		Then the output must not match "_mode:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_sum:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_mean:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_skewness:"

	Scenario: Run analizo with --max flag
		When I run "analizo metrics --max t/samples/animals/java"
		Then the output must match "_quantile_max:"
		Then the output must not match "_meam:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_sum:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_mode:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_skewness:"
		
	Scenario: Run analizo with --kurtosis flag
		When I run "analizo metrics --kurtosis t/samples/animals/java"
		Then the output must match "_kurtosis:"
		Then the output must not match "_mode:"
	    Then the output must not match "_mean:"
	    Then the output must not match "_sum:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_skewness:"

	Scenario: Run analizo with --skewness flag
		When I run "analizo metrics --skewness t/samples/animals/java"
		Then the output must match "_skewness:"
		Then the output must not match "_mode:"
	    Then the output must not match "_standard_deviation:"
	    Then the output must not match "_mean:"
	    Then the output must not match "_variance:"
	    Then the output must not match "_quantile_min:"
	    Then the output must not match "_quantile_lower:"
	    Then the output must not match "_quantile_median:"
	    Then the output must not match "_quantile_upper:"
	    Then the output must not match "_quantile_ninety:"
	    Then the output must not match "_quantile_ninety_five:"
	    Then the output must not match "_quantile_max:"
	    Then the output must not match "_kurtosis:"
	    Then the output must not match "_sum:"