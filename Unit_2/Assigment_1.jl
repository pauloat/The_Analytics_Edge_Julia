using Pkg
#Pkg.add("Lathe")
#Pkg.add("GLM")
#Pkg.add("MLBase")
using DataFrames
using CSV
using Plots
using Lathe
using GLM
using Statistics
using StatsPlots
using MLBase

climate = DataFrame(CSV.File("climate_change.csv", missingstring = "NA"))

println(names(climate))

#Clean column names
colnames = Symbol[]
for i in string.(names(climate))
    push!(colnames, Symbol(replace(strip(i), "-" => "_")))
end
names!(climate, colnames)

println(names(climate))

#Generate train and test subsets

train = climate[climate[!,:Year] .<= 2006, :]
test = climate[climate[!, :Year] .> 2006, :]

#Linear regression
fm = @formula(Temp ~ MEI + CO2 + CH4 + N2O + CFC_11 + CFC_12 + TSI + Aerosols)

linearRegressor = lm(fm, train)

r2(linearRegressor)

println(linearRegressor)

cor(train.MEI, train.CO2)
cor(train.MEI, train.CH4)
cor(train.MEI, train.N2O)
cor(train.MEI, train.CFC_11)
cor(train.MEI, train.CFC_12)
cor(train.MEI, train.TSI)
cor(train.MEI, train.Aerosols)

cor(train.CO2, train.CH4)
cor(train.CO2, train.N2O)
cor(train.CO2, train.CFC_11)
cor(train.CO2, train.CFC_12)
cor(train.CO2, train.TSI)
cor(train.CO2, train.Aerosols)

cor(train.CH4, train.N2O)
cor(train.CH4, train.CFC_11)
cor(train.CH4, train.CFC_12)
cor(train.CH4, train.TSI)
cor(train.CH4, train.Aerosols)

cor(train.N2O, train.CFC_11)
cor(train.N2O, train.CFC_12)
cor(train.N2O, train.TSI)
cor(train.N2O, train.Aerosols)

cor(train.CFC_11, train.CFC_12)
cor(train.CFC_11, train.TSI)
cor(train.CFC_11, train.Aerosols)

cor(train.CFC_12, train.TSI)
cor(train.CFC_12, train.Aerosols)

cor(train.TSI, train.Aerosols)

cor(train.Temp, train.MEI)
cor(train.Temp, train.CO2)
cor(train.Temp, train.CH4)
cor(train.Temp, train.N2O)
cor(train.Temp, train.CFC_11)
cor(train.Temp, train.CFC_12)
cor(train.Temp, train.TSI)
cor(train.Temp, train.Aerosols)

#New madel

fm = @formula(Temp ~ MEI + TSI + Aerosols + N2O)

linearRegressor = lm(fm, train)

println(linearRegressor)

println(r2(linearRegressor))
