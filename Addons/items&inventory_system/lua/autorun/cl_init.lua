AddCSLuaFile('libraries/sh_pon.lua') include('libraries/sh_pon.lua')
AddCSLuaFile('libraries/sh_netstream.lua') include('libraries/sh_netstream.lua')

netstream.Hook("[ROSS]..NetworkDataSync", function(key, value)
    if !tblLocal then tblLocal = {}; end;
    tblLocal[key] = value;
end)

netstream.Hook("[R]_PlayerSynchronizeITEM", function(uniqueID, itemID)
    local itemGiven = invaddon.itemModule.items[uniqueID];
    LocalPlayer():GData("PlayerInventory")[itemID] = itemGiven
    LocalPlayer():GData("PlayerInventory")[itemID].itemID = itemID
end)

netstream.Hook("[R]_PlayerSynchronizeITEMTake", function(uniqueID, itemID)

  local inventory = LocalPlayer():GData('PlayerInventory')
  if uniqueID && !itemID then
    for k, v in pairs(inventory) do
      if v.uniqueID == uniqueID then
        LocalPlayer():GData("PlayerInventory", {})[k] = nil;
          if invaddon.ui then

            invaddon.ui.distanceTable[k]:Remove();

          end;
        return;
      end;
    end;
  elseif uniqueID && itemID then
    for k, v in pairs(inventory) do
      if v.uniqueID == uniqueID && v.itemID == itemID then
        LocalPlayer():GData("PlayerInventory", {})[k] = nil;
        if invaddon.ui then

          invaddon.ui.distanceTable[itemID]:Remove();

        end;
      end;
    end;
  end;

end)

netstream.Hook("OpenInventoryForMe", function()
	if (invaddon.ui and invaddon.ui:IsValid()) then
		invaddon.ui:Close();
	end;
	invaddon.ui = vgui.Create("OpenPlayerInventory");
	invaddon.ui:Populate()
end)

--[[ Не забудь доделать и сделать проверку на налие айтема.]]
--
netstream.Hook("[R]_CreateItemUseMenu", function(tbl)
  local sw, sh = ScrW(), ScrH()
  local Sformula = function(width)
      return sw * (width/1920)
  end;
  local Hformula = function(height)
      return sh * (height/1080)
  end;
  local itemUse = DermaMenu()
    for k, v in pairs(tbl) do
        itemUse:AddOption( v, function()
          netstream.Start("[R]_ENTITY_option_selected", k)
        end)
    end;
  itemUse:Open()
  itemUse:SetPos(Sformula(900), Hformula(500))
  itemUse.Paint = function(s, w, h)
    Derma_DrawBackgroundBlur( s, s.m_fCreateTime )
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
  end;
end)

netstream.Hook("SynchronizeCategories", function(table)
    _CategoriesOfItems = table;
end)

if CLIENT then
	hook.Add("Think", "[Ross]_invsystem_bars", function()
		invaddon.BarsModule:AddBar("health", LocalPlayer():Health(), LocalPlayer():GetMaxHealth(), Color(255, 100, 100))
		invaddon.BarsModule:AddBar("weight", LocalPlayer():GData("Weight"), 60, Color(100, 255, 100))
		invaddon.BarsModule:AddBar("space", LocalPlayer():GData("Space"), 60, Color(100, 255, 100))
	end)
end;
