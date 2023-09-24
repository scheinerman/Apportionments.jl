export app_compare
"""
    app_compare(;
    nseats = 435,
    pop_data = "data/state-pops-2020.csv",
    method_list::Vector{Function} = [Hamilton, Jefferson, Huntington_Hill, Rounding],
)::DataFrame

Compare different apportionment methods. The output is a `DataFrame` giving the results of 
various apportionment methods side-by-side.
"""
function app_compare(;
    nseats = 435,
    pop_data = "data/state-pops-2020.csv",
    method_list::Vector{Function} = [Hamilton, Jefferson, Huntington_Hill, Rounding],
)::DataFrame

    df = read_pop_data(pop_data)
    nstates = nrow(df)

    for f in method_list
        fname = string(f)
        df[!, fname] .= 0
        app = apportion(nseats = nseats, pop_data = pop_data, method = f)
        for idx = 1:nstates
            state = df[idx, :State]
            seats = app[state]
            df[idx, fname] = seats
        end


    end

    # This would remove the Population column in the result. But let's not.
    # select!(df, Not([:Population]))

    return df
end
