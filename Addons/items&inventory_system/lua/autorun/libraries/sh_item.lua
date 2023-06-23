local path = "autorun/items/";
invaddon.itemModule = invaddon.itemModule or {};
invaddon.itemModule.categories = invaddon.itemModule.categories or {};
invaddon.itemModule.items = invaddon.itemModule.items or {}
invaddon._itemMeta = invaddon._itemMeta or {}

invaddon.itemModule.spawnedItems = invaddon.itemModule.spawnedItems or {}

function invaddon:LoadItems()
	for k, v in pairs(file.Find(path.."*.lua", "LUA")) do
		local bufferID = path..v; local uniqueID = bufferID:match("sh_([_%w]+)%.lua");
		if !invaddon.itemModule.items[uniqueID] then
			ITEM = invaddon.itemModule.items[uniqueID] or setmetatable({}, invaddon.itemModule._itemMeta)
			BetterInclude(bufferID) invaddon:RegisterItem(uniqueID)
		end;
	end;
end;
function invaddon:RegisterItem(uniqueID)
    ITEM.uniqueID = uniqueID;

		ITEM.funcs = {}
		ITEM.funcs.take = {
			name = "Pick up!",
			Do = function(ITEM, player)
				player:AddItemToInventory(ITEM.uniqueID, ITEM.itemID)
				ITEM.isEntity:Remove();
			end,
			CanDo = function(ITEM, player)
				return IsValid(ITEM.isEntity)
			end
		}
		ITEM.funcs.drop = {
			name = "Drop it",
			Do = function(ITEM, player)
				local trace = player:GetEyeTrace();
			  local pos = trace.HitPos
			  local Distance = player:GetPos():Distance(pos)
			  local item = player:HasItemByID(ITEM.uniqueID, ITEM.itemID)

			  if item then
			      local itemEntity = ents.Create("r_item");
			      itemEntity:SetItemTable(ITEM);
			      itemEntity.itemTable.isEntity = itemEntity;
			      if Distance < 64 && trace.Hit then
			        itemEntity:SetPos(pos);
			      else
			        itemEntity:SetPos(player:EyePos());
			      end;
			      itemEntity:SetAngles(player:GetAngles());
			      itemEntity:Spawn();

			      player:TakeItemFromInventory(ITEM.uniqueID, ITEM.itemID)
			  end;
			end,
			CanDo = function(ITEM, player)
					return !IsValid(ITEM.isEntity)
			end
		}

    if !invaddon.itemModule.categories[ITEM.category] then invaddon.itemModule.categories[ITEM.category] = true end;
    invaddon.itemModule.items[uniqueID] = ITEM;
end;
invaddon:LoadItems()

function invaddon:CreateItem(uniqueID, itemID)
		if (!itemID or !invaddon.itemModule.spawnedItems[itemID]) && invaddon.itemModule.items[uniqueID] then
			local returnItem = invaddon.itemModule.items[uniqueID];
				returnItem.itemID = os.time() + math.random(1000, 9999)
				invaddon.itemModule.spawnedItems[returnItem.itemID] = returnItem
			return returnItem
		elseif itemID && invaddon.itemModule.spawnedItems[itemID] then
			return invaddon.itemModule.spawnedItems[itemID]
		end;

		return false, print("Can't create an item!!!!")
end;
