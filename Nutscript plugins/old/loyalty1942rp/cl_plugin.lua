local PLUGIN = PLUGIN;

function PLUGIN:DrawCharInfo(client, character, info)
  local data = client:getNetVar("GermanTier", 0);
  if data <= 0 || !self.loyaltyList[data] then return end;
  local fromList = self.loyaltyList[data];

  info[#info + 1] = { "Tier " .. fromList.tier .. " Party Member.", fromList.color }
end