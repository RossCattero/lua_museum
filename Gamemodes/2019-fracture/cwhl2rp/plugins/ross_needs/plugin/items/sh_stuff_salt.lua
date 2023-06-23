local ITEM = Clockwork.item:New();
ITEM.name = "Соль";
ITEM.model = "models/props_junk/garbage_bag001a.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "ross_salt";
ITEM.category = "Прочее";

ITEM:AddData("Uses", 12, true);

function ITEM:OnDrop(player, position) end;

if (CLIENT) then
	function ITEM:OnHUDPaintTargetID(entity, x, y, alpha)

        y = Clockwork.kernel:DrawInfo("Осталось использований: "..self:GetData("Uses").."\n", x, y, Color(120, 120, 255), alpha);

		return y;
	end;
end;

ITEM:Register();