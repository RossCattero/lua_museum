local PLUGIN = PLUGIN;
local user = FindMetaTable("Player")

function user:InTrade()
		return self:getLocalVar("tradeNumber");
end

function user:GetTrade()
		local trade = self:InTrade()

		return trade && PLUGIN.tradesBuffer[trade];
end;

function user:DestroyTrade()
		local trade = self:InTrade()
		if trade then
				self:setLocalVar("tradeNumber", nil);
				PLUGIN.tradesBuffer[trade] = nil;
		end
		netstream.Start(self, 'trade::close')
end;

function user:CompactItems(data)
		local trade = self:InTrade()
		if trade then
				local inv = self:getChar():getInv():getItems()
				for k, v in pairs(data) do
						if !inv[k] then
								data[k] = nil;
						end
				end
		end;
		
		return data;
end;

function user:SyncItemChoose(num, id)
		local tradeList = PLUGIN.tradesBuffer[num]
		if tradeList then
				for user, val in pairs(tradeList["users"]) do
						if user != self then
							netstream.Start(user, 'trade::itemSync', id)
						end;
				end
		end
end;

function PLUGIN:InsertTrade(data)
		local id = os.time() + math.random(1, 100) * 1024
		PLUGIN.tradesBuffer[id] = data

		for user, ready in pairs(data['users']) do
				user:setLocalVar("tradeNumber", id);
		end

		return id;
end;

function PLUGIN:SyncTrade(num)
		local tradeList = self.tradesBuffer[num]

		if tradeList then
				for user, val in pairs(tradeList["users"]) do
						netstream.Start(user, 'trade::acceptSync', tradeList["uSync"])
				end
		end
end;

function PLUGIN:TradeExists(num)
		return self.tradesBuffer[num]
end;

function PLUGIN:CheckTradeParticipants(num)
		local trade = self:TradeExists(num)

		if trade then
				for usr, _ in pairs(trade["users"]) do
						if !IsValid(usr) then
								return false;
						end
				end
		end

		return true;
end;

function PLUGIN:CheckAccept(num)
		local trade = self:TradeExists(num)

		if trade then
				for k, v in pairs(trade["users"]) do
						if !v then return; end
				end

				for k, v in pairs(trade["users"]) do
						netstream.Start(k, 'trade:BothTimer')
				end

				timer.Create(num .. " - trade pending", 5, 1, function()
						if !trade || !self:CheckTradeParticipants(num) then 
								return 
						end;

						local bInv = {}
						for k, v in pairs(trade["invs"]) do
							bInv[#bInv + 1] = v;
						end
						
						local i = 2;
						for usr, _ in pairs(trade["users"]) do
								for num, item in pairs(bInv[i]) do
										local oldInv = nut.inventory.instances[item.invID]
										local item = nut.item.instances[num]
										local inv = usr:getChar():getInv()
										oldInv:removeItem(num, true)
										:next(function()
											return inv:add(item, x, y)
										end) // Thank god I realized how to do this
								end
								i = i - 1;
						end

						for usr, v in pairs(trade["users"]) do
								if IsValid(usr) then
										usr:DestroyTrade()
								end;
						end
				end)
		end
end;
