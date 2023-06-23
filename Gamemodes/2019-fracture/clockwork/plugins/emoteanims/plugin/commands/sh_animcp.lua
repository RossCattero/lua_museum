--[[
	© 2014 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local COMMAND = Clockwork.command:New("AnimCps");
COMMAND.tip = "Набор анимаций для Гражданской Обороны.";
COMMAND.text = "<анимация>";
COMMAND.arguments = 1;
COMMAND.animTable = {
	["stopwomanpre"] = 0,
	["adoorknock"] = 0,
	
	["harassfront2"] = 2,
	["motionleft"] = 2,
	["motionright"] = 2,
	["plazathreat1"] = 5,
	["plazathreat2"] = 5,
	["kickdoorbaton"] = 2
};
COMMAND.animTableWall = {
	["Idle_Baton"] = 0,
};

if (CLIENT) then
	Clockwork.quickmenu:AddCommand("Встать", "Гражданская Оборона", COMMAND.name, {
		{"Устойчиво.", "stopwomanpre"},

		{"Стучать вбок.", "adoorknock"},
	});
	Clockwork.quickmenu:AddCommand("Облокотиться", "Гражданская Оборона", COMMAND.name, {
		{"Нервно облокотиться.", "Idle_Baton"},
	});
	Clockwork.quickmenu:AddCommand("Направление и прочее", "Гражданская Оборона", COMMAND.name, {
		{"Запрет.", "harassfront2"},
		{"Указать направо.", "motionright"},		
		{"Указать налево.", "motionleft"},
		{"Стучать дубинкой.", "plazathreat2"},		
		{"Крутить дубинку.", "plazathreat1"},
		{"Выбить", "kickdoorbaton"}
	});
end;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local curTime = CurTime();

	if (player:Alive() and !player:IsRagdolled() and !player:IsNoClipping()) then
		if (!player.cwNextStance or curTime >= player.cwNextStance) then
			player.cwNextStance = curTime + 2;

			local modelClass = Clockwork.animation:GetModelClass(player:GetModel());

			if (modelClass == "civilProtection") then
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
					elseif (COMMAND.animTableWall[anim]) then
						local tr = util.TraceLine({
							start = player:EyePos(),
							endpos = player:EyePos() + forward*-20,
							filter = player
						});
						
						if (tr.Hit) then
							player:SetEyeAngles(tr.HitNormal:Angle() + Angle(0, 180, 0));
							player:SetSharedVar("StancePos", player:GetPos());
							player:SetSharedVar("StanceAng", player:GetAngles());
							
							player:SetForcedAnimation(anim, 0);
						else
							Clockwork.player:Notify(player, "Вы должны стоять лицом к стене!");
						end;
					else
						Clockwork.player:Notify(player, "Такой анимации не существует!");
					end;
				end;
			else
				Clockwork.player:Notify(player, "Вы не можете сделать эту анимацию из-за модели!");
			end;
		else
			Clockwork.player:Notify(player, "Вы не можете сделать еще одну анимацию!");
		end;
	else
		Clockwork.player:Notify(player, "Вы не можете сделать это сейчас!");
	end;
end;

COMMAND:Register();