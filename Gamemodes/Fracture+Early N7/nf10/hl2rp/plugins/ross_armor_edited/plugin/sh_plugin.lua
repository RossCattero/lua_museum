
local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("GasMaskInfo", true);
end;

-- function PLUGIN:PaintItemTargetID(x, y, alpha, itemTable)
-- 	if itemTable:IsBasedFrom('food_base') then
-- 		local portions = itemTable:GetData("useAmount");
-- 		local canGar = itemTable.canBeGarbaged;
-- 		if portions > 0 then
-- 			y = Clockwork.kernel:DrawInfo("Количество порций: "..portions, x, y, Color(190, 150, 150), alpha);
-- 		elseif canGar && portions == 0 then
-- 			y = Clockwork.kernel:DrawInfo("Мусор.", x, y, Color(190, 150, 150), alpha);
-- 		end;
-- 	end;
-- 	if itemTable:IsBasedFrom('clothes_base') then
-- 		local one_text, one_color = itemTable:GetQuality();
-- 		local two_text, two_color = itemTable:GetArmor();
-- 		local three_text, three_color = itemTable:IsWarming();
-- 		y = Clockwork.kernel:DrawInfo("Качество одежды: "..tostring(one_text), x, y, one_color, alpha);
-- 		if (itemTable:GetData('Armor') > 0) then
-- 			y = Clockwork.kernel:DrawInfo("Качество брони: "..tostring(two_text), x, y, two_color, alpha);
-- 		end;
-- 		y = Clockwork.kernel:DrawInfo("Качество обогревания: "..tostring(three_text), x, y, three_color, alpha);
-- 		if itemTable.allowBattery then
-- 			y = Clockwork.kernel:DrawInfo("Индикатор батареи: "..tostring( self:GetData('Battery') ), x, y, Color(100, 100, 255), alpha);
-- 		end;
-- 	end;
-- end;