export Jefferson

"""
    Jefferson(pop_data::DataFrame, nseats::Int = Apportionments.house_seats)

Create a congressional apportionment using Jefferson's method. 

* `data` is a `DataFrame` with two columns: `State` and `Population`. 
* `nseats` is the number of congressional seats

The output is a `DataFrame` that includes a `Seats` column that shows how 
many seats each state is awarded by this method.  
"""
function Jefferson(pop_data::DataFrame, nseats::Int = Apportionments.house_seats)
    data = deepcopy(pop_data)
    pvec = data[!, :Population]

    std_div_hi = sum(pvec) / nseats     # higher estimate on standard divisor

    # ensure that this gives a # of seats at most nseats

    while true
        if sum(Int.(floor.(pvec / std_div_hi))) <= nseats
            break
        end
        std_div_hi *= 1.05
    end

    # now find a standard divisor that gives # seats at least nseats
    std_div_lo = std_div_hi * 0.95
    while true
        if sum(Int.(floor.(pvec / std_div_lo))) >= nseats
            break
        end
        std_div_lo *= 0.95
    end

    # now proceed by bissection 
    std_div = 0.0
    while true
        std_div = (std_div_lo + std_div_hi) / 2
        seats = _seat_count(pvec, std_div)
        if seats == nseats
            break
        end
        if seats < nseats
            std_div_hi = std_div
        else
            std_div_lo = std_div
        end
    end

    data[!, :Seats] = Int.(floor.(pvec / std_div))
    return data
end


_seat_count(pvec::Vector, std_div) = sum(Int.(floor.(pvec / std_div)))


