
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("CharForceFallOver");
COMMAND.tip = "Временный ввод в безсознательное состояние.";
COMMAND.text = "<имя_персонажа> [время]";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		if (target:Alive()) then
			if (!target:IsFrozen()) then
				local time = tonumber(arguments[2]);		
				if (!time) then
					time = 0;
				else
					time = math.max(math.Round(time), 0);
				end;

				local icon = "arrow_up";
				if (time > 0) then
					icon = "arrow_down";
				end;

				Clockwork.player:SetRagdollState(target, RAGDOLL_KNOCKEDOUT, time);

				if (target != player) then
					if (Clockwork.config:Get("global_echo"):Get()) then
						for k, v in pairs(_player.GetAll()) do
							if (v != player and v != target) then
								v:CPNotify(player:Name().." ввел "..target:Name().." в безсознательное состояние на "..time.."s.", icon);
							end;
						end;
					end;

					player:CPNotify("Вы ввели "..target:Name().." в безсознательное состояние "..time.."s.", icon);
					target:CPNotify(player:Name().." ввел Вас в безсознательное состояние на "..time.."s.", icon);
				else
					if (Clockwork.config:Get("global_echo"):Get()) then
						for k, v in pairs(_player.GetAll()) do
							if (v != player) then
								v:CPNotify(player:Name().." ввел себя в безсознательное состояние "..time.."s.", icon);
							end;
						end;
					end;

					player:CPNotify("Вы ввели себя в безсознательное состояние на "..time.."s.", icon);
				end;
			else
				player:CPNotify(target:Name().." заморожен!", Clockwork.option:GetKey("cannot_do_icon"));
			end;
		else
			player:CPNotify(target:Name().." мертв!", Clockwork.option:GetKey("cannot_do_icon"));
		end;
	else
		player:CPNotify(arguments[1].." несуществующий игрок!", Clockwork.option:GetKey("invalid_target_icon"));
	end;
end;

COMMAND:Register();