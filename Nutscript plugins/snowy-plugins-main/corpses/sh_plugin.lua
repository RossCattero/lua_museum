PLUGIN.name = "Looting"
PLUGIN.author = "github.com/John1344"
PLUGIN.desc = "Allows to search players corpses."
PLUGIN.corpseMaxDist = 80

-- Includes
local dir = PLUGIN.folder.."/"

nut.util.includeDir(dir.."corpses", true, true)
nut.util.include("loot/sv_hooks.lua")
nut.util.include("loot/sv_networking.lua")
nut.util.include("loot/sv_access_rules.lua")
nut.util.include("loot/cl_hooks.lua")

nut.config.add(
	"moneyDropMultuplier",
	0.1,
	"Multiplier used when money should be dropped from dead person.",
	nil,
	{
		category = "characters",
		form = "Float",
		data = {min = 0.01, max = 1}
	}
)