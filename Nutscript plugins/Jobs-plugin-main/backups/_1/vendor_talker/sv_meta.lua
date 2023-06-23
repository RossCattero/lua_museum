local PLUGIN = PLUGIN;

JOB = {}
function JOB:new(index, data)
		if !index then return end;
		
    local obj = {}
		obj = {};
		obj.price = data.price || 0;
		obj.reputation = data.reputation || 0;
		obj.index = index or nil

    setmetatable(obj, self)
    self.__index = self; 
		return obj
end

local user = FindMetaTable("Player")
function user:CreateJob(data)
		if self:GetJobID() != 0 then return end;
		local i = self:CanPickJob(data.uniqueID)
		if !i then return end;
		if !PLUGIN.jobPoses[data.uniqueID][i] then return end;

		local globalJob = PLUGIN.jobPoses[data.uniqueID][i];
		local ent = globalJob[3]

		if ent:IsValid() && IsEntity(ent) then
				ent:Broke()
				PLUGIN.jobPoses[data.uniqueID][i][4] = true;
		end;

		local index = os.time() + 32

		local job = JOB:new(index, {price = data.price, reputation = data.rep})
		PLUGIN.getJobs[index] = job;

		self:SetJobInfo("job_name", data.title)
		local REPUTATION = self:GetVendorRep()
		local bonus = 
			(REPUTATION * (JOBREP.repMutli / 100)) 
			+ 
			(data.price * (JOBREP.priceMulti / 100));
		self:SetJobInfo("jobPrice", data.price + bonus)
		
		self:SetJobInfo("job_id", index);
end;

function user:CanPickJob(uniqueID)
		if self:GetJobID() != 0 then return false end;
		local jobList = PLUGIN.jobPoses[uniqueID];
		if !jobList then return false end;

		local i = 1;
		while (i <= #jobList) do
				local ent = jobList[i][3];
				local canPick = jobList[i][4];
				if !ent || ent && ent == NULL then return false end;

				if !canPick then
						return i;
				end

				i = i + 1;
		end

		return false;
end;

function user:ClearJob()
		local job = self:GetJobID();
		if job == 0 then return end;

		PLUGIN.getJobs[job] = nil;
		self:SetJobInfo("jobPrice", 0)
		self:SetJobInfo("job_id", 0);
end;

function user:SetJobInfo(index, value)
		local data = self:getChar():getData("job_info");
		if data[index] then
				data[index] = value;
				self:getChar():setData("job_info", data);
				self:setLocalVar("job_info", data);
		end
end;