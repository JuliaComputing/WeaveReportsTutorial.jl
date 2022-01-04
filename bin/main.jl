using Weave
using JSON3
using Tar

# results file returns the html (default) - otherwise zip together the html and figures
const output = get(ENV, "output", "html")

const xaxis = get(ENV, "xaxis", "sepal.length")
const yaxis = get(ENV, "yaxis", "petal.width")
const date = Dates.today()

const report_name = "weave-iris"
const path_results = "$(@__DIR__)/../results"

weave("$(@__DIR__)/../reports/$(report_name).jmd", 
    out_path = "$(path_results)", 
    fig_path = "$(path_results)/fig", 
    doctype = "md2html",
    args = (date = date, xaxis = xaxis, yaxis = yaxis))

ENV["RESULTS"] = JSON3.write(Dict("results directory" => readdir(path_results)))

if output == "html"
    ENV["RESULTS_FILE"] = "$(path_results)/$(report_name).html"
else
    tarball = Tar.create(path_results)
    ENV["RESULTS_FILE"] = tarball
end