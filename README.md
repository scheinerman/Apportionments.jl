# Apportionments
Congressional Apportionment Methods

## Overview

Seats in the United States House of Representatives are allocated based on the populations
of the states. Specifically, the inputs to an apportionment procedure are the populations
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
