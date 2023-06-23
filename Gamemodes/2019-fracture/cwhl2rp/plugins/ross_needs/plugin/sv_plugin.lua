
local PLUGIN = PLUGIN;

local p = FindMetaTable( "Player" )
local math = math;
local mc = math.Clamp;

Clockwork.kernel:AddDirectory("materials/fractureRP_icons/hunger/");
Clockwork.kernel:AddDirectory("materials/fractureRP_icons/thirst/");
Clockwork.kernel:AddDirectory("materials/fractureRP_icons/sleep/");
Clockwork.kernel:AddDirectory("materials/fractureRP_icons/tideness/");

function p:SetNeed(need, num)
	local data = self:GetCharacterData("Needs");
	local number = tonumber(num)
	
	data[need] = number;

return 0;
end;

function p:GetNeed(need)
	local data = self:GetCharacterData("Needs");

	return data[need];
end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["Needs"]) then
		data["Needs"] = data["Needs"];
	else
		data["Needs"] = {
			hunger = 0,
			thirst = 0,
			sleep = 0,
			clean = 0
		};
	end;

end;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["Needs"] ) then
		data["Needs"] = {
			hunger = 0,
			thirst = 0,
			sleep = 0,
			clean = 0
		};
    end;
end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("hunger", player:GetNeed("hunger"));
	player:SetSharedVar("thirst", player:GetNeed("thirst"));
	player:SetSharedVar("sleep", player:GetNeed("sleep"));
	player:SetSharedVar("clean", player:GetNeed("clean"));
end;

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local ec = entity:GetClass();

	if (ec == "prop_physics" && arguments == "pack_sleepbag" && entity:GetNWBool("SleepBag") == true) then
		Clockwork.player:SetAction(player, "BagMeUp", 10);
			Clockwork.player:EntityConditionTimer(player, entity, entity, 10, 192, function()
				return player:Alive() and !player:IsRagdolled()
			end, function(success)
			if (success) then
				entity:EmitSound("physics/wood/wood_solid_impact_soft1.wav");
				Clockwork.entity:CreateItem(player, Clockwork.item:CreateInstance("ross_sleepbag"), entity:GetPos() + Vector(-5, 0, 0));
				entity:Remove();
			end;
	
			Clockwork.player:SetAction(player, "BagMeUp", false);
		end);
	end;

end;


function PLUGIN:PlayerThink(player, curTime, infoTable)
	local animationTable = {
		"Lying_Down",
		"d1_town05_Winston_Down",
		"d2_coast11_Tobias",
		"sniper_victim_pre",
		"Sit_Ground"
	}
	local sympthoms = {
        "cought",
        "temperature",
        "vomit",
        "eyeache",
        "bloodcough",
        "headache"
    };
	local invw = player:GetInventoryWeight();
	local hunger = player:GetNeed("hunger");
	local thirst = player:GetNeed("thirst");
	local sleep = player:GetNeed("sleep");
	local clean = player:GetNeed("clean");
	local tox = player:GetCharacterData("Toxins");
	local col_w = Color(255, 255, 150, 255)
	local health = player:Health();
	local action, percentage = Clockwork.player:GetAction(player, true);
	local Alive = player:Alive();
	local rag = player:IsRagdolled();
	local mh = player:GetMaxHealth();
	local modelClass = Clockwork.animation:GetModelClass(player:GetModel());

	local stomach = (100 - Clockwork.limb:GetHealth(player, HITGROUP_STOMACH))/100;

	local err = math.random(0, 100);
	if (!player.needs or curTime >= player.needs) then
		if err > 50 then
			player:SetNeed("hunger", mc(hunger + 0.05 + (invw/10) + (sleep/10) + stomach, 0, 100));
			player:SetNeed("thirst", mc(thirst + 0.05 + stomach, 0, 100));
			player:SetNeed("sleep", mc(sleep + 0.05 + (invw/10) + stomach, 0, 100));
			player:AddCleaningFromBody(clean + tox/100);
			if Schema:PlayerIsCombine(player) && player:GetCharacterData("GasMaskInfo") > 0 then
				Schema:AddCombineDisplayLine( "Изменение в показателях! Голод: +"..(hunger/100).."% Жажда: +"..(thirst/100).."% Усталость: +"..(sleep/100).."% Грязность: +"..clean.."%", Color(100, 100, 255), player );
			end;
		end;		
    player.needs = curTime + 300;
	end;

	if player:GetVelocity():Length() > 0 then
		if (!player.moving or curTime >= player.moving) then
			if err > 50 then
				player:SetNeed("clean", mc(clean + 0.06, 0, 100));
			end;
		player.moving = curTime + 2;
		end;
	end;

	if player:GetForcedAnimation() != nil then 
		local add = -0.2;
		if sleep > 0 && !rag && Alive && table.HasValue(animationTable, player:GetForcedAnimation()["animation"]) && modelClass == "maleHuman" then
			if (!player.chillit or curTime >= player.chillit) then

			for k, v in ipairs( ents.FindInSphere(player:GetPos(), 5)) do
				if v:GetClass() == "prop_physics" && v:GetNWBool("SleepBag") == true then
					add = 0.7
				elseif v:GetClass() == "prop_physics" && v:GetModel("models/props_c17/FurnitureMattress001a.mdl") then
					add = 1.5
				end;
			end;
				if player:GetForcedAnimation()["animation"] != "Sit_Ground" then
					player:SetNeed("sleep", mc(sleep - (0.5 + add), 0, 100))
					if add == -0.2 && err >= 96 && health >= 10 then
						player:SetHealth(mc(health - 5, 10, mh))
						player:AddSympthom(table.Random(sympthoms))
					end;
				end;
				if sleep > 0 && player:GetForcedAnimation()["animation"] == "Sit_Ground" && !rag && Alive then
					player:SetNeed("sleep", math.Clamp(player:GetNeed("sleep") - 0.2, 0, 100))
					if add == -0.2 && err >= 96 && health >= 10 then
						player:SetHealth(math.Clamp(health - 5, 10, player:GetMaxHealth()))
						player:AddSympthom(table.Random(sympthoms))
					end;
				end;

				player.chillit = curTime + 2;
			end;
		end;
	end;

	if player:IsRunning() then
		if (!player.running or curTime >= player.running) then
			if err > 35 then
				if GetSkillValue(player, ATB_ENDURANCE2) then
					Clockwork.attributes:Update(player, ATB_ENDURANCE2, math.random(0.01, 0.1))
				end;
				player:SetNeed("thirst", mc(thirst + 0.12, 0, 100));
				player:SetNeed("sleep", mc(sleep + 0.10, 0, 100));
				player:SetNeed("clean", mc(clean + 0.12, 0, 100));
			end;
		player.running = curTime + 2;
		end;
	end;

	if player:IsRagdolled() then
		if (!player.ragdolled or curTime >= player.ragdolled) then
			if err > 45 then
				player:SetNeed("clean", mc(clean + 0.09, 0, 100));
			end;
		player.ragdolled = curTime + 10;
		end;
	end;	

	if player:Crouching() then
		if (!player.crouching or curTime >= player.crouching) then
			if err > 35 then
				if GetSkillValue(player, ATB_ENDURANCE2) then
					Clockwork.attributes:Update(player, ATB_ENDURANCE2, math.random(0.01, 0.05))
				end;
				player:SetNeed("thirst", mc(thirst + 0.09, 0, 100));
				player:SetNeed("sleep", mc(sleep + 0.09, 0, 100));
				player:SetNeed("clean", mc(clean + 0.08, 0, 100));
			end;
		player.crouching = curTime + 5;
		end;
	end;

	infoTable.runSpeed = math.Clamp(infoTable.runSpeed - (player:GetNeed("sleep")/100) - (player:GetNeed("clean")/100), 1, Clockwork.config:Get("run_speed"):Get());
	infoTable.walkSpeed = math.Clamp(infoTable.walkSpeed - (player:GetNeed("sleep")/100) - (player:GetNeed("clean")/100), 1, Clockwork.config:Get("walk_speed"):Get());
	infoTable.jumpPower = math.Clamp(infoTable.jumpPower - (player:GetNeed("sleep")/100) - (player:GetNeed("clean")/100), 1, Clockwork.config:Get("jump_power"):Get());

	if hunger >= 90 && thirst >= 90 && sleep >= 90 && health > 10 then
		if (!player.dyingOfNeeds or curTime >= player.dyingOfNeeds) then
			player:SetHealth(math.Clamp(health - math.random(1, 2), 0, player:GetMaxHealth()));
			Clockwork.hint:SendCenter(player, "Из-за изнеможения и тяжелого состояния вы начинаете умирать.", 5, col_w, true, true);
		player.dyingOfNeeds = curTime + math.random(300, 900);
		end;
	end;

end;

function PLUGIN:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	local clean = player:GetNeed("clean");
	player:SetNeed("clean", mc(clean + 0.1, 0, 100));
end;

function PLUGIN:PlayerCanUseItem(player, itemTable, bNoMsg)
	if player:GetNeed("sleep") > 90 then
		Clockwork.chatBox:SendColored(player, Color(255, 100, 100), "Вы слишком устали, чтобы использовать этот предмет!");
		return false;
	end;
end;

function PLUGIN:PlayerUseItem(player, itemTable, itemEntity) 
	if itemTable("baseItem") == "food_base" && (itemTable("dhunger") > 40 || itemTable("dthirst") > 40) && itemTable("addDamage") == 0 then
		Clockwork.attributes:Update(player, ATB_ENDURANCE2, (itemTable("dhunger") + itemTable("dthirst") + itemTable("dsleep"))/100 )
	end;
end;