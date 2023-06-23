local PLUGIN = PLUGIN;

local user = FindMetaTable("Player")

function user:GetVendorData()
	local char = self:getChar()
	return self:getLocalVar("job_info")
end;

function user:GetVendorRep()
		local data = self:GetVendorData()
		return data["reputation"]
end;

function user:GetJobID()
		local data = self:GetVendorData()
		return data["job_id"]
end;

function user:GetJobName()
		local data = self:GetVendorData()
		return data["job_name"] or "None"
end;

function user:GetJobPrice()
		local data = self:GetVendorData()
		return data["jobPrice"] or 0
end;

function user:WorkInProgress()
		local uniqueID = "WorkTime: " .. self:getChar():getID()

		return timer.Exists(uniqueID);
end;