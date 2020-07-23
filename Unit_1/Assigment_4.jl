sing CSV
using DataFrames
using Statistics
using FreqTables
using Plots
using Distributions


cd("/home/zorakw/Documents/The_Analytic_Edge_MIT/datasets/")
pwd()

poll = DataFrame(CSV.File("AnonymityPoll.csv", missingstring = "NA"))

println(describe(poll))

nrow(poll)

freqtable(poll, :Smartphone)

println(unique(poll[poll[!, :Region] .== "Midwest", :], :State)[!, :State])

sort(freqtable(poll[poll[!, :Region] .== "South", :], :State))

names(poll)

println(freqtable(poll, Symbol("Internet.Use"), :Smartphone))

limited = poll[isequal.(poll[!, Symbol("Internet.Use")] , 1) .| isequal.(poll[!, :Smartphone], 1), :]

nrow(limited)

println(describe(limited))

mean(skipmissing(limited[!, Symbol("Info.On.Internet")]))

freqtable(limited, Symbol("Info.On.Internet"))

println(freqtable(poll, Symbol("Internet.Use"), :Smartphone))

limited = poll[isequal.(poll[!, Symbol("Internet.Use")] , 1) .| isequal.(poll[!, :Smartphone], 1), :]

nrow(limited)

println(describe(limited))

mean(skipmissing(limited[!, Symbol("Info.On.Internet")]))

freqtable(limited, Symbol("Info.On.Internet"))

histogram(collect(skipmissing(limited[!, :Age])))

age_vs_info = freqtable(limited,:Age, Symbol("Info.On.Internet"))

age_vs_info_df = DataFrame(age_vs_info, Symbol.(names(age_vs_info, 2)))

info_vs_age = freqtable(limited, Symbol("Info.On.Internet"), :Age)

info_vs_age_df = DataFrame(info_vs_age, Symbol.(names(info_vs_age, 2)))

open("myfile.txt", "w") do io
    println(io, age_vs_info_df)
    iswritable(io)
end

open("myfile2.txt", "w") do io
    println(io, info_vs_age_df)
    iswritable(io)
end

function jitter(x)
    z = extrema(collect(skipmissing(x)))[1]
    a = z/50
    if a == 0
        x = x .+ rand.()
        return x
    else
        x = x .+ rand.(Uniform(-a, a))
        return x
    end
end


jitter([1, 2, 3])

findmax(collect(skipmissing(limited[!, :Age])))

scatter(jitter(limited[!, :Age]), jitter(limited[!, Symbol("Info.On.Internet")]))

println(by(limited, :Smartphone, Symbol("Info.On.Internet") => mean))

function mean_skip_miss(x)
    mean(collect(skipmissing(x)))
end

println(by(limited, :Smartphone, Symbol("Tried.Masking.Identity") => mean_skip_miss))
