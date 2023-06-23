local PLUGIN = PLUGIN;

function PLUGIN:AddJobPosition(uniqueID, vector, clientName, ent)
		local id = #self.jobPoses[uniqueID] + 1;

		self.jobPoses[uniqueID][id] = {vector, clientName, ent, false};

		return id;
end;

function PLUGIN:RemoveJobPosition(uniqueID, id)
		if !self.jobPoses[uniqueID] || (self.jobPoses[uniqueID] && !self.jobPoses[uniqueID][id]) then
				return;
		end
		local ent = self.jobPoses[uniqueID][id][3];
		ent:Remove();

		self.jobPoses[uniqueID][id] = nil;

		// refresh;
		self:ListRefresh(uniqueID)
end;

function PLUGIN:ListRefresh(uniqueID)
	local players = player.GetAll();
	local i, max = 1, #players

	// Sorting ids;
	self:SortJobsPositions(uniqueID)

	// Synchronization;
	while (i <= max) do
			local user = players[i];
			if user:IsValid() && (user:IsAdmin() || user:IsSuperAdmin()) then
					netstream.Start(user, 'jobVendor::updateRemoveList', self.jobPoses)
			end;
			i = i + 1
	end
end;

// Id sorting;
function PLUGIN:SortJobsPositions(uniqueID)
		local poses = self.jobPoses[uniqueID]
		poses = #poses > 0 && poses || false;
		if !poses then
				return;
		end
		
		local tblSorted = {}
		for k, v in pairs(poses) do
				v[1] = v[3]:GetPos()
				tblSorted[#tblSorted + 1] = v;
		end
		poses = tblSorted
end;