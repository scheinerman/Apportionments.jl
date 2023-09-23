export Huntington_Hill


"""
    Huntington_Hill(pop_data::DataFrame, nseats::Int = house_seats)::DataFrame

Create a congressional apportionment using the Huntington-Hill method. 

* `data` is a `DataFrame` with two columns: `State` and `Population`. 
* `nseats` is the number of congressional seats
    
The output is a `DataFrame` that includes a `Seats` column that shows how 
many seats each state is awarded by this method.  
"""
function Huntington_Hill(pop_data::DataFrame, nseats::Int = house_seats)::DataFrame
    data = deepcopy(pop_data)
    n_states = length(data.State)

    # give one seat to every state
    data[!, :Seats] = ones(Int, n_states)

    while sum(data.Seats) < nseats

        # calculate priorities 
        priority = zeros(n_states)
        for idx = 1:n_states
            p = data.Population[idx]   # population of the state
            s = data.Seats[idx]        # current number of seats
            priority[idx] = p / sqrt(s*(s+1))
        end

        # find the state with the highest priority and assign another seat
        (pop, idx) = findmax(priority)
        data.Seats[idx] += 1
    end

    return data
end
