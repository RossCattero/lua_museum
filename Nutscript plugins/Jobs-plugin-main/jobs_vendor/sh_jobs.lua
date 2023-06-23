local PLUGIN = PLUGIN;
JOBREP = {
	repMutli = 15, // % Bonus to money from reputation; Default: 15;
	priceMulti = 15, // % Bonus to money from price; Default: 15;
	jobMulti = 10, // job reputation + X% from job reputation add to the reputation when job done; Default: 10;
	vectorsAmount = 5, // Maximum position vectors amount for each job; Default: 5; Admins won't add more if positions amount reached this number;
	repMax = 100, // Maximum reputation character can have; Default: 100;
	repMin = -10, // Minimum of reputation character can have; Default: -10;
	takeRep = 5, // Take the reputation amount on job fail; Default: 5;
}

PLUGIN.jobsList = {}
PLUGIN.jobPoses = PLUGIN.jobPoses or {}

function PLUGIN:CreateJob(uniuqeID, data)
		if !uniuqeID || !data || (data && !data.ent) then return end;

		if !self.jobsList[uniuqeID] then
				data.uniqueID = uniuqeID;
				self.jobsList[uniuqeID] = data;
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
		reputation = 25, // Reputation for done job;
})
*/

PLUGIN:CreateJob("fireHidrants", {
	title = "Fire hidrants bursting",
	description = "",
	price = 50,
	ent = "job_firehidrant",
	timeForRepair = 60,
	reputation = 25,
})

PLUGIN:CreateJob("electricalWires", {
	title = "Electrical wires bursting",
	description = "",
	price = 50,
	ent = "job_electrics",
	timeForRepair = 60,
	reputation = 25,
})

PLUGIN:CreateJob("roadRepair", {
	title = "Road repair",
	description = "",
	price = 100,
	ent = "job_roadpath",
	timeForRepair = 60,
	reputation = 25,
})