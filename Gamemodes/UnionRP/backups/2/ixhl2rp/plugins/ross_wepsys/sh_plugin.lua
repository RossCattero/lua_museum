local PLUGIN = PLUGIN

PLUGIN.name = "Weapon adaptaion & more"
PLUGIN.author = "Ross"
PLUGIN.description = ""

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")

function IsWeaponTFA(weapon)
    return IsValid(weapon) && tobool(weapon:IsTFA())
end;
function IsWeaponAssault(weapon)
	local weapons = {
	"tfa_ins2_akm",
	"tfa_ins2_ak12",
	"tfa_ins2_eftm4a1",
	"tfa_ins2_makm",
	
	"tfa_ins2_akz",
	"tfa_ins2_aks74u",
	"tfa_ins2_groza",
	"tfa_ins2_asval",
	"tfa_ins2_g36c",
	"tfa_ins2_galil",
	
	"tfa_ins2_mk18",
	"tfa_ins2_pkp",
	"tfa_ins2_rpk",
	"tfa_ins2_scarl",
	
	
	'tfa_ins2_famas',
	"tfa_ins2_ak74m",
	"tfa_ins2_cw_ar15",
	"tfa_ins2_akm_bw"
	};

	return table.HasValue(weapons, weapon)
end;

function IsWeaponSubmachine(weapon)
	local weapons = {
		"tfa_ins2_uzi",
		"tfa_ins2_mp5k",
		"tfa_ins2_ump45",
		"tfa_ins2_mp7",
		"tfa_ins2_sc_evo",
		"tfa_ins2_krissv"
	}
	return table.HasValue(weapons, weapon)
end;

function IsWeaponBoltAction(weapon)
	local weapons = {
		"tfa_ins2_gol",
		"tfa_ins2_k98",
		"tfa_ins2_mosin",
		"tfa_ins2_svt40",
		"tfa_ins2_svd",
		"tfa_ins2_sks",
		"tfa_nam_svd"
	}
	return table.HasValue(weapons, weapon)
end;

function IsWeaponRevolver(weapon)

	return weapon == "tfa_ins2_thanez_cobra"
end;

function IsWeaponShotgun(weapon)
	local weapons = {
	"tfa_ins2_doublebarrel",
	"tfa_nam_stevens620",
	"tfa_ins2_spas12",
	"tfa_ins2_fort500",
	"tfa_ins2_nova"
	};
	return table.HasValue(weapons, weapon);	
end;

function IsWeaponPistol(weapon)
	local weapons = {
	"tfa_ins2_usp_match",
   	"tfa_ins2_tt33",
   	"tfa_ins2_p226",
   	"tfa_ins2_pm",
	"tfa_ins2_p220",
	'tfa_ins2_usp45',  
	"tfa_ins2_glock_19",
   	"tfa_ins2_deagle",
   	"tfa_ins2_fiveseven"
	};
	return table.HasValue(weapons, weapon) 	
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
	'tfa_ins2_kabar'
	};
	return table.HasValue(weapons, weapon)
end;
function GetWeaponTFAtype(weapon)
	local wepType = "#ERR#"
	if IsWeaponMelee(weapon) then
		wepType = 'melee'
	elseif IsWeaponPistol(weapon) or IsWeaponRevolver(weapon) then
		wepType = 'pistol'
	elseif IsWeaponShotgun(weapon) then
		wepType = 'shotgun'
	elseif IsWeaponAssault(weapon) then
		wepType = 'assault'
	elseif IsWeaponBoltAction(weapon) then
		wepType = "bolt_sniper"
	elseif IsWeaponSubmachine(weapon) then
		wepType = "submachine"
	end;

	return wepType;
end;