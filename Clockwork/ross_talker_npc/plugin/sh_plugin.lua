
local PLUGIN = PLUGIN;

function table.Compare( a, b )
	table.sort(a)
	table.sort(b)
 
	for k, v in pairs( a ) do
		if ( type(v) == "table" && type(b[k]) == "table" ) then
			if ( !table.Compare( v, b[k] ) ) then
				return false
			end;
		elseif ( v != b[k] ) then
			return false
		end;
	end;

	for k, v in pairs( b ) do
		if ( type(v) == "table" && type(a[k]) == "table" ) then
			if ( !table.Compare( v, a[k] ) ) then 
				return false 
			end;
		elseif ( v != a[k] ) then 
			return false 
		end;
	end;

	return true 
end;

function cutUpText(text, len)
	local textlen = utf8.len(text)
	if textlen > len then
	  return utf8.sub(text, 1, len).."-\n"..utf8.sub(text, len)
	end;

	return text;
end;

function cutDownText(str, max)
	if str == "" || !isnumber(max) then
		return;
	end;

	local max = tonumber(max)

	local len = utf8.len(str);
	if len > max then
		return utf8.sub(str, 1, max).."..."
	else
		return str;
	end;
end;

function playerCanTakeQuest(tbl, index)
	local b = {}
	for k, v in pairs(tbl) do
		table.insert(b, v.sellerInfo.id)
	end;

	if table.HasValue(b, tonumber(index)) && table.Count(tbl) > 0 then
		return false;
	else
		return true;
	end;
end;

function PlayerhasQuest(tbl, index)
	local b = {}
	for k, v in pairs(tbl) do
		table.insert(b, v.sellerInfo.id)
	end;

	if table.HasValue(b, tonumber(index)) && table.Count(tbl) > 0 then
		return true;
	else
		return false;
	end;
end;

function contractIsDone(quest, inventory, npctbl)
	local tableCounter = {}

	if quest.type == "Сбор предметов" then

		for k, v in pairs(inventory) do
			if quest.amount[v.uniqueID] then
				if !tableCounter[v.uniqueID] then
					tableCounter[v.uniqueID] = 1
				else
					tableCounter[v.uniqueID] = tableCounter[v.uniqueID] + 1
				end;
			end;
		end;

	elseif quest.type == "Убийство НПС" then

		for k, v in pairs(npctbl) do
			tableCounter[k] = v;
		end;

	end;

	table.sort(tableCounter)
	table.sort(quest.amount)

	for k, v in pairs(quest.amount) do
		if !tableCounter[k] || tableCounter[k] < v then
			return false;
		end;
	end;

	if table.Compare( tableCounter, quest.amount ) then
		return true;
	end;

	return false;
end;

function GetQuestID(quests, id)

	for k, v in pairs(quests) do
		if v.sellerInfo.id == id then
			return k;
		end;
	end;

end;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");