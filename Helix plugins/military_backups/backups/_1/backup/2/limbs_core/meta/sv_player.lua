local PLAYER = FindMetaTable("Player")

function PLAYER:GetBIO()
	return self:GetCharacter():GetData( "Bio" )
end;

function PLAYER:GetLimbs()
	return self:GetCharacter():GetData( "Limbs" )
end;

function PLAYER:Injury( bone, damage )
	if !self:Alive() then return end;

	local limbs, bio, charID = self:GetLimbs(), self:GetBIO(), self:GetCharacter():GetID()
	local dmgType, dmg = damage:GetDamageType(), 
	damage:GetDamage() * (LIMBS.DAMAGE_MUL > 0 && (1 + (LIMBS.DAMAGE_MUL / 100)) || 1)

	INJURIES.INDEX = INJURIES.INDEX + 1;

	local bleed, injury = math.Round(dmg * ( LIMBS.CAUSE_BLEED / 100 )), INJURIES.Get( dmgType )
	local Wound = INJURIES.New( dmgType, INJURIES.INDEX, charID )
	Wound:SetData( "stage", INJURIES.FindStage( dmg ) )
	Wound:SetData( "bleed", injury.causeBleeding && bleed )
	Wound:SetData( "expire", os.time() + injury.woundTime )
	Wound:SetData( "bone", bone )
	
	netstream.Start(self, "NETWORK_INJURY_INSTANCE", dmgType, Wound:GetID(), Wound.data)

	table.insert( limbs[ bone ], Wound:GetID() );

	self:SetHurt( 
		dmg * ( injury.damagePercent/100 ) + #limbs[ bone ] * LIMBS.DAMAGE_MORE, 
		LIMBS.MIN_HURT 
	)

	if injury.causeBleeding then
		self:Blood( nil, bleed )
	end

	self:SetLocalVar("Limbs", limbs)
	self:SetLocalVar("Bio", bio)

	hook.Run( "OnLimbDamaged", self, Wound, dmg )

	self:LimbDamagedCallback()
end

function PLAYER:ResetInjuries(db, instances, id)

	if instances then
		netstream.Start(self, "NETWORK_INJURY_INSTANCE", nil)

		for k, v in pairs( INJURIES.INSTANCES ) do
			if v.charID == id then
				INJURIES.INSTANCES[k] = nil;
			end
		end
	end

	if id && db then
		local query = mysql:Delete("inj_list")
			query:Where("charID", id)
		query:Execute()
	end;
end;

function PLAYER:RemoveInjByID(id)
	local limbs = self:GetLimbs()

	for k, v in ipairs(limbs) do
		if v == id then
			limbs[k] = nil;
			self:SortInjuries(table.Copy(limbs))
			return;
		end
	end
end;

function PLAYER:SortInjuries(limbs)
	local i = 0;
	local buffer = {}

	for k, v in pairs(limbs) do
		i = i + 1;

		buffer[i] = v;
	end

	self:SetLocalVar("Limbs", buffer)
end;