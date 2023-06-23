local PLUGIN = PLUGIN;

ix.command.Add("CharPermitMedals", {
	description = "Permit certain medal to character",
	OnCheckAccess = function(self, client)
		return client:GetCharacter():HasFlags("Z");
	end,
	arguments = {
		ix.type.character,
		ix.type.string
	},
	OnRun = function(self, client, target, name)
			if PLUGIN.medals[name] then
					local medals = target:GetData("Medals");
					if !medals[name] then
							medals[name] = name;
							client:Notify("You've successfully granted medal " .. name .. " to character " .. target:GetName())

							target:SetData("Medals", medals)

							target.player:SetNetVar("Medals", medals)
					else
							client:Notify("This character already have this medal.")
					end
			else
					client:Notify("You've provided wrong medal index")
			end
	end,
})

ix.command.Add("CharUnPermitMedals", {
	description = "Revoke certain medals from character",
	OnCheckAccess = function(self, client)
		return client:GetCharacter():HasFlags("Z");
	end,
	arguments = {
		ix.type.character,
		ix.type.string
	},
	OnRun = function(self, client, target, name)
			if PLUGIN.medals[name] then
					local medals = target:GetData("Medals");
					if medals[name] then
							medals[name] = nil;
							client:Notify("You've successfully revoked the medal " .. name .. " from character " .. target:GetName())
							
							target:SetData("Medals", medals)

							target.player:SetNetVar("Medals", medals)
					else
							client:Notify("The character don't have this medal.")
					end
			else
					client:Notify("You've provided wrong medal index")
			end
	end,
})