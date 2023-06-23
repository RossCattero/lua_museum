
local PLUGIN = PLUGIN;

surface.CreateFont( "Needs", {
	font = "Arial",
	extended = false,
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
});

local CW_CONVAR_HUNNOT = Clockwork.kernel:CreateClientConVar("cwHunNotify", 0, true, true);
local CW_CONVAR_HUNNOTCENTER = Clockwork.kernel:CreateClientConVar("cwHunNotCenter", 0, true, true);

Clockwork.setting:AddNumberSlider("Потребности", "Hunger Notification", "cwHunNotify", 1, 120, 1, "Удаление уведомления о голоде.");
Clockwork.setting:AddCheckBox("Потребности", "Уведомление о голоде по центру", "cwHunNotCenter", "Добавить уведомление по центру.");

function PLUGIN:PlayerBindPress(player, bind, bPress)
	local action, percentage = Clockwork.player:GetAction(player, true);

	if (string.find(bind, "+forward") || string.find(bind, "+moveright") || string.find(bind, "+moveleft") || string.find(bind, "+back") || string.find(bind, "+jump")) && player:GetSharedVar("StartingSleep") then
		return true;
	end;

end;

function PLUGIN:GetProgressBarInfo()
	local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);

	if (!Clockwork.Client:IsRagdolled()) then
		if (action == "BagMeUp") then
			return {text = "Разворачивается мешок...", percentage = percentage, flash = percentage < 10};
		end;

		if (action == "PickingUpItem") then
			return {text = "", percentage = percentage, flash = percentage < 10};
		end;
	end;

end;

function PLUGIN:GetEntityMenuOptions(entity, options)
	local ec = entity:GetClass();

	if (entity:GetClass() == "prop_physics" && entity:GetNWBool("SleepBag") == true) then
		options["Запаковать спальный мешок"] = "pack_sleepbag"
	end;

end;

local time = 600;


function PLUGIN:HUDPaint()
	local player = Clockwork.Client;
	local info = { x = ScrW() - 1900, y = 390 };

	local hunger = player:GetSharedVar("hunger");
	local thirst = player:GetSharedVar("thirst");
	local sleep = player:GetSharedVar("sleep");
	local clean = player:GetSharedVar("clean");

	if CW_CONVAR_HUNNOT:GetInt() > 0 then
		time = CW_CONVAR_HUNNOT:GetInt()
	else
		time = 10;
	end;
	
	if (Schema:PlayerIsCombine(player) && player:GetSharedVar("GasMaskInfo") == 2) then
		local lvlhealth = "---"
		local defaultColor = {
			r = 100, 
			g = 100, 
			b = 100, 
			a = 128
		};
		if player:Health() <= 25 then
			lvlhealth = "КРИТИЧЕСКИЙ УРОВЕНЬ ЗДОРОВЬЯ!"
			defaultColor.r = 192
			defaultColor.g = 53
			defaultColor.b = 41
		elseif player:Health() <= 50 then
			lvlhealth = "Низкий уровень здоровья!"
			defaultColor.r = 217
			defaultColor.g = 126
			defaultColor.b = 17
		elseif player:Health() <= 75 then
			lvlhealth = "Получен урон."
			defaultColor.r = 218
			defaultColor.g = 213
			defaultColor.b = 16
		elseif player:Health() <= 100 then
			lvlhealth = "Здоровье в норме..."
			defaultColor.r = 71
			defaultColor.g = 218
			defaultColor.b = 16
		end;		
		surface.SetDrawColor( 0, 0, 0, 128 )
		surface.DrawRect( info.x, info.y, 300, 74 )

		surface.SetDrawColor( defaultColor.r, defaultColor.g, defaultColor.b, defaultColor.a )
		surface.DrawRect( info.x + 10, info.y + 10, 310, 54 )

		surface.SetFont( "Default" )
		surface.SetTextColor( 255, 255, 255 )
		surface.SetTextPos( info.x + 20, info.y + 30 )
		surface.DrawText( "Уровень здоровья: "..lvlhealth )
	end;

	if CW_CONVAR_HUNNOTCENTER:GetInt() == 1 then

	if (hunger == 25) then
		Clockwork.kernel:AddCenterHint("У вас урчит в животе... ", time, Color(71, 218, 16), true, false)
	elseif (hunger == 50) then
		Clockwork.kernel:AddCenterHint("Вам слегка хочется есть...", 5 + time, Color(218, 213, 16), true, false)
	elseif (hunger == 75) then
		Clockwork.kernel:AddCenterHint("Вы голодны.", 5 + time, Color(217, 126, 17), true, false)
	elseif (hunger == 90) then
		Clockwork.kernel:AddCenterHint("Вы умираете с голоду!", 5 + time, Color(192, 53, 41), true, false)			
	end;

	if (thirst == 25) then
		Clockwork.kernel:AddCenterHint("Вам хочется пить.", time, Color(71, 218, 16), true, false)
	elseif (thirst == 50) then
		Clockwork.kernel:AddCenterHint("Вам нужно смочить горло.", time, Color(218, 213, 16), true, false)
	elseif (thirst == 75) then
		Clockwork.kernel:AddCenterHint("Вы чувствуете, что сильно хотите пить.", time, Color(217, 126, 17), true, false)
	elseif (thirst == 90) then
		Clockwork.kernel:AddCenterHint("У вас жажда!", time, Color(192, 53, 41), true, false)			
	end;

	if (sleep == 25) then
		Clockwork.kernel:AddCenterHint("Вы устали.", time, Color(71, 218, 16), true, false)
	elseif (sleep == 50) then
		Clockwork.kernel:AddCenterHint("Вы чувствуете ломку в мышцах.", time, Color(218, 213, 16), true, false)
	elseif (sleep == 75) then
		Clockwork.kernel:AddCenterHint("Вы не можете стоять на ногах.", time, Color(217, 126, 17), true, false)
	elseif (sleep == 90) then
		Clockwork.kernel:AddCenterHint("Вы обезвожены", time, Color(192, 53, 41), true, false)			
	end;

	if (clean == 25) then
		Clockwork.kernel:AddCenterHint("Вы плохо пахнете.", time, Color(71, 218, 16), true, false)
	elseif (clean == 50) then
		Clockwork.kernel:AddCenterHint("Вы ужасно пахнете.", time, Color(218, 213, 16), true, false)
	elseif (clean == 75) then
		Clockwork.kernel:AddCenterHint("Вам становится сложно передвигаться.", time, Color(217, 126, 17), true, false)
	elseif (clean == 90) then
		Clockwork.kernel:AddCenterHint("От вас жутко пахнет.", time, Color(192, 53, 41), true, false)			
	end;

	end;

end;

function PLUGIN:GetPlayerInfoText(playerInfoText)
	local player = Clockwork.Client;

	local hunger = player:GetSharedVar("hunger");
	local thirst = player:GetSharedVar("thirst");
	local sleep = player:GetSharedVar("sleep");
	local clean = player:GetSharedVar("clean");

	local hungerText = "---";
	local thirstText = "---";
	local sleepText = "---";
	local cleanText = "---";

	if hunger >= 0 then
		hungerText = "Вы сыты."
	elseif hunger >= 25 then
		hungerText = "У вас урчит в животе."
	elseif hunger >= 50 then
		hungerText = "Вы голодны."
	elseif hunger >= 75 then
		hungerText = "Вы умираете с голоду!"
	end;
	if thirst >= 0 then
		thirstText = "Вы не хотите пить."
	elseif thirst >= 25 then
		thirstText = "Вам хочется пить."
	elseif thirst >= 50 then
		thirstText = "Вы чувствуете, что сильно хотите пить."
	elseif thirst >= 75 then
		thirstText = "У вас жажда."
	end;
	if sleep >= 0 then
		sleepText = "Вы не устали."
	elseif sleep >= 25 then
		sleepText = "Вы чувствуете себя уставшим."
	elseif sleep >= 50 then
		sleepText = "Вы чувствуете ломку в мышцах."
	elseif sleep >= 75 then
		sleepText = "Вы не можете стоять на ногах."
	end;
	if clean >= 0 then
		cleanText = "Вы нормально пахнете."
	elseif clean >= 25 then
		cleanText = "Вы слегка чувствуете неприятный запах."
	elseif clean >= 50 then
		cleanText = "Вы сильнее чувствуете плохой запах."
	elseif clean >= 75 then
		cleanText = "Вам становится сложно передвигаться."
	end;

	playerInfoText:Add("hunger", "Голод: "..hungerText);
	playerInfoText:Add("thirst", "Жажда: "..thirstText);
	playerInfoText:Add("sleep", "Усталость: "..sleepText);
	playerInfoText:Add("clean", "Чистота: "..cleanText);
end;