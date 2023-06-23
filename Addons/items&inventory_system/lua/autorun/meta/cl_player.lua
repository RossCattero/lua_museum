local player = FindMetaTable("Player")

function player:GData(key, default)
    if tblLocal && tblLocal[key] then return tblLocal[key] end;
    return default;
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
