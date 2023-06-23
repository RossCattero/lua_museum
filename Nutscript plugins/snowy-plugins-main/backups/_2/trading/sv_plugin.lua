local PLUGIN = PLUGIN;

PLUGIN.tradesBuffer = PLUGIN.tradesBuffer || {}

netstream.Hook('trade::requestTo', function(client, target)
		if IsValid(target) && target:IsPlayer() then
				local trade = PLUGIN:InsertTrade({
					users = {
						[client] = false, 
						[target] = false
					},
					uSync = {
						[client:GetName()] = false, 
						[target:GetName()] = false
					},
					invs = {
						[client] = {}, 
						[target] = {}
					}
				})
				netstream.Start(target, 'trade::requestCallback', client:Name())
		end
end);

netstream.Hook('trade::start', function(client)
		local trade = client:InTrade();
		local targets = {}

		if trade then
				local trade = client:GetTrade();
				for user, _ in pairs(trade["users"]) do
					if IsValid(user) && user:IsPlayer() then 
							targets[#targets + 1] = user;
					else
							return;
					end;
				end
		end
		local user = targets[1];
		local target = targets[2];
		
		local targetInv = target:getChar():getInv();
		local userInv = user:getChar():getInv();
		targetInv:sync(user);
		userInv:sync(target);
			
		netstream.Start(user, 'trade::open', targetInv:getID(), target:GetName())
		netstream.Start(target, 'trade::open', userInv:getID(), user:GetName())
end);

netstream.Hook('trade::decline', function(client)
		local trade = client:InTrade()
		local tradeList = client:GetTrade()

		if tradeList then
				for user, ready in pairs(tradeList["users"]) do
						user:DestroyTrade();

						user:notify("Trade declined.")
				end
		end
end);

netstream.Hook('trade::accept', function(client, data)
		local trade = client:InTrade()
		local tradeList = client:GetTrade()

		if tradeList then
				local b = !tradeList["users"][client]
				tradeList["users"][client] = b
				tradeList["uSync"][client:GetName()] = b
				PLUGIN:SyncTrade(trade)
				PLUGIN.tradesBuffer[trade]["invs"][client] = client:CompactItems(data);
				PLUGIN:CheckAccept(trade)
		end
end);

netstream.Hook('trade::SyncItemChoose', function(client, itemID)
		local inv = client:getChar():getInv():getItems();
		local trade = client:InTrade()

		if trade && inv && inv[itemID] then
				client:SyncItemChoose(trade, itemID)
		end
end);

function PLUGIN:CanPlayerInteractItem(client, action, item)
		return !client:InTrade()
end;