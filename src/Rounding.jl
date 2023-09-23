export Rounding

"""
    Rounding(pop_data::DataFrame, nseats::Int = house_seats)::DataFrame

Create a congressional apportionment just by rounding. 

* `data` is a `DataFrame` with two columns: `State` and `Population`. 
* `nseats` is the number of congressional seats
    
The output is a `DataFrame` that includes a `Seats` column that shows how 
many seats each state is awarded by this method.  

A warning is generated if the resulting apportionment does not have 
the requested number of seats.
"""
function Rounding(pop_data::DataFrame, nseats::Int = house_seats)::DataFrame
    data = deepcopy(pop_data)
    total_pop = sum(data.Population)
    data[!, :Decimal_Seats] = nseats * data.Population / total_pop
    data[!, :Seats] = Int.(round.(data.Decimal_Seats))

    sum_seats = sum(data.Seats)
    if sum(data.Seats) != nseats
        @warn "This apportionment gives $sum_seats seats, but $nseats were requested."
    end
    return data
end