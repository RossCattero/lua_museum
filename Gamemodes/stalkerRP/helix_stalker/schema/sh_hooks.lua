
ix.command.Add("r", {
	description = "Передать сообщение по рации.",
	arguments = ix.type.text,
	OnRun = function(self, client, message)
		local character = client:GetCharacter()
		local radios = character:GetInventory():GetItemsByUniqueID("handheld_radio", true) local item
		for k, v in ipairs(radios) do
			if (v:GetData("enabled", false)) then
				item = v
				break
			end
		end
		if (item) then
			ix.chat.Send(client, "radio", message)
			ix.chat.Send(client, "radio_eavesdrop", message)
		elseif (#radios > 0) then
			return "Рация не включена"
		else
			return "У вас нет рации"
		end
	end
})
ix.command.Add("SetFreq", {
	description = "Изменить частоту рации.",
	arguments = ix.type.number,
	OnRun = function(self, client, frequency)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		local itemTable = inventory:HasItem("handheld_radio")

		if (itemTable) then
			if (string.find(frequency, "^%d%d%d%.%d$")) then
				character:SetData("frequency", frequency)
				itemTable:SetData("frequency", frequency)

				client:Notify(string.format("Вы изменили частоту своей рации на %s.", frequency))
			end
		end
	end
})

ix.chat.Register("radio", {
	color = Color(75, 150, 50),
	format = "%s по рации \"%s\"",
	indicator = "Передает по рации...",
	CanHear = function(self, speaker, listener)
		local character = listener:GetCharacter()
		local inventory = character:GetInventory()
		local bHasRadio = false
		for k, v in pairs(inventory:GetItemsByUniqueID("handheld_radio", true)) do
			if (v:GetData("enabled", false) and speaker:GetCharacter():GetData("frequency") == character:GetData("frequency")) then
				bHasRadio = true
				break
			end
		end
		return bHasRadio
	end,
	OnChatAdd = function(self, speaker, text, anonymous, info)
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
	end
})
ix.chat.Register("radio_eavesdrop", {
	color = Color(255, 255, 175),
	format = "%s по рации \"%s\"",
	GetColor = function(self, speaker, text)
		if (LocalPlayer():GetEyeTrace().Entity == speaker) then
			return Color(175, 255, 175)
		end
		return self.color
	end,
	CanHear = function(self, speaker, listener)
		if (ix.chat.classes.radio:CanHear(speaker, listener)) then
			return false
		end
		local chatRange = ix.config.Get("chatRange", 280)
		return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange)
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
	end
})
