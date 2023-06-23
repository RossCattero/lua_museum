AddCSLuaFile()

GlobalOpened = false;

PanelList =  
{
	'DFrame',
	'DPanel',
	'DScrollPanel',
	'DButton',
	'DCategoryList',
	'DCheckBox',
	'DCheckBoxLabel',
	'DCollapsibleCategory',
	'DColumnSheet',
	'DComboBox',
	'DHTML'
}

function BetterInclude(fileName)
	if (fileName:find("sv_") && SERVER) then
		return include(fileName)
	elseif (fileName:find("shared.lua") or fileName:find("sh_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		end
		return include(fileName)
	elseif (fileName:find("cl_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		else
			return include(fileName)
		end
	end
end

for k, v in ipairs(file.Find("autorun/derma/*.lua", "LUA")) do BetterInclude("autorun/derma/"..v) end
for k, v in ipairs(file.Find("autorun/meta/*.lua", "LUA")) do BetterInclude("autorun/meta/"..v) end
for k, v in ipairs(file.Find("autorun/libraries/*.lua", "LUA")) do BetterInclude("autorun/libraries/"..v) end


if (CLIENT) then
	netstream.Hook('OpenCreationVGUI', function()
		if !GlobalOpened then
			GlobalOpened = true;
		else
			return;
		end;
		
		local p = vgui.Create('MainCreatorPanel')
		p:Populate()
	end)
end;

hook.Add('ShowSpare2', 'SpareMe', function(player)
	
	netstream.Start(player, 'OpenCreationVGUI')
	
end);
MsgC(Color(100, 200, 100), '[СОЗДАНИЕ ИНТЕРФЕЙСА] Подключен интерфейс...' .. '\n')