local PLUGIN = PLUGIN;

netstream.Hook('charList::sendChanges', function(client, data)
	if !client:IsAdmin() || !client:IsSuperAdmin() then return end; -- Сделать CAMI

	local id = tonumber(data["id"])
	local char = nut.char.loaded[id]
	nut.db.updateTable({
		_name = data["name"],
		_desc = data["desc"],
		_model = data["model"]
	}, nil, "characters", "_id = "..id)

	local charData;
	local schema = SCHEMA.folder
	nut.db.query("SELECT _data FROM nut_players WHERE _steamID = " .. data["steamID"], function(info)
			charData = util.JSONToTable(info[1]["_data"] or "[]");
			if charData["whitelists"] && charData["whitelists"][schema] then
					for k, v in pairs(data["factions"]) do
							charData["whitelists"][schema][k] = tobool(v);
					end
			end
			nut.db.updateTable({
				_data = util.TableToJSON(charData)
			}, nil, "players", "_steamID = "..data["steamID"])
	end);

	if char then
			char:setName(data["name"])
			char:setDesc(data["desc"])

			local user = char:getPlayer();
			local userChar = user:getChar();

			if char == userChar then
					user:SetModel(data["model"])
					user:SetSkin(data["skin"])
					for k, v in pairs(data['bodygroups']) do
							user:SetBodygroup(k, v)
					end
			end
			local facs = {}
			for k, v in pairs(nut.faction.teams) do
					facs[k:lower()] = v;
			end
			for k, v in pairs(data["factions"]) do
					local teamS = facs[k]
					if !teamS || teamS && teamS.isDefault then continue end;
					user:setWhitelisted(teamS.index, tobool(v))

					if teamS.index == userChar:getFaction() then
							userChar:kick()
					end
			end
		end
		
		client:notify("Data of the player successfully changed!")
		netstream.Start(nil, 'charList::updateListData', PLUGIN:CollectCharacterData())
end);

netstream.Hook('charList::action', function(client, id, bool)
		if !client:IsAdmin() || !client:IsSuperAdmin() then return end; -- Сделать CAMI
		
		id = tonumber(id)
		local char = nut.char.loaded[id]
		nut.db.query("SELECT _data FROM nut_characters WHERE _id = "..id, function(data)
				if data[1]["_data"] then
					local subData = util.JSONToTable(data[1]["_data"] or "[]")
					if !subData then subData = {} end;
					subData["banned"] = bool;
					subData["bannedBy"] = bool && client:Name() || nil;

					nut.db.updateTable({
							_data = util.TableToJSON(subData)
					}, nil, "characters", "_id = "..id);
				end

				if char == char:getPlayer():getChar() && bool then
						char:ban(nil, client:Name())
				end
		end);

	
		local what = (bool && "banned" || "unbanned");
		client:notify("Character is " .. what .. ".")
		netstream.Start(nil, 'charList::updateListData', PLUGIN:CollectCharacterData())
end);

// Reading and collecting the character data;
function PLUGIN:CollectCharacterData()
		local charData = {};
		nut.db.query("SELECT * FROM nut_characters WHERE _schema = '"..SCHEMA.name:lower().."'", function(data)
				if data then
					for k, v in ipairs(data) do
						local subData = util.JSONToTable(v._data or "[]");
						local user = player.GetBySteamID64( v._steamID );
						user = user:IsValid() && user || false;
						nut.db.query("SELECT _steamName, _data from nut_players WHERE _steamID = " .. v._steamID, function(data)
								steamName = data && data[1]["_steamName"];
						end)
						
						charData[#charData + 1] = {
								[1] = v._id;
								[2] = v._name,
								[3] = steamName,
								[4] = v._desc,
								[5] = v._faction,
								[6] = v._money,
								[7] = subData && subData.banned or false,
								[8] = subData && subData.bannedBy or "Unknown",
								[9] = v._model,
								[10] = user && true || false,
								[11] = user && user:GetSkin() || "0",
								[12] = user && user:getNutData("whitelists", {}) or {},
								[13] = v._steamID,
								[14] = ""
						}
							if user then
									for k, v in pairs(user:GetBodyGroups()) do
										charData[#charData][14] = charData[#charData][14] .. tostring(user:GetBodygroup(k));
									end
							end;
							charData[#charData] = pon.encode(charData[#charData])
						end
				end
		end)

		return charData;
end;