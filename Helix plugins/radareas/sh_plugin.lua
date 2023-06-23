local PLUGIN = PLUGIN

PLUGIN.name = "Radiation areas"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = "Plugin, which provides radiation areas and mechanics for realisation of them."

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_meta.lua")

PLUGIN.rMin = 1; // Minimum ticks to get one rad;
PLUGIN.rMax = 5; // Maximum ticks to get one rad;
PLUGIN.maxRadiation = 1000; // Maximum of radiation for character; (Critical dose)
PLUGIN.maxRadMSG = "You vomit before falling asleep never to wake up..."; // Death message for player, who received a critical dose;
PLUGIN.radPerTick = 1; // Radiation per tick;

PLUGIN.radData = {
	{
		min = 200,
		max = 399,
		messages = {
			"You feel nauseous...",
			"You feel like throwing up...",
		},
		actions = function(client)
		end,
	},
	{
		min = 400,
		max = 599,
		messages = {
			"You feel tired...",
			"You feel exhausted...",
		},
		actions = function(client)
		end,
	},
	{
		min = 600,
		max = 799,
		messages = {
			"Something begins to come up...",
			["me"] = "Stops dead in their tracks throwing up onto the floor.",
		},
		actions = function(client)
		end,
	},
	{
		min = 800,
		max = 999,
		messages = {
			"You notice clumps of hair falling out...",
			"Your skin is turning red with blisters...",
		},
		actions = function(client)
		end,
	},
}
PLUGIN.geigerSounds = {
	{
		min = 1, 
		max = 2,
		sound = "player/geiger1.wav"
	},
	{
		min = 3,
		max = 4,
		sound = "player/geiger2.wav",
	},
	{
		min = 5,
		max = PLUGIN.rMax,
		sound = "player/geiger3.wav"
	}
}

ix.command.Add("CharSetRad", {
	description = "Set the radiation amount for character",
	superAdminOnly = true,
	arguments = {
		ix.type.player,
		ix.type.number
	},
	OnRun = function(self, client, target, rad)
			target.RadMin = nil;
			target.RadMax = nil;
			target:IncRad( math.Clamp(rad, 0, PLUGIN.maxRadiation) )
			PLUGIN:TriggerRadiationCheck(target)
			
			client:Notify("You changed the " .. target:Name() .. "'s radiation amount to " .. rad)
	end
})

function PLUGIN:SetupAreaProperties()
	ix.area.AddType("Radiation")

	// It will display in area vgui by default anyway, but it don't break anything;
	ix.area.AddProperty("toxicity", ix.type.number, 1)
end

function PLUGIN:TriggerRadiationCheck(client)
		local rad = client:GetRad();
		local data = self.radData

		// If radiation is less, than first index's minimum, then it doesn't make sence to iterate;
		if rad < data[1].min then return end;

		local i = 1;
		while (i <= #data) do
				local info = data[i];
				if info && rad > info.min && rad <= info.max then

						local radMin = client.RadMin;
						local radMax = client.RadMax;
						if radMin && radMin >= info.min && radMax && radMax <= info.max then return; end

						local msgs = info.messages;
						local action = info.actions;
						if msgs && #msgs > 0 then client:Notify( tostring(msgs[math.random(1, #msgs)]) ) end;
						if msgs.me then ix.chat.Send(client, "me", tostring(msgs.me)); end
						if action && isfunction(action) then action(action); end
						
						client.RadMin = info.min;
						client.RadMax = info.max;
						return; // We've finished here, halt;
				end	
				i = i + 1;
		end;
end;

function RFormatTime(time)
		local formatTime = "";
		if time >= 60 then
				if math.floor(time / 60) > 9 then
					formatTime = math.floor(time / 60) .. ":"
				else
					formatTime = "0" .. math.floor(time / 60) .. ":"
				end;
				if time % 60 < 10 then
					formatTime = formatTime .. "0" .. time % 60
				else
					formatTime = formatTime .. time % 60
				end
		else
				if time % 60 < 10 then
						formatTime = "00:" .. "0" .. time
				else
						formatTime = "00:" .. time
				end;
		end

		return formatTime
end;