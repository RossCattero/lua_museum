local PLUGIN = PLUGIN;

local user = FindMetaTable("Player")

function user:GetVendorData()
	local char = self:getChar()
	return self:getLocalVar("job_info")
end;

function user:GetVendorRep()
		local data = self:GetVendorData()
		if !data then return end;
		return data["rep"]
end;

function user:GetJobID()
		local data = self:GetVendorData()
		if !data then return end;
		return data["id"]
end;

function user:GetJobName()
		local data = self:GetVendorData()
		if !data then return end;
		return data["name"] or "None"
end;

function user:GetJobPrice()
		local data = self:GetVendorData()
		if !data then return end;
		return data["price"] or 0
end;

function user:WorkInProgress()
		local uniqueID = "WorkTime: " .. self:getChar():getID()

		return timer.Exists(uniqueID);
end;

function user:CanPickJob(uniqueID)
		if !JOBPOSES then return false end;

		return JOBPOSES[uniqueID];
end;