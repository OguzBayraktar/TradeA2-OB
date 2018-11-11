
##### INTERNATIONAL MACROECONOMICS AND TRADE ASSIGNMENT 2 #############
##### WRITTEN BY OGUZ BAYRAKTAR ###############

cd("/Users/oguzbayraktar/Desktop/2018-2019/trade/assignment/a2")
pwd()



import Pkg

Pkg.add("StatFiles")



Pkg.add("FixedEffectModels")

Pkg.add("RegressionTables")

using StatFiles, FixedEffectModels, RegressionTables


Pkg.add("DataFrames")

using DataFrames

data=DataFrame(load("col_regfile09.dta"))


data[:exporter]=categorical(data[:iso_o])
data[:importer]=categorical(data[:iso_d])
data[:catyear]=categorical(data[:year])
data[:logdist]=log.(data[:distw])
data[:logflow]=log.(data[:flow])


trialdata=data[(data[:year].=1995),:]
trialdata[trialdata[:flow].!=0.0,:]

@time reg(trialdata[trialdata[:flow].!=0.0,:],@model(logflow~ logdist+contig+comlang_off, fe=exporter&catyear + importer&catyear, vcov=robust))






@time femodeljulia=reg(data[data[:flow].!=0.0,:],@model(logflow~ logdist+contig+comlang_off, fe=exporter&catyear + importer&catyear, vcov=robust))




regtable(femodeljulia, renderSettings=latexOutput(),labels=Dict("comlang_off"=>"commonlang"))

###Parallel Computing

using Distributed
addprocs(2)

@everywhere using DataFrames, FixedEffectModels
@time reg(trialdata[trialdata[:flow].!=0.0,:],@model(logflow~ logdist+contig+comlang_off, fe=exporter&catyear + importer&catyear, vcov=robust), method = :lsmr_parallel)







@time reg(data[data[:flow].!=0.0,:],@model(logflow~ logdist+contig+comlang_off, fe=exporter&catyear + importer&catyear, vcov=robust), method = :lsmr_parallel)




