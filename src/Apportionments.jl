module Apportionments
using CSV, DataFrames

export read_pop_data
"""
    data_dir 

Path to the `data` directory of the `Apportionments` package.
"""
const data_dir = joinpath(pkgdir(Apportionments), "data")

"""
    pop2020_data

Full path file name for the 2020 Congressional apportionment 
census data.
"""
const pop2020_data = joinpath(data_dir, "state-pops-2020.csv")

"""
    house_seats

Number of seats in the US House of Representatives.
"""
const house_seats = 435

"""
    read_pop_data(file_name::String = pop2020_data)::DataFrame

Create a `DataFrame` from a CSV file. The CSV file should have two
columns named `State` and `Population`. 

The `State` column should be character strings and the `Population` 
column should be integers.

The default population data is given by `pop20202_data` which specifies the 
file `state-pops-2020.csv` in the `data` directory.
"""
function read_pop_data(file_name::String = pop2020_data)::DataFrame
    CSV.read(file_name, DataFrame)
end

include("Hamilton.jl")
include("Huntington_Hill.jl")



end # module Apportionments
