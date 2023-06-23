// An overload of default nutscript character meta;
local CHAR = nut.meta.character or {}

if SERVER then
		function CHAR:ban(time, whoBanned)
			time = tonumber(time)

			if (time) then
				-- If time is provided, adjust it so it becomes the un-ban time.
				time = os.time() + math.max(math.ceil(time), 60)
			end

			-- Mark the character as banned and kick the character back to menu.
			self:setData("banned", time or true)
			self:save()
			self:kick()
			
			-- Add the "who banned" to character data or nil the value
			self:setData("bannedBy", whoBanned)
			hook.Run("OnCharPermakilled", self, time or nil)
		end
end;

nut.command.add("charban", {
	syntax = "<string name> <string seconds or no argument for perma>",
	adminOnly = true,
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])

		if (IsValid(target)) then
			local char = target:getChar()

			if (char) then
				nut.util.notifyLocalized("charBan", client:Name(), target:Name())
				local time = tonumber(arguments[2])
				char:ban(time, client:Name())
			end
		end
	end
})

nut.command.add("charunban", {
	syntax = "<string name>",
	adminOnly = true,
	onRun = function(client, arguments)
		if ((client.nutNextSearch or 0) >= CurTime()) then
			return L("charSearching", client)
		end

		local name = table.concat(arguments, " ")

		for k, v in pairs(nut.char.loaded) do
			if (nut.util.stringMatches(v:getName(), name)) then
				if (v:getData("banned")) then
					v:setData("banned")
					v:setData("permakilled")
					v:setData("bannedBy")
				else
					return "@charNotBanned"
				end

				return nut.util.notifyLocalized("charUnBan", nil, client:Name(), v:getName())
			end
		end

		client.nutNextSearch = CurTime() + 15

		nut.db.query("SELECT _id, _name, _data FROM nut_characters WHERE _name LIKE \"%"..nut.db.escape(name).."%\" LIMIT 1", function(data)
			if (data and data[1]) then
				local charID = tonumber(data[1]._id)
				local data = util.JSONToTable(data[1]._data or "[]")

				client.nutNextSearch = 0

				if (!data.banned) then
					return client:notifyLocalized("charNotBanned")
				end

				data.banned = nil

				nut.db.updateTable({_data = data}, nil, nil, "_id = "..charID)
				nut.util.notifyLocalized("charUnBan", nil, client:Name(), v:getName())
			end
		end)
	end
})