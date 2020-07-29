using CSV
using DataFrames
using StatsPlots
using Statistics
using GLM

statedata = DataFrame(CSV.File("statedata.csv", missingstring = "NA"))

names(statedata)

columnsname = Symbol[]

for i in string.(names(statedata))
    push!(columnsname, Symbol(replace(strip(i), "." => "_")))
end

names!(statedata, columnsname)

println(names(statedata))

scatter(statedata.x, statedata.y)

by(statedata, :state_region, :HS_Grad => mean)

boxplot(statedata.state_region, statedata.Murder, title = "Boxplot Murder Rate by US Region", ylabel = "Murder Rate", xlabel = "US Region", legend = false)

println(statedata[statedata.state_region .== "Northeast", :])

fm = @formula(Life_Exp ~ Population + Income + Illiteracy + Murder + HS_Grad + Frost + Area)

linearRegressor = lm(fm, statedata)

println(linearRegressor)

scatter(statedata.Income, statedata.Life_Exp, title = "Income vs Life Expectancy", ylabel = "Life Expectancy", xlabel = "Income", legend = false)

fm2 = @formula(Life_Exp ~ Population + Income + Illiteracy + Murder + HS_Grad + Frost)

linearRegressor2 = lm(fm2, statedata)

println(linearRegressor2)

fm3 = @formula(Life_Exp ~ Population + Income + Murder + HS_Grad + Frost)

linearRegressor3 = lm(fm3, statedata)

println(linearRegressor3)

fm4 = @formula(Life_Exp ~ Population + Murder + HS_Grad + Frost)

linearRegressor4 = lm(fm4, statedata)

println(linearRegressor4)

ypredict_train = predict(linearRegressor4, statedata)

performance_traindf = DataFrame(state = statedata.state_name, y_actual = statedata.Life_Exp, y_predicted = ypredict_train)

sort(performance_traindf, :y_predicted)

sort(performance_traindf, :y_actual)

performance_traindf.error = performance_traindf.y_predicted - performance_traindf.y_actual

performance_traindf.error_abs = abs.(performance_traindf.error)

sort(performance_traindf, :error_abs)


#Additional analisys

boxplot(statedata.Life_Exp, title = "Life Expectancy Boxplot", ylabel = "Life Expectany", legend = false)

histogram(performance_traindf.error, bins = 10, title = "Error Analisys", ylabel = "Frequency", xlabel = "Error", legend = false)

scatter(performance_traindf.y_actual, performance_traindf.y_predicted, title = "Actual vs Predicted values", ylabel = "Predicted values", xlabel = "Predicted values", legend = false)
