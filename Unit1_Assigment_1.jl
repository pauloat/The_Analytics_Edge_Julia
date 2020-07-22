using CSV
using DataFrames
using Dates
using Statistics
using FreqTables
using Plots
using StatsPlots

mvt = DataFrame(CSV.File("mvtWeek1.csv"))
typeof(mvt)

structure(mvt)

println(describe(mvt))

nrow(mvt)
ncol(mvt)

findmax(mvt[!, :ID])
findmin(mvt[!, :Beat])

freqtable(mvt, :Arrest)

println(sort(by(mvt, :LocationDescription, nrow)))

typeof(mvt[!, :Date])

first(mvt[!, [:Date]])

date_format = DateFormat("mm/dd/yyyy H:M")

#datatest = first(mvt[!, [:Date]], 1)
#datatest[:Date] = Dates.DateTime.(datatest[:Date], date_format)
#datatest

mvt[!, :Date] = Dates.DateTime.(mvt[!, :Date], date_format)

mvt[!, :Date] = mvt[!, :Date] .+ Year(2000)

println(describe((mvt[!,[:Date]])))

medInstant = Int(round(median(Dates.value.(mvt[!, :Date]))))
medianDate = DateTime(Dates.UTM(medInstant))

mvt[!, :Month] = Dates.monthname.(mvt[!, :Date])

mvt[!, :Year] = Dates.year.(mvt[!, :Date])

mvt[!, :Weekday] = Dates.dayname.(mvt[!, :Date])

println(describe(mvt[!,[:Month]]))

println(by(mvt, :Month, nrow))

by(mvt, :Date, nrow)[!, :Date]

freqtable(mvt, :Month)

freqtable(mvt, :Year)

freqtable(mvt, :Month, :Arrest)

hist = histogram(mvt[!,:Date], bins = 100)

function int_to_datetime(x)
    DateTime(Dates.UTM(x))
end

function int_to_year(x)
    year(int_to_datetime(x))
end

plot(hist, xlabel = "Year", ylabel = "number of motor vehicle thiefs" , xformatter = int_to_year, yformatter = :plain, xrotation = 40, yrotation = 40)

boxplot(mvt[!, :Arrest], mvt[!, :Date])

freqtable(mvt, :Year, :Arrest)


freqtable(mvt, :Year, :Arrest)[13]/(freqtable(mvt, :Year, :Arrest)[1] + freqtable(mvt, :Year, :Arrest)[13])

freqtable(mvt, :Year, :Arrest)[19]/(freqtable(mvt, :Year, :Arrest)[7] + freqtable(mvt, :Year, :Arrest)[19])

freqtable(mvt, :Year, :Arrest)[24]/(freqtable(mvt, :Year, :Arrest)[12] + freqtable(mvt, :Year, :Arrest)[24])

sort(freqtable(mvt, :LocationDescription), rev = true)

Top5 = mvt[findall(in(["STREET", "PARKING LOT/GARAGE(NON.RESID.)", "ALLEY", "GAS STATION", "DRIVEWAY - RESIDENTIAL"]), mvt[!, :LocationDescription]), :]

names(Top5)

println(freqtable(Top5, :LocationDescription, :Arrest)[6]/(freqtable(Top5, :LocationDescription, :Arrest)[1] + freqtable(Top5, :LocationDescription, :Arrest)[6]))

println(freqtable(Top5, :LocationDescription, :Arrest)[7]/(freqtable(Top5, :LocationDescription, :Arrest)[2] + freqtable(Top5, :LocationDescription, :Arrest)[7]))

println(freqtable(Top5, :LocationDescription, :Arrest)[8]/(freqtable(Top5, :LocationDescription, :Arrest)[3] + freqtable(Top5, :LocationDescription, :Arrest)[8]))

println(freqtable(Top5, :LocationDescription, :Arrest)[9]/(freqtable(Top5, :LocationDescription, :Arrest)[4] + freqtable(Top5, :LocationDescription, :Arrest)[9]))

println(freqtable(Top5, :LocationDescription, :Arrest)[10]/(freqtable(Top5, :LocationDescription, :Arrest)[5] + freqtable(Top5, :LocationDescription, :Arrest)[10]))

println(freqtable(Top5, :LocationDescription, :Weekday))
