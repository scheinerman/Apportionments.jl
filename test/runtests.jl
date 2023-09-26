using Test, Apportionments

d = apportion()
@test sum(values(d)) == Apportionments.house_seats

d = apportion(nseats=1000)
@test sum(values(d)) == 1000