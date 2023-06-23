/*
	Custom hook used for callback on wound instance only if wound owner is online;
	@realm [server]
	@argument [client] [Player object] The player object, who owns the wound.
	@argument [woundID] [number] The ID of the wound.
	@where libs/sh_wound.lua : function ix.wound.Instance
*/
hook.Add("WoundInstance", "WoundInstance", function(client, id)
	local wound = ix.wound.instances[ id ]
	local body = ix.body.instances[ client:GetCharacter():GetID() ]

	if !wound || !body then return end;
	local uniqueID = wound:UniqueID()
	
	if wound:IsLegs() then
		if uniqueID == "bleed" then
			body:SetStats( -5, -5, -5 )
		end;

		if uniqueID == "fracture" then
			body:SetStats( -25, -25, -25 )
		end

		if uniqueID == "burn" then
			body:SetStats( -wound:GetData("damage", 0), -wound:GetData("damage", 0), -wound:GetData("damage", 0) )
		end
	end;
end)

/*
	Custom hook used for callback on wound remove only if wound owner is online;
	@realm [server]
	@argument [client] [Player object] The player object, who owns the wound.
	@argument [woundID] [number] The ID of the wound.
	@where meta/sh_wound.lua : function WOUND:Remove
*/
hook.Add("PreWoundRemove", "PreWoundRemove", function(client, id)
	local wound = ix.wound.instances[ id ]
	local body = ix.body.instances[ client:GetCharacter():GetID() ]

	if !wound || !body then return end;
	local uniqueID, legs = wound:UniqueID()
	
	if wound:IsLegs() then
		if uniqueID == "bleed" then
			body:SetStats( 5, 5, 5 )
		end;

		if uniqueID == "fracture" then
			body:SetStats( 25, 25, 25 )
		end

		if uniqueID == "burn" then
			body:SetStats( wound:GetData("damage", 0), wound:GetData("damage", 0), wound:GetData("damage", 0) )
		end
	end;
end);