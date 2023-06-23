
local PLUGIN = PLUGIN;
local p = FindMetaTable( "Player" );
local math = math;
local m = math.Clamp;

function p:SVGetClothesNumber(slot, data)
	local items = Clockwork.inventory:GetAsItemsList(self:GetInventory());
	local num = 0;

	for k, v in ipairs(items) do
		if v("clothesslot") == slot && v:GetData("Used") == true && v:GetData(data) then
		    num = tonumber(v:GetData(data));
		end;
	end;
	return num;

end;

function p:AddCleaningFromBody(num)
    local items = Clockwork.inventory:GetAsItemsList(self:GetInventory());
	
	for k, v in ipairs(items) do
            if v:GetData("Used") == true && v:GetData("Cleaning") >= 0 && v("clothesslot") == "body" || v("clothesslot") == "legs" then
			v:SetData("Cleaning", m(v:GetData("Cleaning") + num, 0, 100));
		end;
      end;
      
      if Schema:PlayerIsCombine(self) && self:GetCharacterData("GasMaskInfo") > 0 then
            local clothesslot = self:GetCharacterData("ClothesSlot");
            local maskCP = self:FindItemByID(clothesslot["gasmask"])
            maskCP:SetData("Cleaning", m(maskCP:GetData("Cleaning") + num*(3 - self:GetCharacterData("GasMaskInfo")), 0, 100));
      end;
	
end;

function p:ClothesReduceSpeed()
    local num = 0;
    local clothesslot = self:GetCharacterData("ClothesSlot");
    
    if clothesslot["body"] != "" then
      local ItemBody = self:FindItemByID(clothesslot["body"]);
      if ItemBody.clothesslot == 'body' && ItemBody:GetData("Used") && ItemBody:GetData("ReduceSpeed") > 0 then
            num = num + tonumber(ItemBody:GetData("ReduceSpeed"));
      end;
    end;
    if clothesslot["legs"] != "" then
      local ItemLegs = self:FindItemByID(clothesslot["legs"]);
      if ItemLegs.clothesslot == 'body' && ItemLegs:GetData("Used") && ItemLegs:GetData("ReduceSpeed") > 0 then
            num = num + tonumber(ItemLegs:GetData("ReduceSpeed"));
      end;
    end;

    return num;

end;

function p:GetFilterQuality()
      local items = Clockwork.inventory:GetAsItemsList(self:GetInventory());

      for k, v in ipairs(items) do
            if v("baseItem") == "clothes_base" && v.isGasmasked then
                  return v:GetData("FilterQuality")
            end;
      end;
      return 0;
end;

function p:UpdateFilterQuality(number)
      local items = Clockwork.inventory:GetAsItemsList(self:GetInventory());

      for k, v in ipairs(items) do
            if v("baseItem") == "clothes_base" && v.isGasmasked && v:GetData("FilterQuality") > 0 && v:GetData("Protection") >= 20 then
                  v:SetData("FilterQuality", m((v:GetData("FilterQuality") + number)+v:GetData("Protection")/1000, 0, 100));
            end;
      end;
      return 0;
end;

function p:SetFilterQuality(number)
      local items = Clockwork.inventory:GetAsItemsList(self:GetInventory());

      for k, v in ipairs(items) do
            if v("baseItem") == "clothes_base" && v.isGasmasked && v:GetData("FilterQuality") then
                  v:SetData("FilterQuality", number);
            end;
      end;
      return 0;
end;

function p:PlayerSetRollData(hit, hitgroup)
      local RollInformation = self:GetCharacterData("RollInfo")
      local damage = 0;
      local hg;

      if hit == "промахнулся." then
            damage = 0
      elseif hit == "попал и нанес легкий урон." then
            damage = 3
      elseif hit == "попал и нанес средний урон." then
            damage = 2
      elseif hit == "попал в то место, куда целится." then
            damage = 1
      end;

      if hitgroup == "в голову(или противогаз)" then
            hg = 1
      elseif hitgroup == "в голову(без защиты)" then
            hg = 1
      elseif hitgroup == "в тело" then
            hg = {2, 3}
      elseif hitgroup == "в руки" then
            hg = {4, 5}
      elseif hitgroup == "в ноги" then
            hg = {6, 7}
      elseif hitgroup == "на подавление, но в тело." then
            hg = {2, 3}
      elseif hitgroup == "на подавление, но в руки." then
            hg = {4, 5}
      elseif hitgroup == "на подавление, но в ноги." then
            hg = {6, 7}
      end;

      RollInformation["damageScale"] = damage;
      RollInformation["hitgroup"] = hg;
end;

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
      
      sound.Add({
            name = "wash_mach",
            channel = CHAN_STATIC,
            volume = 1.0,
            level = 80,
            pitch = { 110, 110 },
            sound = "ambient/machines/laundry_machine1_amb.wav"
      })

      sound.Add({
            name = "water_fall",
            channel = CHAN_STATIC,
            volume = 1.0,
            level = 80,
            pitch = { 100, 100 },
            sound = "ambient/water/leak_1.wav"
      })

      local avaibleSlots = {
		"body",
		"legs",
		"hands"
      }
      
	if (entity:GetClass() == "clothes_washer" && arguments == "r_clothes_washer_o" && entity:GetTurnOn() == false) then
        if (!weight) then 
            weight = 6 
        end;	
        if (!entity.cwInventory) then 
            entity.cwInventory = {}; 
        end;
 
		Clockwork.storage:Open(player, {
			name = "Стиральная машина",
			weight = weight,
			entity = entity,
			distance = 192,
			inventory = entity.cwInventory,
			OnGiveCash = function(player, storageTable, cash)
				return false;
			end,
			OnTakeCash = function(player, storageTable, cash)
				return false;
			end,
			OnClose = function(player, storageTable, entity)
			end,
                  CanGiveItem = function(player, storageTable, itemTable)
                        if itemTable("baseItem") == "clothes_base" && table.HasValue(avaibleSlots, itemTable("clothesslot")) then
                              return true;
                        end;
                        return false;
                  end,
                  CanTakeItem = function(player, storageTable, itemTable)
                        if entity:GetTurnOn() == true then 
                              return false;
                        end;
                        return true;
                  end
		});				
      end;
      if (entity:GetClass() == "clothes_washer" && arguments == "r_clothes_washme" && entity:GetTurnOn() == false) then
            local inv = Clockwork.inventory:GetAsItemsList(entity.cwInventory);

            entity:SetTurnOn(true);
            entity:EmitSound("wash_mach");
            timer.Simple(5, function()
                  for k, v in ipairs(inv) do 
                        v:SetData("Cleaning", m(v:GetData("Cleaning") - (entity:GetAmountOfCleaning()*10), 0, 100) )
                  end;
                  entity:StopSound("wash_mach");
                  entity:SetTurnOn(false);
            end);
      end;
      if entity:GetClass() == "human_bath" && arguments == "water_enable" && !entity:GetWaterFall() && entity:GetWaterLevel() < 60 then
            entity:SetWaterFall(true);
            entity:EmitSound("water_fall")
      timer.Create("Bath.full_", 1, 60, function()
            entity:SetWaterLevel(m(entity:GetWaterLevel() + 1, 0, 60))
            if entity:GetWaterLevel() == 60 then
                  entity:SetWaterFall(false);
                  entity:StopSound("water_fall");
            end;
      end);
      elseif entity:GetClass() == "human_bath" && arguments == "water_disable" && entity:GetWaterFall() && entity:GetWaterLevel() < 60 then
            if timer.Exists("Bath.full_") then
                  entity:StopSound("water_fall")
                  timer.Stop( "Bath.full_" )
                  entity:SetWaterFall(false);
            end;
      end;
end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["ClothesSlot"]) then
		data["ClothesSlot"] = data["ClothesSlot"];
	else
	      data["ClothesSlot"] = {
            head = "",
            body = "",
            legs = "",
            gasmask = ""
		};
      end;
      
end;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["ClothesSlot"] ) then
		data["ClothesSlot"] = {
            head = "",
            body = "",
            legs = "",
            gasmask = ""
		};
      end;
      if (!data["RollInfo"]) then
	      data["RollInfo"] = {
                  damageScale = 0,
                  hitgroup = ""
            };
	end;
      if ( !data["AddInvSpaceCode"] ) then
           data["AddInvSpaceCode"] = 0;
      end;
      if !data["GasMaskInfo"] then
            data["GasMaskInfo"] = 0;
      end;
end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
      player:SetSharedVar("GasMaskInfo", player:GetCharacterData("GasMaskInfo"));
end;

function PLUGIN:PlayerThink(player, curTime, infoTable)

      if (player.cooldowned == true) then
            if (!player.rollcooldown || curTime >= player.rollcooldown) then
            player.cooldowned = false;
            player.rollcooldown = curTime + 5;
            end;
      end;

      infoTable.runSpeed = infoTable.runSpeed - player:ClothesReduceSpeed();
      infoTable.walkSpeed = infoTable.walkSpeed - player:ClothesReduceSpeed();
      infoTable.crouchedSpeed = infoTable.crouchedSpeed - player:ClothesReduceSpeed();
      infoTable.jumpPower = infoTable.jumpPower - player:ClothesReduceSpeed();


      infoTable.inventoryWeight = infoTable.inventoryWeight + player:GetCharacterData("AddInvSpaceCode");
      infoTable.inventorySpace = infoTable.inventorySpace + math.Round(player:GetCharacterData("AddInvSpaceCode")/2);

end;

function PLUGIN:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
      local clothesslot = player:GetCharacterData("ClothesSlot");

      if hitGroup == 1 && clothesslot["head"] != "" || clothesslot["gasmask"] != "" then
            local headItem = player:FindItemByID(clothesslot["head"])
            if headItem && headItem:GetData("Armor") && headItem:GetData("Used") then
                  damageInfo:ScaleDamage( 1.6 - headItem:GetData("Armor")/100 );
                  headItem:SetData("Armor", math.Clamp(headItem:GetData("Armor") - damageInfo:GetDamage()/10, 0, 100))
                  headItem:SetData("Protection", math.Clamp(headItem:GetData("Protection") - damageInfo:GetDamage()/10, 0, 100))
                  headItem:SetData("Warming", math.Clamp(headItem:GetData("Warming") - damageInfo:GetDamage()/10, 0, 100))                  
            end;
      elseif hitGroup == 2 || hitGroup == 3 || hitGroup == 10 || hitGroup == 4 || hitGroup == 5 && clothesslot["body"] != "" then
            local bodyItem = player:FindItemByID(clothesslot["body"])
            if bodyItem && bodyItem:GetData("Armor") && bodyItem:GetData("Used") then
                  damageInfo:ScaleDamage( 1.3 - bodyItem:GetData("Armor")/100 );
                  bodyItem:SetData("Armor", math.Clamp(bodyItem:GetData("Armor") - damageInfo:GetDamage()/10, 0, 100))
                  bodyItem:SetData("Protection", math.Clamp(bodyItem:GetData("Protection") - damageInfo:GetDamage()/10, 0, 100))
                  bodyItem:SetData("Warming", math.Clamp(bodyItem:GetData("Warming") - damageInfo:GetDamage()/10, 0, 100))                  
            end;
      elseif hitGroup == 6 || hitGroup == 7 && clothesslot["legs"] != "" then
            local legsItem = player:FindItemByID(clothesslot["legs"])
            if legsItem && legsItem:GetData("Armor") && legsItem:GetData("Used") == true then
                  damageInfo:ScaleDamage( 1.5 - legsItem:GetData("Armor")/100 );
                  legsItem:SetData("Armor", math.Clamp(legsItem:GetData("Armor") - damageInfo:GetDamage() * 10, 0, 100))
                  legsItem:SetData("Protection", math.Clamp(legsItem:GetData("Protection") - damageInfo:GetDamage(), 0, 100))
                  legsItem:SetData("Warming", math.Clamp(legsItem:GetData("Warming") - damageInfo:GetDamage()/10, 0, 100))
            end;
      end;

end;

function PLUGIN:PrePlayerTakeDamage(player, attacker, inflictor, damageInfo)
      if attacker:IsPlayer() then
      local r = attacker:GetCharacterData("RollInfo");
      local trace = attacker:GetEyeTraceNoCursor();
      local target = trace.Entity;
      local hitGroup = trace.HitGroup
      local tblHG = r["hitgroup"];
      local tblDmg = r["damageScale"];
      local typeTBL = type(tblHG) == "table";
      local typeNumber = type(tblHG) == "number";

      if ( (typeTBL && table.HasValue(tblHG, hitGroup)) ) && tblDmg != 0 && (tblHG ~= "" || tblHG ~= {}) then
            damageInfo:SetDamage( math.Clamp(damageInfo:GetDamage() / r["damageScale"], 0.1, 100) );
            Clockwork.chatBox:SendColored(attacker, Color(200, 100, 100), "Вы атаковали: "..target:GetName().." с уроном "..math.Round(damageInfo:GetDamage()));
            r["hitgroup"] = "";
            r["damageScale"] = 0;
      elseif (typeNumber && tblHG == hitGroup) && tblDmg != 0 && (tblHG ~= "" || tblHG ~= {}) then
            damageInfo:SetDamage( math.Clamp(damageInfo:GetDamage() / r["damageScale"], 0.1, 100) );
            Clockwork.chatBox:SendColored(attacker, Color(200, 100, 100), "Вы атаковали: "..target:GetName().." с уроном "..math.Round(damageInfo:GetDamage()));
            r["hitgroup"] = "";
            r["damageScale"] = 0;
      elseif (typeNumber && tblHG != hitGroup) && tblDmg != 0 && (tblHG ~= "" || tblHG ~= {}) then
            damageInfo:SetDamage( 0 );
            r["hitgroup"] = "";
            r["damageScale"] = 0;
            Clockwork.chatBox:SendColored(attacker, Color(200, 100, 100), "Вы аннулировали урон от ролла.");
      elseif ( (typeTBL && !table.HasValue(tblHG, hitGroup)) ) && tblDmg != 0 && (tblHG ~= "" || tblHG ~= {}) then
            damageInfo:SetDamage( 0 );
            r["hitgroup"] = "";
            r["damageScale"] = 0;
            Clockwork.chatBox:SendColored(attacker, Color(200, 100, 100), "Вы аннулировали урон от ролла.");
      end;
      end;
end;

function PLUGIN:ItemEntityTakeDamage(itemEntity, itemTable, damageInfo)
      if itemTable("baseItem") == "clothes_base" then
            damageInfo:ScaleDamage( 0 );
            itemTable:SetData("Protection", m(itemTable:GetData("Protection") - math.random(1, 15), 0, 100))
      end;
end;