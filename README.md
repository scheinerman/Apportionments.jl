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

## The `apportion` Function

The `apportion` function reads in a file containing the populations of the states
and creates an apportionment based on the desired number of seats and the apportionment
method; see the **Methods** section below for a list of the available 
apportioning functions. 

This function returns a `Dict` mapping state names to the number of seats alloted to that state.


It is invoked as follows:
```
julia> apportion(nseats=435, pop_data="data/state-pops-2020.csv", method=Huntington_Hill)
```
Here we have the following named arguments:
* `nseats` is the number of seats available; default is 435.
* `pop_data` is the name of the CSV file holding the data (see next section); default is `state-pops-2020.csv` in the `data` directory.
* `method` is an apportionment function; default is `Huntington_Hill`.


```
julia> app_hh = apportion()    # all default values
Dict{String, Int64} with 50 entries:
  "Alaska"         => 1
  "Colorado"       => 8
  "Texas"          => 38
  "Alabama"        => 7
  "Massachusetts"  => 9
  "Vermont"        => 1
  "Missouri"       => 8
  "Wyoming"        => 1
  "California"     => 52
  "Florida"        => 28
  "Michigan"       => 13
  "Maine"          => 2
  "Iowa"           => 4
  "Tennessee"      => 9
  "Nevada"         => 4
  "Kentucky"       => 6
  "Delaware"       => 1
  "Indiana"        => 9
  "North Carolina" => 14
  ⋮                => ⋮

julia> app_ham = apportion(method=Hamilton);

julia> app_ham["Rhode Island"]
1

julia> app_hh["Rhode Island"]
2
```




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
The data in the file `state-pos-2020.csv` is from the 2020 United States 
census that is published 
[here](https://www.census.gov/data/tables/2020/dec/2020-apportionment-data.html).

#### Reading population data into a `DataFrame`

The function `read_pop_data` is used to read in such a data file and save it in 
a `DataFrame` that is used by the methods described below. Use it like this:
```
julia> using Apportionments

julia> DF = read_pop_data("/path/to/data/populations.csv")
```

If the file name is ommited, we use the `state-pops-2020.csv` file in the `data` 
directory.

Users will typically not need to use this function; it is called by the
`apportion` function. 

## Methods

All the apportioning methods take the same arguments:
* `pop_data` is a `DataFrame` such as the output of `read_pop_data`.
* `nseats` is the number of seats to be allocated (and defaults to 435).

However, these methods are not typically called directly by the user, 
but rather are used by the `apportion` function. 

Methods currently available:
* `Hamilton` -- method proposed by Alexander Hamilton.
* `Jefferson` -- method proposed by Thomas Jefferson.
* `Huntington_Hill` -- method currently used by the United States.
* `Rounding` -- demonstration method that might give an apportionment with the wrong number of seats.



## Saving Results

If an apportionment is computed directly using one of the apportionment functions, e.g. 
`Hamilton(pop_data, nseats)`, use the `CSV.write`
function to save the output of an apportionment method to a file:
```
julia> using CSV

julia> CSV.write("ham_out.csv", ham_DF)
"ham_out.csv"
```

## Comparing the Methods

The function `app_compare` produces a `DataFrame` showing the 
resulting apportionments using multiple methods displayed side-by-side.
```
app_compare(;
  nseats = 435,
  pop_data = "data/state-pops-2020.csv",
  method_list::Vector{Function} = [Hamilton, Jefferson, Huntington_Hill, Rounding]
)
```

The output looks like this:
```
50×6 DataFrame
 Row │ State           Population  Hamilton  Jefferson  Huntington_Hill  Rounding 
     │ String15        Int64       Int64     Int64      Int64            Int64    
─────┼────────────────────────────────────────────────────────────────────────────
   1 │ Alabama            5030053         7          6                7         7
   2 │ Alaska              736081         1          1                1         1
   3 │ Arizona            7158923         9          9                9         9
   4 │ Arkansas           3013756         4          4                4         4
   5 │ California        39576757        52         54               52        52
   6 │ Colorado           5782171         8          8                8         8
   7 │ Connecticut        3608298         5          5                5         5
   8 │ Delaware            990837         1          1                1         1
  ⋮  │       ⋮             ⋮          ⋮          ⋮             ⋮            ⋮
  44 │ Utah               3275252         4          4                4         4
  45 │ Vermont             643503         1          0                1         1
  46 │ Virginia           8654542        11         12               11        11
  47 │ Washington         7715946        10         10               10        10
  48 │ West Virginia      1795045         2          2                2         2
  49 │ Wisconsin          5897473         8          8                8         8
  50 │ Wyoming             577719         1          0                1         1
                                                                   35 rows omitted
```