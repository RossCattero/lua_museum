local PLUGIN = PLUGIN;
JOBREP = {
	repMutli = 15, // Percent from reputation to get from price as bonus; Default: 15
	priceMulti = 15, // Percent from price to add to bonus; Default: 15
	jobRep = 10, 		// Job reputation given on job done; Default: 10
	jobMulti = 10, // jobRep + X% from jobRep add to the reputation when job done; Default: 10
	vectorsAmount = 5, // Maximum position vectors amount for each job; Default: 5
}
PLUGIN.jobsList = {}
PLUGIN.jobPoses = PLUGIN.jobPoses or {}

function PLUGIN:CreateJob(uniuqeID, data)
		if !uniuqeID || !data || (data && !data.ent) then return end;

		if !self.jobsList[uniuqeID] then
				data.uniqueID = uniuqeID;
				self.jobsList[uniuqeID] = data;
		end;
		if !self.jobPoses[uniuqeID] then
			self.jobPoses[uniuqeID] = {}
		end;
end;

// EXAMPLE:
/*
PLUGIN:CreateJob("PLACE UNIQUE NAME HERE", {
		title = "Simple title",
		description = "Description of a job.",
		price = 50, // A price for the job done in local nutscript currency;
		ent = "",  // Entity that will be spawned/break for this job;
		timeForRepair = 60, // Time that will be given for player to repair a broken equipment;
})
*/

PLUGIN:CreateJob("fireHidrants", {
	title = "Fire hidrants bursting",
	description = "",
	price = "50",
	ent = "job_firehidrant",
	timeForRepair = 10,
})

PLUGIN:CreateJob("electricalWires", {
	title = "Electrical wires bursting",
	description = "",
	price = "50",
	ent = "job_electrics",
	timeForRepair = 10,
})

PLUGIN:CreateJob("roadRepair", {
	title = "Road repair",
	description = "",
	price = "100",
	ent = "job_roadpath",
	timeForRepair = 10,
})