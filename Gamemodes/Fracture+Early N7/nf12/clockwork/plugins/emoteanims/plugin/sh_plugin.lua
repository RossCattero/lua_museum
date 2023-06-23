PLUGIN:SetGlobalAlias("cwEmoteAnims");

--[[ You don't have to do this either, but I prefer to seperate the functions. --]]
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- Called when the Clockwork shared variables are added.
function cwEmoteAnims:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Bool("StanceIdle", true);
	playerVars:Angle("StanceAng");
	playerVars:Vector("StancePos");
end;

-- A function to get whether a player is in a stance.
function cwEmoteAnims:IsPlayerInStance(player)
	return player:GetSharedVar("StancePos") != Vector(0, 0, 0);
end;

cwEmoteAnims.stanceList = {
	["d1_t03_tenements_look_out_window_idle"] = true,
	["d2_coast03_postbattle_idle02_entry"] = true,
	["d2_coast03_postbattle_idle01_entry"] = true,
	["d2_coast03_postbattle_idle02"] = true,
	["d2_coast03_postbattle_idle01"] = true,
	["d1_t03_lookoutwindow"] = true,
	["idle_to_sit_ground"] = true,
	["sit_ground_to_idle"] = true,
	["spreadwallidle"] = true,
	["apcarrestidle"] = true,
	["plazathreat2"] = true,
	["plazathreat1"] = true,
	["sit_ground"] = true,
	["lineidle04"] = true,
	["lineidle02"] = true,
	["lineidle01"] = true,
	["plazaidle4"] = true,
	["plazaidle2"] = true,
	["plazaidle1"] = true,
	["spreadwall"] = true,
	["wave_close"] = true,
	["idle_baton"] = true,
	["wave_smg1"] = true,
	["lean_back"] = true,
	["cheer1"] = true,
	["wave"] = true,
	--FIX
	--FEMALE FIX
	["LineIdle01"] = true,
	["LineIdle02"] = true,
	["LineIdle03"] = true,
	["canals_arlene_pourgas"] = true,
	["d2_coast03_PostBattle_Idle02"] = true,
	["cower_Idle"] = true,
	["base_cit_medic_postanim"] = true,
	["canals_mary_postidle"] = true,
	["canals_mary_preidle"] = true,
	["checkmalepost"] = true,
	["d1_town05_Jacobs_Heal"] = true,
	["Sit_Ground"] = true,
	["plazaidle4"] = true,
	["cheer1"] = true,
	["Wave_close"] = true,
	["Wave"] = true,
	["stopwomanpre"] = true,
	["d1_t01_Clutch_Chainlink_Idle"] = true,

	["Lying_Down"] = true,
	["d1_town05_Wounded_Idle_1"] = true,

	["d2_coast03_PostBattle_Idle01"] = true,
	["d1_t03_Tenements_Look_Out_Window_Idle"] = true,
	["Lean_Left"] = true,
	["Lean_Back"] = true,
	["plazaidle1"] = true,
	--MALE FIX
	["d1_t01_BreakRoom_WatchBreen"] = true,
	["d1_t02_Playground_Cit1_Arms_Crossed"] = true,
	["LineIdle04"] = true,
	["d1_t02_Playground_Cit2_Pockets"] = true,
	["scaredidle"] = true,
	["d2_coast03_PostBattle_Idle02"] = true,
	["cower_Idle"] = true,
	["citizen4_preaction"] = true,
	["lookoutidle"] = true,
	["d1_town05_Daniels_Kneel_Idle"] = true,
	["Sit_Ground"] = true,
	["plazaidle4"] = true,
	["cheer1"] = true,
	["cheer2"] = true,
	["Wave_close"] = true,
	["Wave"] = true,
	["luggageidle"] = true,
	["d2_coast03_Odessa_RPG_Give_Idle"] = true,

	["arrestidle"] = true,
	["d1_town05_Winston_Down"] = true,
	["d1_town05_Wounded_Idle_2"] = true,
	["injured3"] = true,
	["Lying_Down"] = true,
	["d1_town05_Wounded_Idle_1"] = true,
	["sniper_victim_pre"] = true,
	["d2_coast11_Tobias"] = true,

	["d2_coast03_PostBattle_Idle01"] = true,
	["d1_t03_Tenements_Look_Out_Window_Idle"] = true,
	["doorBracer_Closed"] = true,
	["Lean_Left"] = true,
	["Lean_Back"] = true,
	["plazaidle1"] = true,
	--CP FIX
	["stopwomanpre"] = true,
	["adoorknock"] = true,
	["idleonfire"] = true,
	["arrestpreidle"] = true,
	["harassfront2"] = true,
	["motionleft"] = true,
	["motionright"] = true,
	["plazathreat1"] = true,
	["plazathreat2"] = true,
	["shootflare"] = true,
	["Spreadwall"] = true,

	["Idle_Baton"] = true
};