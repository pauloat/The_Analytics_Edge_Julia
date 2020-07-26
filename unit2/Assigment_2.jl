using CSV
using DataFrames
using Statistics
using Lathe
using GLM
using StatsPlots
using MLBase

ENV["COLUMNS"] = 1000


pisaTrain = DataFrame(CSV.File("pisa2009train.csv", missingstring = "NA"))
pisaTest = DataFrame(CSV.File("pisa2009test.csv", missingstring = "NA"))

nrow(pisaTrain)

println(names(pisaTrain))

by(pisaTrain, :male, :readingScore => mean)

println(describe(pisaTrain))

pisaTrain = pisaTrain[completecases(pisaTrain), :]
pisaTest = pisaTest[completecases(pisaTest), :]

nrow(pisaTrain)
nrow(pisaTest)Temp

boxplot(pisaTrain.readingScore, title = "Boxplot Reading Score", ylabel = "Reading Score", legend = false)

#One Hot Encoding

scaled_feature = Lathe.preprocess.OneHotEncode(pisaTrain, :raceeth)
scaled_feature2 = Lathe.preprocess.OneHotEncode(pisaTest, :raceeth)

#Clean column names
colnames = Symbol[]
for i in string.(names(pisaTrain))
    push!(colnames, Symbol(replace(replace(strip(i), " " => "_"), "/" => "_")))
end
names!(pisaTrain, colnames)
names!(pisaTest, colnames)

select!(pisaTrain, Not([:raceeth, :White]))
select!(pisaTest, Not([:raceeth, :White]))



#Linear regression

IndependVars = sum(Term.(Symbol.(names(pisaTrain[:, Not(:readingScore)]))))

#this line doesn't work
#fm = @formula(Term(:readingScore) ~ sum(Term.(Symbol.(names(pisaTrain[:, Not(:readingScore)])))))

linearRegressor = lm(Term(:readingScore) ~ sum(Term.(Symbol.(names(pisaTrain[:, Not(:readingScore)])))), pisaTrain)

r2(linearRegressor)

yprediction_train = predict(linearRegressor, pisaTrain)
yprediction_test = predict(linearRegressor, pisaTest)

performance_traindf = DataFrame(y_actual = pisaTrain.readingScore, y_predicted = yprediction_train)
performance_traindf.error = performance_traindf.y_actual - performance_traindf.y_predicted
performance_traindf.error_sq = performance_traindf.error .^ 2

performance_testdf = DataFrame(y_actual = pisaTest.readingScore, y_predicted = yprediction_test)
performance_testdf.error = performance_testdf.y_actual - performance_testdf.y_predicted
performance_testdf.error_sq = performance_testdf.error .^ 2

function mape(performance_df)
    mape = mean(abs.(performance_df.error ./ performance_df.y_actual))
    return mape
end

function rmse(performance_df)
    rmse = sqrt(mean(performance_df.error_sq))
    return rmse
end

function sse(performance_df)
    sse = sum(performance_df.error_sq)
    return sse
end


rmse(performance_traindf)

println(linearRegressor)

findmax(performance_testdf.y_predicted)[1] - findmin(performance_testdf.y_predicted)[1]

println(sse(performance_testdf))

rmse(performance_testdf)

baseline = mean(performance_traindf.y_predicted)


sse(performance_traindf)

sum((baseline .- performance_testdf.y_actual).^2)

r2(linearRegressor)

1 - sse(performance_testdf)/ sum((baseline .- performance_testdf.y_actual).^2)

#Additional analisys

histogram(performance_traindf.error, title = "Train error analisys", bins = 50, ylabel = "frequency", xlabel = "error", legend = false)

histogram(performance_testdf.error, title = "Test error analisys", bins = 50, ylabel = "frequency", xlabel = "error", legend = false)

train_plot = scatter(performance_traindf.y_actual, performance_traindf.y_predicted, title = "Actual vs Predicted train values", ylabel = "Predicted reading score", xlabel = "Actual reading score", legend = false)

test_plot = scatter(performance_testdf.y_actual, performance_testdf.y_predicted, title = "Actual vs Predicted test values", ylabel = "Predicted reading score", xlabel = "Actual reading score", legend = false)

function cross_validation(train, k, fm)
    a = collect(Kfold(size(train)[1], k))
    for i in 1:k
        row = a[i]
        temp_train = train[row, :]
        temp_test = train[setdiff(1:end, row), :]
        linearRegressor = lm(fm, temp_train)
        performance_testdf = DataFrame(y_actual = temp_test.readingScore, y_predicted = predict(linearRegressor, temp_test))
        performance_testdf.error = performance_testdf.y_actual - performance_testdf.y_predicted

        println("Mean error for set $i is ", mean(abs.(performance_testdf.error)))
    end
end


cross_validation(pisaTrain, 10, Term(:readingScore) ~ sum(Term.(Symbol.(names(pisaTrain[:, Not(:readingScore)])))))
