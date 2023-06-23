local ITEM = invaddon._itemMeta or {}
ITEM.name = ITEM.name or "Undefined";
ITEM.description = ITEM.description or "no description";
ITEM.uniqueID = ITEM.uniqueID;
ITEM.itemID = ITEM.itemID or 0;
ITEM.weight = ITEM.weight or 0;
ITEM.space = ITEM.space or 0;
ITEM.model = ITEM.model or "models/error.mdl";
ITEM.category = ITEM.category or "Other";

function ITEM:SetData(key, value)
  self.data = self.data or {}

  if isfunction(value) then return end;
  self.data[key] = value;
end;

function ITEM:GetData(key, default)
  self.data = self.data or {};

  return self.data[key] or default;
end;

invaddon._itemMeta = ITEM;
