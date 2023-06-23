hook.Add( "PlayerInitialSpawn", "[ROSS]..PlayerInitSpawn", function(ply, trans)
    ply:SData("PlayerInventory", {});
    ply:SData("Cash", 0)
    ply:SData("Crystalls", 0)
    ply:SData("Weight", 0)
    ply:SData("Space", 0)
    ply:SData("ClothesData", {
      ["Head"] = {},
      ["Body"] = {},
      ["Legs"] = {},
      ["Uniform"] = {},
      ["Boots"] = {},
      ["Back"] = {},
      ["Primary"] = {},
      ["Second"] = {},
      ["Third"] = {}
    })

    netstream.Start(ply, "SynchronizeCategories", invaddon.itemModule.categories)
end)

hook.Add("PlayerSay", "SpawnItem", function( ply, text )
  local spawnItemCommand = text:match("/spawnitem ([_%w]+)")
  if spawnItemCommand then
      ply:SpawnItemEntity(spawnItemCommand)
      ply:ChatPrint("Предмет создал!")
  end;
end)

hook.Add("ShowSpare1", "[Ross]_ShowInventory", function(p)
    netstream.Start(p, "OpenInventoryForMe")
end)

hook.Add("PlayerUse", "[R]_UseItemEntity", function(player, entity)
  if entity:GetClass() == "r_item" && (!player.SetItemPickCooldown or CurTime() >= player.SetItemPickCooldown) then
    local item = entity.itemTable
    local funct_s = {}
      if player:CanPickupItem(item.uniqueID) then
        if !timer.Exists("PlayerItemPickup-"..player:EntIndex()) then
          timer.Create("PlayerItemPickup-"..player:EntIndex(), math.random(5)/100 + math.random(5)/100, 1, function()
            if player:GetEyeTrace().Entity == entity then
                for k, v in pairs(item.funcs) do
                    if v.CanDo(item, player) or v.CanDo(item, player) == nil then
                        funct_s[k] = v.name or "Unknown";
                    end;
                end;
                netstream.Start(player, "[R]_CreateItemUseMenu", funct_s)
            end;
          end)
        end;
      end;
    player.SetItemPickCooldown = CurTime() + (math.random(3, 10)/10)
  end;
end);

netstream.Hook("[R]_ITEM_option_selected", function(player, uniqueID, itemID, option)
    local item = player:HasItemByID(uniqueID, itemID);

    item.funcs[option].Do(item, player);

end)

netstream.Hook("[R]_ENTITY_option_selected", function(player, option)
    local eyeTrace = player:GetEyeTrace();
    local item = eyeTrace.Entity;

    if item:GetClass() == "r_item" then
        item.itemTable.funcs[option].Do(item.itemTable, player);
    end;

end)

local steamIDTable = {
  "STEAM_0:0:82355154",
  "STEAM_0:0:81566201"
}

hook.Add("CheckPassword", "R_CHECKKK", function(steamID, ipAddress, svPassword, clPassword, name)
    steamID = util.SteamIDFrom64(steamID);

	if !table.HasValue(steamIDTable, steamID) then
		return false, "Access denied!"
	end;
end)
