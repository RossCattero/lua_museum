local PLUGIN = PLUGIN

/*
	Custom hook used for callback a wound instancing only if wound owner is online;
	@realm [server]
	@argument [client] [Player object] The player object, who owns the wound.
	@argument [woundID] [number] The ID of the wound.
	@where libs/sh_wound.lua : line 150 : function ix.wound.Instance
*/
function PLUGIN:WoundInstance( client, woundID )
	local wound = ix.wound.instances[ woundID ]

	if !wound then return end;
	local uniqueID, legs = wound:UniqueID(), wound:IsLegs()
	
	if legs then
		if uniqueID == "bleed" then
			client:SetWalkSpeed( client:GetWalkSpeed() * (1 - 5/100) )
			client:SetRunSpeed( client:GetRunSpeed() * (1 - 5/100) )
			client:SetSlowWalkSpeed( client:GetSlowWalkSpeed() * (1 - 5/100) )
		end

		if uniqueID == "fracture" then
			client:SetWalkSpeed( client:GetWalkSpeed() * (1 - 25/100) )
			client:SetRunSpeed( client:GetRunSpeed() * (1 - 25/100) )
			client:SetSlowWalkSpeed( client:GetSlowWalkSpeed() * (1 - 25/100) )
		end

		if uniqueID == "burn" then
			client:SetWalkSpeed( client:GetWalkSpeed() * (1 - wound:GetData("damage", 0)/100) )
			client:SetRunSpeed( client:GetRunSpeed() * (1 - wound:GetData("damage", 0)/100) )
			client:SetSlowWalkSpeed( client:GetSlowWalkSpeed() * (1 - wound:GetData("damage", 0)/100) )
		end
	end;
end;

/*
	Custom hook used for callback a wound remove only if wound owner is online;
	@realm [server]
	@argument [client] [Player object] The player object, who owns the wound.
	@argument [woundID] [number] The ID of the wound.
	@where meta/sh_wound.lua : line 137 : function WOUND:Remove
*/
function PLUGIN:PreWoundRemove( client, woundID )
	local wound = ix.wound.instances[ woundID ]

	if !wound then return end;
	local uniqueID, legs = wound:UniqueID(), wound:IsLegs()
	
	if legs then
		if uniqueID == "bleed" then
			client:SetWalkSpeed( client:GetWalkSpeed() * (1 + 5/100) )
			client:SetRunSpeed( client:GetRunSpeed() * (1 + 5/100) )
			client:SetSlowWalkSpeed( client:GetSlowWalkSpeed() * (1 + 5/100) )
		end

		if uniqueID == "fracture" then
			client:SetWalkSpeed( client:GetWalkSpeed() * (1 + 25/100) )
			client:SetRunSpeed( client:GetRunSpeed() * (1 + 25/100) )
			client:SetSlowWalkSpeed( client:GetSlowWalkSpeed() * (1 + 25/100) )
		end

		if uniqueID == "burn" then
			client:SetWalkSpeed( client:GetWalkSpeed() * (1 + wound:GetData("damage")/100) )
			client:SetRunSpeed( client:GetRunSpeed() * (1 + wound:GetData("damage")/100) )
			client:SetSlowWalkSpeed( client:GetSlowWalkSpeed() * (1 + wound:GetData("damage")/100) )
		end
	end;
end;