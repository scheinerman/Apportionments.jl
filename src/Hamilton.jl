export Hamilton

"""
    Hamilton(pop_data::DataFrame, nseats::Int = house_seats)::DataFrame

Create a congressional apportionment using Hamilton's method. 

* `data` is a `DataFrame` with two columns: `State` and `Population`. 
* `nseats` is the number of congressional seats

The output is a `DataFrame` that includes a `Seats` column that shows how 
many seats each state is awarded by this method.  
"""
function Hamilton(pop_data::DataFrame, nseats::Int = house_seats)::DataFrame
    data = deepcopy(pop_data)

    # create a column for the fractional assignment of seats
    total_pop = sum(data.Population)
    data[!, :Decimal_Seats] = nseats * data.Population / total_pop

    # create columns for the floor and fractional parts of Frac_Seats 
    data[!, :Round_Down] = Int.(floor.(data.Decimal_Seats))
    data[!, :Frac_Seats] = data.Decimal_Seats - data.Round_Down

    # create a column for the final apportionment of seats 
    data[!, :Seats] = copy(data.Round_Down)   # copy of Round_Down

    # sort the table in decreasing order of Frac_Seats
    sort!(data, :Frac_Seats, rev = true)

    # add seats to states in decreasing order of their fractional seats 
    n_states = length(data.State)
    for idx = 1:n_states
        if sum(data.Seats) >= nseats # stop if the House is full
            break
        end
        data.Seats[idx] += 1
    end

    # restore alpha order of states 
    sort!(data)
    return data
end
