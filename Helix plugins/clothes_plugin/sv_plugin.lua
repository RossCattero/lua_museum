local PLUGIN = PLUGIN;

damageTypes = {
	['Melee'] = 0,
	-- DMG_CRUSH; DMG_SLASH; DMG_CLUB; 8197; 4202501; DMG_GENERIC
	['Burn'] = 0, 
	-- DMG_BURN; DMG_SLOWBURN
	['Explosion'] = 0,
	-- DMG_BLAST; 134217792
	['Bullets'] = 0,
	--  DMG_BULLET; 4098; 536875010; DMG_BUCKSHOT; DMG_SNIPER; DMG_PLASMA
	['Acid'] = 0
	-- DMG_ACID; DMG_PARALYZE; DMG_POISON; 134348800; 
}

slotsForClothes = {
	['head'] = {},
	['gear'] = {},
	['legs'] = {},
	['arms'] = {}
}

function PLUGIN:PlayerFootstep(client, position, foot, soundName, volume)
	local footstepSound = client:GetCharacter():GetData('ModifiedFootsteps')
	
	if footstepSound != "" then
		client:EmitSound(footstepSound)
	end;
	return true
end

function PLUGIN:EntityTakeDamage( client, damage )

	if !client:IsPlayer() then return end;

	local damageType = damage:GetDamageType();
	local character = client:GetCharacter();

	if character then

		if client:Alive() then
			
			

		end;

	end;
end;

function PLUGIN:OnCharacterCreated(client, character)
	character:SetData("ModifiedFootsteps", "")
	
	character:SetData("clothesItems", slotsForClothes)
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
		client:SetLocalVar("ModifiedFootsteps", character:GetData("ModifiedFootsteps", ""))

		client:SetLocalVar("clothesItems", character:GetData("clothesItems", slotsForClothes))
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
		character:SetData("ModifiedFootsteps", client:GetLocalVar("ModifiedFootsteps", ""))
		
		character:SetData("clothesItems", client:GetLocalVar("clothesItems", slotsForClothes))
    end
end

local ply = FindMetaTable("Player")
function ply:ChangeFootsteps(str)
    local char = self:GetCharacter();

    char:SetData('ModifiedFootsteps', str);
    self:SetLocalVar('ModifiedFootsteps', str);
end;

function ply:ChangeClothes(slot, item)
	local char = self:GetCharacter();

	local tbl = char:GetData('clothesItems');
	tbl[slot] = item;

	char:SetData('clothesItems', tbl);
	self:SetLocalVar('clothesItems', tbl);
	
	PrintTable(tbl)
end;

-- function PLUGIN:EntityTakeDamage(entity, damageInfo)
--     local dt = damageInfo:GetDamageType()
    
--     if entity:IsPlayer() && !damageInfo:IsFallDamage() then
--         local protTable = entity:GetLocalVar('ProtectionTable')
--         local char = entity:GetCharacter()
--         if dt == DMG_ACID then
--             damageInfo:ScaleDamage( math.Clamp(1.5 - protTable["Токсины"]/100, 0.1, 1) )
--         end;
--         if dt == DMG_DISSOLVE or dt == DMG_SHOCK then
--             damageInfo:ScaleDamage( math.Clamp(1.5 - protTable["Электричество"]/100, 0.1, 1) )
--         end;
--         if dt == DMG_BURN then
--             damageInfo:ScaleDamage( math.Clamp(1.5 - protTable["Температура"]/100, 0.1, 1) )
--         end;
--         if dt == DMG_SLASH then
--             damageInfo:ScaleDamage( math.Clamp(1.5 - protTable["Порез"]/100, 0.1, 1) )
--         end;
--         if dt == DMG_CRUSH or dt == DMG_BULLET or dt == 4098 or dt == 536875010 or dt == DMG_BUCKSHOT or dt == DMG_SNIPER or dt == DMG_BLAST or dt == DMG_CLUB then
--             damageInfo:ScaleDamage( math.Clamp(1.5 - protTable["Гашение урона"]/100 - char:GetAttribute('endurance')/100, 0.1, 1) )
--         end;
--         local randomReduce = math.random(1, 9)/100
--         for k, v in pairs(char:GetInventory():GetItemsByBase("base_outfit")) do
--             if v:GetData('equip') then
--                 local outfits = v:GetData('outfit_info');
--                 if outfits then
--                     for name, value in pairs(outfits) do
--                         outfits[name] = math.Clamp(outfits[name] - math.Round(damageInfo:GetDamage()/10 + randomReduce, 2), 0, 1000)
--                     end;
--                     v:SetData('outfit_info', outfits)
--                 end;
--             end;
--         end;
--         for k, v in pairs(protTable) do
--             protTable[k] =  math.Clamp(protTable[k] - math.Round(damageInfo:GetDamage()/10 + randomReduce, 2), 0, 1000)
--         end;
--         entity:SetLocalVar('ProtectionTable', protTable)
--     end;
-- end;