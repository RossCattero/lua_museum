
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Float("toxins", true);
end;

if (SERVER) then
	PLUGIN.gasTickTime = 2;
else
	PLUGIN.gasTickTime = 1;
end;

PLUGIN.clientside = true;

Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");

function PLUGIN:RegisterZones()
	Schema:RegisterZone("GasZone", "Газовая зона", PLUGIN.gasTickTime,
		{bUseExclusionAreas = true, bZoneScale = true, bIsClientSide = PLUGIN.clientside,
		bShared = PLUGIN.clientside, bSharedVar = false, bPlayerOnly = false,
		funcOnTick = PLUGIN.OnGasTick, funcOnChange = PLUGIN.OnGasChange, funcShouldCheck = PLUGIN.ShouldCheckGas,
		areaColor = Color(255, 0, 0), exclusionColor = Color(0, 255, 0)});
end;

function PLUGIN.ShouldCheckGas(player, id)
	if (Schema:PlayerIsCombine(player) && player:GetSharedVar("GasMaskInfo") > 0) then
		return false;
	end;
end;