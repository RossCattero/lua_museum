--[[
	© 2014 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local COMMAND = Clockwork.command:New("AnimCit");
COMMAND.tip = "Анимации для граждан, повстанцев.";
COMMAND.text = "<анимация>";
COMMAND.arguments = 1;
COMMAND.animTable = {
	["d1_t01_BreakRoom_WatchBreen"] = 0,
	["d1_t02_Playground_Cit1_Arms_Crossed"] = 0,
	["LineIdle04"] = 0,
	["d1_t02_Playground_Cit2_Pockets"] = 0,
	["scaredidle"] = 0,
	["d2_coast03_PostBattle_Idle02"] = 0,

	["lookoutidle"] = 0,
	["d1_town05_Daniels_Kneel_Idle"] = 0,
	["Sit_Ground"] = 0,
	["plazaidle4"] = 0,

	["cheer2"] = 3,
	["Wave_close"] = 3,
	["Wave"] = 3,
	["luggageidle"] = 0,
};

COMMAND.animTableTrace = {
	["arrestidle"] = 0,
	["d1_town05_Winston_Down"] = 0,
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
	Clockwork.quickmenu:AddCommand("Встать", "Стандартные", COMMAND.name, {
		{"Скрестить руки.", "d1_t01_BreakRoom_WatchBreen"},
		{"Напрячься.", "scaredidle"},
		{"Отдышаться.", "d2_coast03_PostBattle_Idle02"},		
		{"Засунуть руки в карманы.", "LineIdle04"},		
	});
	Clockwork.quickmenu:AddCommand("Облокотиться", "Стандартные", COMMAND.name, {
		{"Отдышаться, облокотившись о стену.", "d2_coast03_PostBattle_Idle01"},		
		{"Лечь на стену.", "doorBracer_Closed"},
		{"Облокотиться назад.", "Lean_Back"},		
		{"Облокотиться налево.", "Lean_Left"},
	});
	Clockwork.quickmenu:AddCommand("Сесть", "Стандартные", COMMAND.name, {
		{"На пол.", "Sit_Ground"},
		{"К стене.", "plazaidle4"},	
	});
	Clockwork.quickmenu:AddCommand("Прилечь", "Стандартные", COMMAND.name, {
		{"Руки на живот.", "arrestidle"},
		{"Словно ранен.", "d1_town05_Winston_Down"},
		{"Спокойно, отдыхая.", "Lying_Down"},
		{"Расслабившись.", "d2_coast11_Tobias"},		
		{"На бок, словно ранен.", "d1_town05_Wounded_Idle_1"},
		{"На бок, спокойно.", "sniper_victim_pre"},
	});
	Clockwork.quickmenu:AddCommand("Прочее.", "Стандартные", COMMAND.name, {
		{"Позвать к себе", "Wave_close"},
		{"Похлопать.", "cheer2"},		
		{"Позвать к себе, махать рукой", "Wave"},
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
							Clockwork.player:Notify(player, "Вам что-то мешает!");
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