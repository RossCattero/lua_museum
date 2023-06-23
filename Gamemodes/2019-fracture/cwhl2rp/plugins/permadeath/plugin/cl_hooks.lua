--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

local PLUGIN = PLUGIN;

function PLUGIN:GetScreenTextInfo()
	local blackFadeAlpha = Clockwork.kernel:GetBlackFadeAlpha();
	
	if (Clockwork.Client:GetSharedVar("permakilled")) then
		return {
			alpha = blackFadeAlpha,
			title = "ЭТОТ ПЕРСОНАЖ МЕРТВ",
			text = "Создайте нового персонажа."
		};
	end;
end;