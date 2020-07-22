using CSV
using DataFrames
using Dates
using Statistics
using Plots

IBM = DataFrame(CSV.File("IBMStock.csv"))
GE = DataFrame(CSV.File("GEStock.csv"))
ProcterGamble = DataFrame(CSV.File("ProcterGambleStock.csv"))
CocaCola = DataFrame(CSV.File("CocaColaStock.csv"))
Boeing = DataFrame(CSV.File("BoeingStock.csv"))

dateformat = DateFormat("mm/dd/yyyy")

IBM[!, :Date] = Dates.Date.(IBM[!, :Date], dateformat)
GE[!, :Date] = Dates.Date.(GE[!, :Date], dateformat)
ProcterGamble[!, :Date] = Dates.Date.(ProcterGamble[!, :Date], dateformat)
CocaCola[!, :Date] = Dates.Date.(CocaCola[!, :Date], dateformat)
Boeing[!, :Date] = Dates.Date.(Boeing[!, :Date], dateformat)

for i in 1:1:nrow(IBM)
    if year(IBM[i, :Date]) >= 70
        IBM[i, :Date] = IBM[i, :Date] + Year(1900)
    else
        IBM[i, :Date] = IBM[i, :Date] + Year(2000)
    end
end

for i in 1:1:nrow(GE)
    if year(GE[i, :Date]) >= 70
        GE[i, :Date] = GE[i, :Date] + Year(1900)
    else
        GE[i, :Date] = GE[i, :Date] + Year(2000)
    end
end

for i in 1:1:nrow(ProcterGamble)
    if year(ProcterGamble[i, :Date]) >= 70
        ProcterGamble[i, :Date] = ProcterGamble[i, :Date] + Year(1900)
    else
        ProcterGamble[i, :Date] = ProcterGamble[i, :Date] + Year(2000)
    end
end

for i in 1:1:nrow(CocaCola)
    if year(CocaCola[i, :Date]) >= 70
        CocaCola[i, :Date] = CocaCola[i, :Date] + Year(1900)
    else
        CocaCola[i, :Date] = CocaCola[i, :Date] + Year(2000)
    end
end

for i in 1:1:nrow(Boeing)
    if year(Boeing[i, :Date]) >= 70
        Boeing[i, :Date] = Boeing[i, :Date] + Year(1900)
    else
        Boeing[i, :Date] = Boeing[i, :Date] + Year(2000)
    end
end

nrow(IBM)

first(IBM)

last(IBM)

mean(IBM[!, :StockPrice])

findmin(GE[!, :StockPrice])

findmax(CocaCola[!, :StockPrice])

median(Boeing[!, :StockPrice])

std(ProcterGamble[!, :StockPrice])

plot(IBM[!,:Date], IBM[!, :StockPrice], label = "IBM", linecolor = "blueviolet")
plot!(GE[!, :Date], GE[!, :StockPrice], label = "GE", linecolor = "darkblue")
plot!(ProcterGamble[!, :Date], ProcterGamble[!, :StockPrice], label = "Procter & Gamble", linecolor = "gold")
plot!(CocaCola[!, :Date], CocaCola[!, :StockPrice], label = "CocaCola", linecolor = "Darkred")
plot!(Boeing[!, :Date], Boeing[!, :StockPrice], label = "Boeing", linecolor = "greenyellow")

plot(IBM[301:432,:Date], IBM[301:432, :StockPrice], label = "IBM", linecolor = "blueviolet")
plot!(GE[301:432, :Date], GE[301:432, :StockPrice], label = "GE", linecolor = "darkblue")
plot!(ProcterGamble[301:432, :Date], ProcterGamble[301:432, :StockPrice], label = "Procter & Gamble", linecolor = "gold")
plot!(CocaCola[301:432, :Date], CocaCola[301:432, :StockPrice], label = "CocaCola", linecolor = "Darkred")
plot!(Boeing[301:432, :Date], Boeing[301:432, :StockPrice], label = "Boeing", linecolor = "greenyellow")

vline!([Date("1997-09-01")], label = "sep 1997")
vline!([Date("1997-11-30")], label = "nov 1997")

IBM[!, :Month] = monthname.(IBM[!, :Date])
GE[!, :Month] = monthname.(GE[!, :Date])
ProcterGamble[!, :Month] = monthname.(ProcterGamble[!, :Date])
CocaCola[!, :Month] = monthname.(CocaCola[!, :Date])
Boeing[!, :Month] = monthname.(Boeing[!, :Date])



by(IBM,:Month, :StockPrice => mean)
by(GE,:Month, :StockPrice => mean)
by(ProcterGamble,:Month, :StockPrice => mean)
by(CocaCola,:Month, :StockPrice => mean)
by(Boeing,:Month, :StockPrice => mean)
