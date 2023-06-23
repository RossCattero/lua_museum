local PLUGIN = PLUGIN;

local math = math;
local rnd = math.Round

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(0.25, function()
				client:FormClothesData()

				client.bones = client:FormBones()
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
				character:SetData("Clothes", character:GetData("Clothes"))
    end
end

function PLUGIN:PlayerSetHandsModel( ply, ent )
   ply.bones = ply:FormBones()
end

netstream.Hook('armor::TakeDownArmor', function(client, index)
		client:ArmorTakeDown(index)
end);

function PLUGIN:EntityTakeDamage(target, damage)
		if (damage:GetDamage() == 0) then return end

		local attacker = damage:GetAttacker();

		if attacker:IsWorld() || !target:IsPlayer() then return end;
		
		local trace = attacker:Tracer();
		local hitBone = self:HitBone( trace );
		local wep = attacker:GetActiveWeapon()
		
		local armor = target:HaveArmorInSlot(hitBone);
		if hitBone && armor then
				local dmgType = damage:GetDamageType();
				dmgType = self.damage[dmgType]

				local dmgAmount = damage:GetDamage();
				dmgAmount = dmgAmount > 0 && dmgAmount || wep.Primary && wep.Primary.Damage || 1;
				
				local dec = dmgAmount * ( 1 - ( (armor.level or 1 * 10) / 100) )
				target:ModifyArmorData( hitBone, rnd(dec) )

				local protection = armor.protections;
				local maxArmor = armor.armor / armor.maxArmor * 100
				protection = protection[ dmgType ];

				if protection && maxArmor > 0 then
					protection = protection * ( 1 - (maxArmor / 100) )
					local dmg = math.Round(dmgAmount * (1 - ( protection / 100) ));
					damage:SetDamage(dmg)
				end
		end
end;