local PLUGIN = PLUGIN;

PLUGIN.vortibeam = Clockwork.kernel:NewLibrary("Vortibeam");
vortiTable = {};

function PLUGIN.vortibeam:AddBeam(faction)
	vortiTable[#vortiTable + 1] = {
		faction = faction
	};
end;

-- PLUGIN.vortibeam:AddBeam(FACTION_EXAMPLE); // This method was reported as NOT working.

-- This attempts to make the plugin work right out of the box (if being used with this plugin: https://github.com/xRJx/vortigauntfactions). This may report errors but nothing detrimental.
PLUGIN.vortibeam:AddBeam("Vortigaunt"); -- This line was reported as working, untested though.
