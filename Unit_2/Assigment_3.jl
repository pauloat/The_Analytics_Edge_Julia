using Pkg
Pkg.add("ShiftedArrays")

using CSV
using DataFrames
using StatsPlots
using GLM
using Statistics
using ShiftedArrays

FluTrain = DataFrame(CSV.File("FluTrain.csv", missingstring = "NA"))

FluTrain[findmax(FluTrain.ILI)[2], :].Week

FluTrain[findmax(FluTrain.Queries)[2], :].Week

histogram(FluTrain.ILI, bins = 50, title = "ILI doctor visits", ylabel = "Frequency", xlabel = "ILI vists", legend = false)

scatter(log.(FluTrain.ILI), FluTrain.Queries, title = "Log(ILI) vs Query values", ylabel = "Percentage af Queries", xlabel = "Log of number of visits", legend = false)


fm = @formula(log(ILI) ~ Queries)

linearRegressor = lm(fm, FluTrain)

r2(linearRegressor)

FluTest = DataFrame(CSV.File("FluTest.csv", missingstring = "NA"))

yprediction_test = exp.(predict(linearRegressor, FluTest))
yprediction_train = exp.(predict(linearRegressor, FluTrain))

yprediction_test[FluTest.Week .== "2012-03-11 - 2012-03-17", :]

(FluTest.ILI[FluTest.Week .== "2012-03-11 - 2012-03-17", :] - yprediction_test[FluTest.Week .== "2012-03-11 - 2012-03-17", :])/FluTest.ILI[FluTest.Week .== "2012-03-11 - 2012-03-17", :]

performance_testdf = DataFrame(y_actual = FluTest.ILI, y_predicted = yprediction_test)
performance_testdf.error = performance_testdf.y_actual - performance_testdf.y_predicted
performance_testdf.error_sq = performance_testdf.error .^ 2

performance_traindf = DataFrame(y_actual = FluTrain.ILI, y_predicted = yprediction_train)
performance_traindf.error = performance_traindf.y_actual - performance_traindf.y_predicted
performance_traindf.error_sq = performance_traindf.error .^ 2

function rmse(performance_df)
    sqrt(mean(performance_df.error_sq))
end

function sse(performance_df)
    sum(performance_df.error_sq)
end

rmse(performance_testdf)

sse(performance_testdf)

FluTrain.ILIlag2 = ShiftedArray(FluTrain.ILI, 2)

println(describe(FluTrain))

scatter(log.(FluTrain.ILI), log.(FluTrain.ILIlag2), title = "Log of ILI vs Log of ILI with minus 2 weeks shift", ylabel = "log(ILI) with minus 2 weeks lag", xlabel = "log(ILI)", legend = false)

fm2 = @formula(log(ILI) ~ Queries + log(ILIlag2))

linearRegressor2 = lm(fm2, FluTrain)

println(linearRegressor2)

r2(linearRegressor2)

FluTest.ILIlag2 = ShiftedArray(FluTest.ILI, 2)

FluTest.ILIlag2 = convert(Vector, FluTest.ILIlag2)


println(describe(FluTest))

FluTest.ILIlag2[1] = FluTrain.ILI[416]
FluTest.ILIlag2[2] = FluTrain.ILI[end]

yprediction_test2 = exp.(predict(linearRegressor2, FluTest))

performance_test2df = DataFrame(y_actual = FluTest.ILI, y_predicted = yprediction_test2)
performance_test2df.error = performance_test2df.y_actual - performance_test2df.y_predicted
performance_test2df.error_sq = performance_test2df.error .^ 2

rmse(performance_test2df)



#Additional analisys

histogram(performance_testdf.error, title = "Test Error Analysis", ylabel = "Frequency", xlabel = "Erro", legend = false)

histogram(performance_traindf.error, title = "Train Error Analysis", ylabel = "Frequency", xlabel = "Erro", legend = false)

histogram(performance_test2df.error, title = "Test 2 Error Analysis", ylabel = "Frequency", xlabel = "Erro", legend = false)

scatter(performance_testdf.y_actual, performance_testdf.y_predicted, title = "Actual vs Predicted test values", ylabel = "Predicted values", xlabel = "Actual values", legend = false)

scatter(performance_test2df.y_actual, performance_test2df.y_predicted, title = "Actual vs Predicted test 2 values", ylabel = "Predicted values", xlabel = "Actual values", legend = false)

scatter(performance_testdf.y_actual, performance_traindf.y_predicted, title = "Actual vs Predicted train values", ylabel = "Predicted values", xlabel = "Actual values", legend = false)
