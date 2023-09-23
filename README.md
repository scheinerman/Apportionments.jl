# Apportionments
Congressional Apportionment Methods

## Overview

Seats in the United States House of Representatives are [allocated based on the populations
of the states](https://en.wikipedia.org/wiki/United_States_congressional_apportionment). 
Specifically, the inputs to an apportionment procedure are the populations
of the states (as determined by the decennial census) and the number of seats in the House. 

To a first approximation, the number of seats awarded to a state is the number of seats in 
the House times the fraction of the total population in that state. 

For example, in the 2020 US Census the population of Maryland is 6,185,278 and the 
total population of the fifty states is 331,108,434. 
Hence Maryland has 1.868% of the total population. There are 435 seats in the House, and so Maryland's share is 8.127 seats. 

The number of seats awarded to a state must be a whole number. It seems reasonable to
give Maryland 8 seats by simple rounding. However, if we apply simple rounding 
to all states, it is possible that the number of seats allocated is not 435. 
It is also possible that a low population state would not be allocated any seats. 

## Data 

The basic information needed are the names of the states and their populations. 
This information is held in a comma separated (CSV) text file formatted like the file 
in `state-pops-2020.csv` in the `data` directory. 

The first line of the file should be this:
```
State,Population
```
Each subsequent line should give the name of the state and its population like this:
```
Nevada,3108462
New Hampshire,1379089
```
The file `state-pos-2020.csv` is based on information from the 2020 United States census 
that is published 
[here](https://www.census.gov/data/tables/2020/dec/2020-apportionment-data.html).

The function `read_pop_data` is used to read in such a data file and save it in 
a `DataFrame` that is used by the methods described below. Use it like this:
```
julia> using Apportionments

julia> DF = read_pop_data("/path/to/data/populations.csv")
```

If the file name is ommited, we use the `state-pops-2020.csv` file in the `data` 
directory.

```
julia> DF = read_pop_data()
50×2 DataFrame
 Row │ State           Population 
     │ String15        Int64      
─────┼────────────────────────────
   1 │ Alabama            5030053
   2 │ Alaska              736081
   3 │ Arizona            7158923
   4 │ Arkansas           3013756
   5 │ California        39576757
   6 │ Colorado           5782171
   7 │ Connecticut        3608298
   8 │ Delaware            990837
   9 │ Florida           21570527
  10 │ Georgia           10725274
  11 │ Hawaii             1460137
  ⋮  │       ⋮             ⋮
  41 │ South Dakota        887770
  42 │ Tennessee          6916897
  43 │ Texas             29183290
  44 │ Utah               3275252
  45 │ Vermont             643503
  46 │ Virginia           8654542
  47 │ Washington         7715946
  48 │ West Virginia      1795045
  49 │ Wisconsin          5897473
  50 │ Wyoming             577719
                   29 rows omitted
```

## Hamilton's Method

The function `Hamilton` computes a congressional apportionment method using 
the method proposed by 
[Alexander Hamilton](https://en.wikipedia.org/wiki/Alexander_Hamilton). 
It is also referred to as the *largest remainder method*. 

The function takes two arguments: `Hamilton(pop_data, nseats)`.
* `pop_data` is a `DataFrame` such as the output of `read_pop_data`.
* `nseats` is the number of seats to be allocated (and defaults to 435).

This is a typical workflow:
```
julia> using Apportionments

julia> DF = read_pop_data();

julia> ham_DF = Hamilton(DF)
50×6 DataFrame
 Row │ State           Population  Decimal_Seats  Round_Down  Frac_Seats  Seats 
     │ String15        Int64       Float64        Int64       Float64     Int64 
─────┼──────────────────────────────────────────────────────────────────────────
   1 │ Alabama            5030053       6.60833            6   0.608328       7
   2 │ Alaska              736081       0.96704            0   0.96704        1
   3 │ Arizona            7158923       9.40517            9   0.405171       9
   4 │ Arkansas           3013756       3.95938            3   0.959379       4
   5 │ California        39576757      51.9947            51   0.994717      52
   6 │ Colorado           5782171       7.59644            7   0.596437       8
   7 │ Connecticut        3608298       4.74047            4   0.74047        5
   8 │ Delaware            990837       1.30173            1   0.301731       1
   9 │ Florida           21570527      28.3387            28   0.33869       28
  10 │ Georgia           10725274      14.0905            14   0.0905326     14
  11 │ Hawaii             1460137       1.91828            1   0.918283       2
  ⋮  │       ⋮             ⋮             ⋮            ⋮           ⋮         ⋮
  41 │ South Dakota        887770       1.16632            1   0.166325       1
  42 │ Tennessee          6916897       9.0872             9   0.0872049      9
  43 │ Texas             29183290      38.3401            38   0.340102      38
  44 │ Utah               3275252       4.30292            4   0.302925       4
  45 │ Vermont             643503       0.845414           0   0.845414       1
  46 │ Virginia           8654542      11.3701            11   0.370069      11
  47 │ Washington         7715946      10.137             10   0.136971      10
  48 │ West Virginia      1795045       2.35827            2   0.358274       2
  49 │ Wisconsin          5897473       7.74792            7   0.747917       8
  50 │ Wyoming             577719       0.758989           0   0.758989       1
                                                                 29 rows omitted
``` 
The rightmost column is the number of seats awarded to each state.


## Huntington-Hill Method

The United States currently uses the 
[Huntington-Hill](https://en.wikipedia.org/wiki/Huntington%E2%80%93Hill_method)
method to assign seats to states. The function
`Huntington_Hill` implements this algorithm. 

The function takes two arguments: `Hamilton(pop_data, nseats)`.
* `pop_data` is a `DataFrame` such as the output of `read_pop_data`.
* `nseats` is the number of seats to be allocated (and defaults to 435).

This is a typical workflow:
```
julia> DF = read_pop_data();

julia> HH_DF = Huntington_Hill(DF)
50×3 DataFrame
 Row │ State           Population  Seats 
     │ String15        Int64       Int64 
─────┼───────────────────────────────────
   1 │ Alabama            5030053      7
   2 │ Alaska              736081      1
   3 │ Arizona            7158923      9
   4 │ Arkansas           3013756      4
   5 │ California        39576757     52
   6 │ Colorado           5782171      8
   7 │ Connecticut        3608298      5
   8 │ Delaware            990837      1
   9 │ Florida           21570527     28
  10 │ Georgia           10725274     14
  11 │ Hawaii             1460137      2
  ⋮  │       ⋮             ⋮         ⋮
  41 │ South Dakota        887770      1
  42 │ Tennessee          6916897      9
  43 │ Texas             29183290     38
  44 │ Utah               3275252      4
  45 │ Vermont             643503      1
  46 │ Virginia           8654542     11
  47 │ Washington         7715946     10
  48 │ West Virginia      1795045      2
  49 │ Wisconsin          5897473      8
  50 │ Wyoming             577719      1
                          29 rows omitted
```


## Saving Results

Use the `CSV.write` function to save the output of an apportionment method
to a file:
```
julia> using CSV

julia> CSV.write("ham_out.csv", ham_DF)
"ham_out.csv"
```

## Comparison

The two methods (Hamilton and Huntington-Hill) on the 2020 census data give
different results. While nearly the same, Hamilton's method gives one 
extra seat to each of New York and Ohio, and one fewer seat to each of
Montana and Rhode Island. 