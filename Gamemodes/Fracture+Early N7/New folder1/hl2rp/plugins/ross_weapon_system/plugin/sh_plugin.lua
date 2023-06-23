
local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

function IsWeaponAssault(weapon)
	local weapons = {
	"tfa_ins2_akm",
	"tfa_ins2_ak12",
	"tfa_ins2_makm",
	"tfa_ins2_akz",
	"tfa_ins2_aks74u",
	"tfa_ins2_asval", -- 1
	"tfa_ins2_g36c",
	"tfa_ins2_sai_gry", -- 1
	"tfa_ins2_gol", -- 3
	"tfa_ins2_galil",
	"tfa_ins2_uzi", -- 1
	"tfa_ins2_k98", -- 3
	"tfa_ins2_krissv", -- 1
	"tfa_ins2_mk18",
	"tfa_ins2_mosin", -- 3
	"tfa_ins2_mp5k", -- 1
	"tfa_ins2_mp7", -- 1
	"tfa_ins2_pkp",
	"tfa_ins2_rpk",
	"tfa_ins2_scarl",
	"tfa_ins2_sc_evo",
	"tfa_ins2_svd", -- 3
	"tfa_ins2_svt40", -- 3
	'tfa_ins2_famas'
	};
	if table.HasValue(weapons, weapon) then
		return true;
	end;

	return false;
end;

function IsWeaponShotgun(weapon)
	local weapons = {
	"tfa_ins2_doublebarrel",
	"tfa_ins2_spas12",
	"tfa_ins2_fort500"
	};

	if table.HasValue(weapons, weapon) then
		return true;
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

	if table.HasValue(weapons, weapon) then
		return true;
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
	"tfa_nmrih_spade",
	'cw_stunstick'
	};

	if table.HasValue(weapons, weapon) then
		return true;
	end;

	return false;	
end;

function IsWeaponVort(weapon)
	local weapons = {
	'cw_vortibeam'
	};

	if table.HasValue(weapons, weapon) then
		return true;
	end;

	return false;	
end;

function HoldingTFAweapon(p)

	if Schema:IsPlayerCombineRank(p, "SCN") || p:IsRagdolled() then return false end;

	local wep = p:GetActiveWeapon():GetClass()

	if string.StartWith( wep, "tfa_" ) then
		return true;
	end;

	return false;
end;

function GetWeaponTFAtype(weapon)
	local wepType = "#ERR#"
	if IsWeaponMelee(weapon) then
		wepType = 'melee'
	elseif IsWeaponPistol(weapon) then
		wepType = 'pistol'
	elseif IsWeaponShotgun(weapon) then
		wepType = 'shotgun'
	elseif IsWeaponAssault(weapon) then
		wepType = 'assault'
	elseif IsWeaponVort(weapon) then
		wepType = 'vorti'
	end;

	return wepType;
end;

local function GetClientSideInfo(itemTable)
	local clientSideInfo = "";
	local ic = itemTable.category
	local cond = itemTable:GetData("Quality")
	local text = ""
	local condcol = Color(255, 255, 255)
	local hasMagaizne = itemTable:GetData("Mag");

	if (cond) then
		if cond >= 9 then
			text = "В хорошем состоянии.";
			condcol = Color(10, 210, 0);
		elseif cond >= 6 then
			text = "В нормальном состоянии.";
			condcol = Color(70, 190, 0);
		elseif cond >= 3 then
			text = "В поношеном состоянии.";
			condcol = Color(170, 100, 0);		
		elseif cond < 3 then
			text = "Изношено.";
			condcol = Color(200, 60, 0);
		end;
	end;
	if !IsWeaponMelee(itemTable.uniqueID) then

		if hasMagaizne then
			text2 = "Есть магазин"
			clr = Color(0, 255, 0);
		elseif !hasMagaizne then
			text2 = "Нет магазина"
			clr = Color(200, 0, 0)
		end;
	elseif IsWeaponMelee(itemTable.uniqueID) then
		text2 = "Холодное оружие"
		clr = Color(200, 200, 200)
	end;
	clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Цена: "..itemTable:GetData("PriceForSalesman")..".", Color(255, 100, 100));
	if ((ic == "Weapons" or ic == "Оружие") && itemTable.uniqueID != 'cw_suitcase') then

		clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, text, condcol);
		clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, text2, clr);

	return (clientSideInfo != "" and clientSideInfo);

	end;	
end;

-- Called when a Clockwork item has initialized.
function PLUGIN:ClockworkItemInitialized(itemTable)
	local ic = itemTable.category;
	local id = itemTable.uniqueID;
		if (itemTable.GetClientSideInfo) then
			itemTable.OldGetClientSideInfo = itemTable.GetClientSideInfo;
			itemTable.NewGetClientSideInfo = GetClientSideInfo;
			itemTable.GetClientSideInfo = function(itemTable)
				local existingText = itemTable:OldGetClientSideInfo();
				local additionText = itemTable:NewGetClientSideInfo() or "";
				local totalText = (existingText and existingText.."" or "")..additionText;
				
				return (totalText != "" and totalText);
			end;
		else
			itemTable.GetClientSideInfo = GetClientSideInfo;
		end;
	if (ic == "Weapons" or ic == "Оружие") then
		itemTable:AddData("Quality", 10, true);
		itemTable:AddData('FlashLight', false, true);
		if IsWeaponMelee(itemTable.uniqueID) == false then
			itemTable:AddData("Mag", false, true);
			itemTable:AddData("NameMag", "", true);
		end;

		-- Винтовки.
		if id == "tfa_ins2_aks74u" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_ak12" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_akm" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_makm" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_akz" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_asval" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_c7e_redux" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_famas" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_g36c" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_galil" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_gol" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_sai_gry" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_k98" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_krissv" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_mk18" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_mosin" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_mp5k" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_mp7" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_pkp" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_rpk" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_scarl" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_sc_evo" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_svd" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_svt40" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_uzi" then
			itemTable:AddData("RollDamage", 2, true);

			-- Пистолеты
		elseif id == "tfa_ins2_deagle" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_fiveseven" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_usp_match" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_thanez_cobra" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_p220" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_p226" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_pm" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_tt33" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_usp45" then
			itemTable:AddData("RollDamage", 2, true);

			-- Дробовики.
		elseif id == "tfa_ins2_doublebarrel" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_fort500" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_spas12" then
			itemTable:AddData("RollDamage", 3, true);

			-- Холодное оружие.
		elseif id == "tfa_nmrih_cleaver" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_nmrih_etool" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_nmrih_fireaxe" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_nmrih_crowbar" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_nmrih_bcd" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_nmrih_machete" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_nmrih_bat" then
			itemTable:AddData("RollDamage", 2, true);
		
		elseif id == "cw_stunstick" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == 'cw_suitcase' || id == "weapon_frag" || id == "weapon_base" || id == "cw_smokegrenade" || id == "grenade_base" || id == 'cw_flashgrenade' then
			itemTable:AddData("RollDamage", 1, true);

		end;
	end;

end;