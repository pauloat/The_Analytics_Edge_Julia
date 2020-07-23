using CSV
using DataFrames
using Statistics
using FreqTables

CPS = DataFrame(CSV.read("CPSData.csv", missingstring="NA"))

nrow(CPS)

println(describe(CPS))

freqtable(CPS, :Industry)

sort(freqtable(CPS, :State))

freqtable(CPS, :Citizenship)

(116639+7073)/nrow(CPS)

freqtable(CPS, :Race, :Hispanic)

println(first(CPS, 10))

by(CPS, :Region, :Married => ismissing)

println(freqtable(CPS, :Region, :Married))
println(freqtable(CPS, :Sex, :Married))
println(freqtable(CPS, :Age, :Married))
println(freqtable(CPS, :Citizenship, :Married))

CPS[!, :Miss_MetroAreaCode] = ismissing.(CPS[!, :MetroAreaCode])

println(sort(by(CPS, :State, :Miss_MetroAreaCode => mean), :Miss_MetroAreaCode_mean))
sort(by(CPS, :Region, :Miss_MetroAreaCode => mean))

MetroAreaMap = DataFrame(CSV.File("MetroAreaCodes.csv", missingstring="NA"))
CountryMap = DataFrame(CSV.File("CountryCodes.csv", missingstring = "NA"))

CPS = join(CPS, MetroAreaMap, on = :MetroAreaCode => :Code, kind = :left)

names(CPS)

println(describe(CPS))

sort(by(CPS, :MetroArea, :Hispanic => mean), :Hispanic_mean)

CPS[!, :Asian] = CPS[!, :Race] .== "Asian"

sort(by(CPS, :MetroArea, :Asian => mean), :Asian_mean)

CPS[!, :No_HS] = CPS[!, :Education] .== "No high school diploma"

function mean_skip_miss(x)
    mean(skipmissing(x))
end

sort(by(CPS, :MetroArea, :No_HS => mean_skip_miss), :No_HS_mean_skip_miss)

CPS = join(CPS, CountryMap, on = :CountryOfBirthCode => :Code, kind = :left)

names(CPS)

println(describe(CPS))

sort(by(CPS, :Country, nrow), :x1)

CPS_NY_NJ_PA = CPS[isequal.(CPS[!, :MetroArea], "New York-Northern New Jersey-Long Island, NY-NJ-PA"), :]

mean(.!(isequal.(CPS_NY_NJ_PA[!, :Country], "United States")))

sort(freqtable(CPS[isequal.(CPS[!, :Country], "India"), :], :MetroArea))

sort(freqtable(CPS[isequal.(CPS[!, :Country], "Brazil"), :], :MetroArea))

sort(freqtable(CPS[isequal.(CPS[!, :Country], "Somalia"), :], :MetroArea))
