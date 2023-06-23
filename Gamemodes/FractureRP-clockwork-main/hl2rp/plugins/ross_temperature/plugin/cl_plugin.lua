
local PLUGIN = PLUGIN;

function PLUGIN:GetPlayerInfoText(playerInfoText)
	local temp = Clockwork.Client:GetSharedVar("dTemperature")
	local dec = Clockwork.Client:GetSharedVar("Tdecrease")
	local text = '';
	local around = '';

	if temp <= 34 then
		text = "Гипотермия."
	elseif temp <= 35 then
		text = "Вам холодно!"
	elseif temp <= 36 then
		text = "Вам слегка прохладно."
	elseif temp <= 37 then
		text = 'Вы нормально себя чувствуете.'
	elseif temp <= 38 then
		text = 'Вам слегка душно.'
	elseif temp <= 39 then
		text = 'Вам жарковато.'
	elseif temp >= 40 then
		text = 'Вам жарко.'
	end;

	if dec <= -2 then
		around = 'Холодно'
	elseif dec <= -1 then
		around = 'Прохладно'
	elseif dec < 2 then
		around = 'Тепло'
	elseif dec >= 2 then
		around = "Жарко"
	end;

	playerInfoText:Add("temperature", "Состояние: "..text);
	playerInfoText:Add("tempplace", "Вокруг вас: "..around);
end;