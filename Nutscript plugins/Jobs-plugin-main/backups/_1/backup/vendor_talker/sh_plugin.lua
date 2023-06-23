local PLUGIN = PLUGIN
PLUGIN.name = "Vendor jobs plugin"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "Vendor jobs, which allows to take some kinds of works from vendors."

PLUGIN.debug = true;

nut.util.include("cl_plugin.lua")
nut.util.include("sh_jobs.lua")
nut.util.include("sv_plugin.lua") 
nut.util.include("sh_meta.lua") 
nut.util.include("sv_meta.lua") 
nut.util.include("sv_jobs.lua") 

nut.command.add("addJobPlace", {
	adminOnly = true,
	onRun = function(client)
			for k, v in pairs(PLUGIN.jobPoses) do
					PLUGIN:SortJobsPositions(k)
			end
			netstream.Start(client, 'jobVendor::addJobPlace', PLUGIN.jobPoses)
	end
})