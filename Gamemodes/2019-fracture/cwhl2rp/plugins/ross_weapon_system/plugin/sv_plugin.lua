
local PLUGIN = PLUGIN;
local p = FindMetaTable("Player");
local math = math;
local cl = math.Clamp;

function p:HoldingTFAweapon()

	if Schema:IsPlayerCombineRank(self, "SCN") || self:IsRagdolled() then return false end;

	local wep = self:GetActiveWeapon():GetClass()

	if string.StartWith( wep, "tfa_" ) then
		return true;
	end;

	return false;
end;

function IsWeaponAssault(weapon)
	local weapons = {
	"tfa_ins2_akm",
	"tfa_ins2_ak12",
	"tfa_ins2_makm",
	"tfa_ins2_akz",
	"tfa_ins2_aks74u",
	"tfa_ins2_asval",
	"tfa_ins2_fort500",
	"tfa_ins2_g36c",
	"tfa_ins2_sai_gry",
	"tfa_ins2_gol",
	"tfa_ins2_galil",
	"tfa_ins2_uzi",
	"tfa_ins2_k98",
	"tfa_ins2_krissv",
	"tfa_ins2_mk18",
	"tfa_ins2_mosin",
	"tfa_ins2_mp5k",
	"tfa_ins2_mp7",
	"tfa_ins2_pkp",
	"tfa_ins2_rpk",
	"tfa_ins2_scarl",
	"tfa_ins2_sc_evo",
	"tfa_ins2_svd",
	"tfa_ins2_svt40"
	};
	for k, v in pairs(weapons) do
		if v == weapon then
			return true;
		end;
	end;

return false;
end;

function IsWeaponShotgun(weapon)
	local weapons = {
	"tfa_ins2_doublebarrel",
	"tfa_ins2_spas12"
	};

	for k, v in pairs(weapons) do
		if v == weapon then
			return true;
		end;
	end;

return false;	
end;

function IsWeaponPistol(weapon)
	local weapons = {
	"tfa_ins2_usp_match",
   	"tfa_ins2_tt33",
   	"tfa_ins2_p226",
   	"tfa_ins2_pm",
  	"tfa_ins2_p220",
   	"tfa_ins2_deagle",
   	"tfa_ins2_fiveseven",
   	"tfa_ins2_thanez_cobra"
	};

	for k, v in pairs(weapons) do
		if v == weapon then
			return true;
		end;
	end;

return false;	
end;

function IsWeaponMelee(weapon)
	local weapons = {
	"tfa_nmrih_bat",
	"tfa_nmrih_bcd",
	"tfa_nmrih_cleaver",
	"tfa_nmrih_crowbar",
	"tfa_nmrih_etool",
	"tfa_nmrih_fireaxe",
	"tfa_nmrih_hatchet",
	"tfa_nmrih_kknife",
	"tfa_nmrih_lpipe",
	"tfa_nmrih_machete",
	"tfa_nmrih_spade"
	};

	for k, v in pairs(weapons) do
		if v == weapon then
			return true;
		end;
	end;

return false;	
end;

function PLUGIN:EntityFireBullets(entity, bulletInfo) 
	local random = math.random(0, 110)
	if (entity:IsPlayer() && entity:IsValid()) then

		entity = entity:GetActiveWeapon();
		local wep = Clockwork.item:GetByWeapon(entity);
		local dat = wep:GetData("Quality");
	
		if wep && random > 90 then
	
			wep:SetData("Quality", cl(dat - 0.1, 0, 10));
	
		end;
	end;
end;

-- Адаптация для ТФА.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	local weapon = player:GetActiveWeapon();

	if player:Alive() then
		if player:HoldingTFAweapon() && weapon:IsSafety() then
			Clockwork.player:SetWeaponRaised(player, false)
		elseif player:HoldingTFAweapon() && !weapon:IsSafety() then
			Clockwork.player:SetWeaponRaised(player, true)
		end;
	end;

    if (player:GetVelocity():Length() > 0) then
    	Clockwork.player:SetAction(player, "Unload", false);
    	
    	return;
	end;
	
	if (player.reloadCoolDown) then
		if (!player.reloadCoolDownN || curTime >= player.reloadCoolDownN) then
			player.reloadCoolDown = false;
			player.reloadCoolDownN = curTime + 3
		end;
  end;

end;

function PLUGIN:KeyPress(player, key)
	local weaponact = player:GetActiveWeapon();
	local items = Clockwork.inventory:GetAsItemsList(player:GetInventory());
	local pInvWeight = player:GetInventoryWeight();
	local pMaxWeight = player:GetMaxWeight();

	if (key == IN_RELOAD) && weaponact && player:HoldingTFAweapon() then
		if player.reloadCoolDown || !IsValid(weaponact) || !player:HoldingTFAweapon() then
			Clockwork.player:PlaySound(player, "player/suit_denydevice.wav")
			return;
		end;
		local ammocount = player:GetAmmoCount( weaponact.Primary.Ammo );
		local weapon = Clockwork.item:GetByWeapon(weaponact);
		
		if !weapon:GetData("Mag") && !player.reloadCoolDown then	
			for k, v in pairs(items) do
				if v("baseItem") == "mag_base" && table.HasValue(v("WeaponsCanUse"), weaponact:GetClass()) then
					Clockwork.item:Use(player, v, false)
				end;
			end;
			player.reloadCoolDown = true

		elseif weapon:GetData("Mag") && !player.reloadCoolDown && player:KeyDownLast( IN_SPEED ) && player:HoldingTFAweapon() then

			if (weapon:GetData("Mag") && pInvWeight + Clockwork.item:FindByID(weapon:GetData("NameMag")).weight <= pMaxWeight) then
				if weapon:GetData("ClipOne") >= 0 then
					player:GiveItem( Clockwork.item:CreateInstance(weapon:GetData("NameMag"), nil, {Clip = weapon:GetData("ClipOne")}) );
					player:RemoveAmmo(weapon:GetData("ClipOne"), weaponact.Primary.Ammo);
					weapon:SetData("ClipOne", 0);
					weaponact:SetClip1( 0 );
					weapon:SetData("Mag", false);
					weapon:SetData("NameMag", "");
				elseif ammocount >= 0 then
					player:GiveItem( Clockwork.item:CreateInstance(weapon:GetData("NameMag"), nil, {Clip = ammocount}) );
					player:RemoveAmmo(ammocount, weaponact.Primary.Ammo);					
					weapon:SetData("ClipTwo", 0);
					weaponact:SetClip2( 0 );
					weapon:SetData("Mag", false);
					weapon:SetData("NameMag", "");
				elseif pInvWeight + Clockwork.item:FindByID(weapon:GetData("NameMag")).weight > pMaxWeight then
					Clockwork.chatBox:SendColored(player, Color(255, 0, 0), "У вас недостаточно места в инвентаре!")
				else
					Clockwork.chatBox:SendColored(player, Color(255, 0, 0), "Это оружие не валидно!")
					return false;
				end;
			end;
			player:EmitSound("items/ammopickup.wav")
			player.reloadCoolDown = true
		end;
	end;
	
end;