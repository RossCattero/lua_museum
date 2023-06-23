local COMMAND = Clockwork.command:New("AnimCitizenman");
COMMAND.tip = "For F1 menu.";
COMMAND.text = "<string Anim>";
COMMAND.arguments = 1;
COMMAND.animTable = {
	["d1_t01_BreakRoom_WatchBreen"] = 0,
	["d1_t02_Playground_Cit1_Arms_Crossed"] = 0,
	["LineIdle04"] = 0,
	["d1_t02_Playground_Cit2_Pockets"] = 0,
	["scaredidle"] = 0,
	["d2_coast03_PostBattle_Idle02"] = 0,
	["cower_Idle"] = 0,

	["citizen4_preaction"] = 0,
	["lookoutidle"] = 0,
	["d1_town05_Daniels_Kneel_Idle"] = 0,
	["Sit_Ground"] = 0,
	["plazaidle4"] = 0,

	["cheer1"] = 2,
	["cheer2"] = 3,
	["Wave_close"] = 3,
	["Wave"] = 3,
	["luggageidle"] = 0,
	["d2_coast03_Odessa_RPG_Give_Idle"] = 0,
};
COMMAND.animTableTrace = {
	["arrestidle"] = 0,
	["d1_town05_Winston_Down"] = 0,
	["d1_town05_Wounded_Idle_2"] = 0,
	["injured3"] = 0,
	["Lying_Down"] = 0,
	["d1_town05_Wounded_Idle_1"] = 0,
	["sniper_victim_pre"] = 0,
	["d2_coast11_Tobias"] = 0,
};
COMMAND.animTableWall = {
	["d2_coast03_PostBattle_Idle01"] = 0,
	["d1_t03_Tenements_Look_Out_Window_Idle"] = 0,
	["doorBracer_Closed"] = 0,
	["Lean_Left"] = 2,
	["Lean_Back"] = 1,
	["plazaidle1"] = 1,
};

if (CLIENT) then
	Clockwork.quickmenu:AddCommand("Встать", "Мужские анимации (male models)", COMMAND.name, {
		{"Скрестить руки", "d1_t01_BreakRoom_WatchBreen"},
		--{"Скрестить руки, сгорбиться", "d1_t02_Playground_Cit1_Arms_Crossed"},
		{"Руки в карманы", "LineIdle04"},
		--{"Руки в карманы, сгорбиться", "d1_t02_Playground_Cit2_Pockets"},
		--{"Напряженно", "scaredidle"},
		--{"Одышка", "d2_coast03_PostBattle_Idle02"},
		--{"Прятать голову", "cower_Idle"},
	});
	Clockwork.quickmenu:AddCommand("Возле стены", "Мужские анимации (male models)", COMMAND.name, {
		{"Одышка, лицом к стене", "d2_coast03_PostBattle_Idle01"},
		{"Смотреть в окно", "d1_t03_Tenements_Look_Out_Window_Idle"},
		{"Упереться в стену", "doorBracer_Closed"},
		{"Облокотиться влево", "Lean_Left"},
		{"Облокотиться назад", "Lean_Back"},
		{"Облокотиться назад, руки за спину", "plazaidle1"},
	});
	Clockwork.quickmenu:AddCommand("Присесть", "Мужские анимации (male models)", COMMAND.name, {
		{"На колено", "citizen4_preaction"},
		--{"Осматриваться", "lookoutidle"},
		--{"Изучать пол", "d1_town05_Daniels_Kneel_Idle"},
		{"На пол", "Sit_Ground"},
		{"На корты", "plazaidle4"},
	});
	Clockwork.quickmenu:AddCommand("Лечь", "Мужские анимации (male models)", COMMAND.name, {
		{"На живот, руки за голову", "arrestidle"},
		{"На спину, ранение", "d1_town05_Winston_Down"},
		{"На спину, корчиться", "d1_town05_Wounded_Idle_2"},
		--{"На спину, в развалку", "injured3"},
		{"На спину, спокойно", "Lying_Down"},
		{"На бок, корчиться", "d1_town05_Wounded_Idle_1"},
		{"На бок, спокойно", "sniper_victim_pre"},
		--{"Сексуально", "d2_coast11_Tobias"},
	});
	Clockwork.quickmenu:AddCommand("Другое", "Мужские анимации (male models)", COMMAND.name, {
		--{"Прыгать от радости", "cheer1"},
		--{"Хлопать", "cheer2"},
		{"Позвать к себе", "Wave_close"},
		--{"Позвать к себе, махать рукой", "Wave"},
		--{"Положить руки перед собой", "luggageidle"},
		--{"Протянуть руки ладонями вверх", "d2_coast03_Odessa_RPG_Give_Idle"},
	});
end;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local curTime = CurTime();

	if (player:Alive() and !player:IsRagdolled() and !player:IsNoClipping()) then
		if (!player.cwNextStance or curTime >= player.cwNextStance) then
			player.cwNextStance = curTime + 2;

			local modelClass = Clockwork.animation:GetModelClass(player:GetModel());

			if (modelClass == "maleHuman") then
				local forcedAnimation = player:GetForcedAnimation();
				
				if (forcedAnimation) then
					cwEmoteAnims:MakePlayerExitStance(player);
				else
					local anim = arguments[1];
					local forward = player:GetForward();
					
					if (COMMAND.animTable[anim]) then
						player:SetSharedVar("StancePos", player:GetPos());
						player:SetSharedVar("StanceAng", player:GetAngles());
						
						player:SetForcedAnimation(anim, COMMAND.animTable[anim]);
					elseif (COMMAND.animTableTrace[anim]) then
						local tr = util.TraceLine({
							start = player:GetPos() + Vector(0, 0, 16) + forward*35,
							endpos = player:GetPos() + Vector(0, 0, 16) - forward*35,
							filter = player
						});
						
						if (tr.Hit) then
							Clockwork.player:Notify(player, "Вам не хватает места!");
						else
							player:SetSharedVar("StancePos", player:GetPos());
							player:SetSharedVar("StanceAng", player:GetAngles());
							
							player:SetForcedAnimation(anim, 0);
						end;
					elseif (COMMAND.animTableWall[anim]) then
						local trendpos = forward*20;
						
						if (COMMAND.animTableWall[anim] == 1) then
							trendpos = forward*-20;
						elseif (COMMAND.animTableWall[anim] == 2) then
							trendpos = player:GetRight()*-20;
						end
						
						local tr = util.TraceLine({
							start = player:EyePos(),
							endpos = player:EyePos() + trendpos,
							filter = player
						});
						
						if (tr.Hit) then
							player:SetEyeAngles(tr.HitNormal:Angle() + Angle(0, 180, 0));
							player:SetSharedVar("StancePos", player:GetPos());
							player:SetSharedVar("StanceAng", player:GetAngles());
							
							player:SetForcedAnimation(anim, 0);
						else
							if (COMMAND.animTableWall[anim] == 1) then
								Clockwork.player:Notify(player, "Вы должны стоять спиной к стене!");
							elseif (COMMAND.animTableWall[anim] == 2) then
								Clockwork.player:Notify(player, "Вы должны стоять левым боком к стене!");
							else
								Clockwork.player:Notify(player, "Вы должны стоять лицом к стене!");
							end
						end;
					else
						Clockwork.player:Notify(player, "Такой анимации нет!");
					end;
				end;
			else
				Clockwork.player:Notify(player, "Ваша модель не поддерживает эту анимацию!");
			end;
		else
			Clockwork.player:Notify(player, "Вы не можете выполнить еще одну анимацию!");
		end;
	else
		Clockwork.player:Notify(player, "Вы не можете сделать это сейчас!");
	end;
end;

COMMAND:Register();