local player = FindMetaTable("Player")

function player:GData(key, default)
    if self.rossAddonData && self.rossAddonData[key] then
        return self.rossAddonData[key];
    end;
    return default;
end;

function player:SData(key, value)
    if !self.rossAddonData then self.rossAddonData = {}; end;
    self.rossAddonData[key] = value;

    netstream.Start(self, "[ROSS]..NetworkDataSync", key, value);
end;

function player:AddItemToInventory(uniqueID, itemID)
    if !self:IsValid() then return end;

    if self:GData("PlayerInventory", {}) then
      local item = invaddon:CreateItem(uniqueID, itemID)
      self:GData("PlayerInventory", {})[item.itemID] = item;
      self:SData("Weight", math.Clamp(self:GData("Weight") + item.weight, 0, 100) )
      self:SData("Space", math.Clamp(self:GData("Space") + item.space, 0, 100) )

      if self:GData("PlayerInventory", {})[itemID] then
        netstream.Start(self, "[R]_PlayerSynchronizeITEM", item.uniqueID, item.itemID)
      end;
    end;

end;

function player:CanPickupItem(uniqueID)
    local itemInfo = invaddon.itemModule.items[uniqueID]

    return itemInfo && (self:GData("Weight") + itemInfo.weight <= 60) && (self:GData("Space") + itemInfo.space <= 60)
end;


function player:HasItemByID(uniqueID, itemID)
  if !self:IsValid() then return end;
  local inventory = self:GData("PlayerInventory", {});

  if uniqueID && !itemID then
      for k, v in pairs(inventory) do
        if v.uniqueID == uniqueID then return inventory[v.itemID] end;
      end;
  elseif uniqueID && itemID then
    for k, v in pairs(inventory) do
      if v.uniqueID == uniqueID && v.itemID == itemID then return inventory[v.itemID] end;
    end;
  end;
  return false;
end;

function player:TakeItemFromInventory(uniqueID, itemID)
    if !self:IsValid() then return end;
    local inventory = self:GData("PlayerInventory", {});

    if inventory && self:HasItemByID(uniqueID, itemID) then
      if uniqueID && !itemID then
        for k, v in pairs(inventory) do
          if v.uniqueID == uniqueID then
            self:GData("PlayerInventory", {})[k] = nil;
            return;
          end;
        end;
      elseif uniqueID && itemID then
        for k, v in pairs(inventory) do
          if v.uniqueID == uniqueID && v.itemID == itemID then
            self:GData("PlayerInventory", {})[k] = nil;
          end;
        end;

        self:SData("Weight", math.Clamp(self:GData("Weight") - invaddon.itemModule.items[uniqueID].weight, 0, 60))
        self:SData("Space", math.Clamp(self:GData("Space") - invaddon.itemModule.items[uniqueID].space, 0, 60))
        netstream.Start(self, "[R]_PlayerSynchronizeITEMTake", uniqueID, itemID)
      end;
    end;
end;

function player:SpawnItemEntity(uniqueID, itemID, position, angles)
  local GetItem = invaddon:CreateItem(uniqueID, itemID)
  if !GetItem then return end;
  local lookPos = self:GetEyeTraceNoCursor();
  local vector, ang = (position or lookPos.HitPos), (angles or self:GetAngles())
  local itemEntity = ents.Create("r_item")
  itemEntity:SetPos( vector + Vector(0, 0, 10) )
  itemEntity:SetAngles( ang )
  itemEntity:SetItemTable(GetItem);
  itemEntity.itemTable.isEntity = itemEntity;
  itemEntity:Spawn();
end;

function player:SetCash(amount) self:SData("Cash", amount); end;

function player:SetCrystalls(amount) self:SData("Crystalls", amount); end;

function player:GetCash()
    return self:GData("Cash");
end;

function player:GetCrystalls()
    return self:GData("Crystalls");
end;
