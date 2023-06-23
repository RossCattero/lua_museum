local PLUGIN = PLUGIN;

function PLUGIN:LeftSideReady()
		if !TRADE_INV then return end;
		local user = LocalPlayer()
		local rup = TRADE_INV["readyUp"]

		return rup && rup[user:Name()]
end;

function PLUGIN:RightSideReady()
		if !TRADE_INV then return end;
		local user = TRADE_INV.otherName
		local rup = TRADE_INV["readyUp"]

		return rup && rup[user]
end;

function PLUGIN:CompactItems()
		if !INV_TRADABLE then return end;

		for k, v in pairs(INV_TRADABLE) do
				INV_TRADABLE[k] = INV_TRADABLE[k].itemTable;
		end

		return INV_TRADABLE
end

function PLUGIN:SideReady(name)
		if !TRADE_INV then return end;
		local rup = TRADE_INV["readyUp"]

		return rup && rup[name]
end;

function PLUGIN:BothTimer()
		local int = PLUGIN.trade
		if !int then return; end
		
		for k, v in pairs(TRADE_INV["readyUp"]) do
				if !v then return; end
		end

		int.btnList.AcceptTrade:SetAlpha(100);
		int.btnList.AcceptTrade.Disable = true;
		int.btnList.tLabel:AlphaTo(255, .2, 0, nil)

		timer.Create("Timer for trade", 5, 1, function()
				if !int || !TRADE_INV then return end;
		end)
end