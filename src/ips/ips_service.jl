include("ips_internals.jl")

"""
Get the metada from available data sets.
Return false if not sucessfull.
"""
function get_datasets_metadata()
	return 1 #TODO return a unique ID or -1 in case of error
end

"""
Get the available SLA types. SLA is simplified to resource requierements
and its costs.

Disclaimer: The **cost is an estimation** on how much would be payed to public
Clouds for Docker instances with these requirements.
"""
function get_slas()
	return ["SLA 1: 512MB, 1 vCPU, USD 0.057/hour",
					"SLA 2: 1024MB, 2 vCPUs, USD 0.114/hour",
					"SLA 3: 2048MB, 4 vCPUs, USD 0.228/hour"]
end




#
# TESTS
#

function test()

end
