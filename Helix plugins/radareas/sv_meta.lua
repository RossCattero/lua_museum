local PLUGIN = PLUGIN;

local user = FindMetaTable("Player")

function user:IncRad(inc)
		local char = self:GetCharacter();
		local radiation = char:GetData("Radiation");

		radiation = inc;

		char:SetData("Radiation", radiation);
		self:SetLocalVar("Radiation", radiation)
end;

function user:GetRad()
		local char = self:GetCharacter();
		return char:GetData("Radiation");
end;

function user:HasGeiger()
		local char = self:GetCharacter();
		local inventory = char:GetInventory();
		local detectors = inventory:GetItemsByUniqueID("geiger", true)
		
		local i = #detectors;
		while (i > 0) do
				local detector = detectors[i];
				if detector:GetData("toggled") then
						return true;
				end
				i = i - 1;
		end;

		return false;
end;

function user:EmitGeiger( toxic )
		if !self:HasGeiger() then return; end
		local geiger = PLUGIN.geigerSounds;

		local i = #geiger;
		while (i > 0) do
				local info = geiger[i];

				if info && toxic >= info.min && toxic <= info.max then
						self:EmitSound( info.sound )
				end

				i = i - 1;
		end;
end;