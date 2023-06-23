local PLUGIN = PLUGIN;

function PLUGIN:LoadNutFonts(font, genericFont)
	font = genericFont
	surface.CreateFont( "ButtonStyle", {
		font = "Comfortaa",
		size = ScreenScale(7),
	})
end;

nut.playerInteract.addFunc("Trade", {
	nameLocalized = "Send trade request",
	callback = function(target)
			local user = LocalPlayer()
			if user.SentTradeRequest && CurTime() < user.SentTradeRequest then
					local time = math.Round(user.SentTradeRequest - CurTime());
					Derma_Message(
						"You have already sent a trade request to this character. Next request can be sent in ".. time .. " seconds", 
						"Trade request", 
						"Ok"
					)
			end
			if !user.SentTradeRequest || CurTime() >= user.SentTradeRequest then
					nut.util.notify("Trade request sent")

					netstream.Start('trade::requestTo', target)

					user.SentTradeRequest = CurTime() + 60;
			end
	end,
	canSee = function(target) 
		return true
	end
})

netstream.Hook('trade::requestCallback', function(name)
		Derma_Query("You've received a trade request from " .. name .. ". It will automatically decline in 30 seconds.", "Trade request", 
		"Accept", function() 
				netstream.Start('trade::start')
		end, 
		"Decline", function()
				netstream.Start('trade::decline')
		end)
end);

netstream.Hook('trade::open', function(inv, name)
		if PLUGIN.trade && PLUGIN.trade:IsValid() then PLUGIN.trade:Close() end
		local id = LocalPlayer():getChar():getInv():getID()
		TRADE_INV = {
			left = id, 
			right = inv, 
			otherName = name,
			readyUp = {
				[LocalPlayer():Name()] = false,
				[name] = false
			}
		}
		INV_TRADABLE = {}

		PLUGIN.trade = vgui.Create("Trade")
		PLUGIN.trade:Populate()
end);

netstream.Hook('trade::close', function()
		if PLUGIN.trade && PLUGIN.trade:IsValid() then PLUGIN.trade:Close() end

		if !TRADE_INV then return end;
		
		nut.inventory.instances[TRADE_INV.right] = nil;
		TRADE_INV = nil;
		INV_TRADABLE = nil;
end);

netstream.Hook('trade::acceptSync', function(buff)
		local int = PLUGIN.trade
		TRADE_INV["readyUp"] = buff
	
		for name, bool in pairs(buff) do
			int.invs[name].Name:SetTextColor(
				bool &&
				Color(100, 150, 100)
				||
				Color(255, 255, 255)
			)
		end
end);

netstream.Hook('trade::itemSync', function(id)
		local int = PLUGIN.trade
		if !int then return; end
		local invPanel = int.invs[TRADE_INV.otherName]

		for num, pnl in ipairs(invPanel.itemList:GetItems()) do
				if pnl.itemTable && pnl.itemTable:getID() == id then
						pnl.choosen = !pnl.choosen
				end
		end
end);

netstream.Hook('trade:BothTimer', function()
		PLUGIN:BothTimer()
end);