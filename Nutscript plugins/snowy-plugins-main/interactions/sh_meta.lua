local PLUGIN = PLUGIN;
local user = FindMetaTable("Player")

function user:IsTargetTurned(target)
		return IsValid(target) && target.GetAimVector && target:GetAimVector():DotProduct(self:GetAimVector()) > 0;
end