local PLUGIN = PLUGIN;
local user = FindMetaTable("Player")
local ent = FindMetaTable("Entity")

function user:GetLimbs()
		return self:getLocalVar("limbs");
end

function user:GetLimb(limb)
		local limbs = self:GetLimbs();
		if !limbs then return end;
		local limbCopy = limb;

		if !limbs[limbCopy] then
				limb = nil;
				for k, v in pairs(limbs) do
						if limbCopy == v.name then
								limb = limbs[k];
								break;
						end
				end
				limbCopy = limb;
				if !limbCopy then
						return false;
				end
		else
				limb = limbs[limbCopy]
		end

		return limb && limb.amount || false;
end;

function GetLimbSituation(amount)
		local situation = {
				[100] = "Looks alright",
				[75] = "Injured a bit",
				[50] = "Damaged",
				[25] = "Heavily damaged",
		}

		for num, sit in pairs(situation) do
				if amount <= num then
						return sit;
				end
		end
end;