
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("CharSetArmor");
COMMAND.tip = "Установить броню персонажу.";
COMMAND.text = "<имя_персонажа> [количество]";
COMMAND.access = "o";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		if (target:Alive()) then
			local amount = tonumber(arguments[2]);		
			if (!amount) then
				amount = target:GetMaxArmor();
			else
				amount = math.Clamp(math.Round(amount), 0, target:GetMaxArmor());
			end;

			local icon = "add";
			if (amount < target:Armor()) then
				icon = "delete";
			end;

			target:SetArmor(amount);

			if (target != player) then
				if (Clockwork.config:Get("global_echo"):Get()) then
					for k, v in pairs(_player.GetAll()) do
						if (v != player and v != target) then
							v:CPNotify(player:Name().." установил "..target:Name().."'s броню на "..amount..".", icon);
						end;
					end;
				end;

				player:CPNotify("Вы установили "..target:Name().."'s броню на "..amount..".", icon);
				target:CPNotify(player:Name().." установил Вашу броню на "..amount..".", icon);
			else
				if (Clockwork.config:Get("global_echo"):Get()) then
					for k, v in pairs(_player.GetAll()) do
						if (v != player) then
							v:CPNotify(player:Name().." установил свою броню на "..amount..".", icon);
						end;
					end;
				end;

				player:CPNotify("Вы установили свою броню на "..amount..".", icon);
			end;
		else
			player:CPNotify(target:Name().." мертв!", Clockwork.option:GetKey("cannot_do_icon"));
		end;
	else
		player:CPNotify(arguments[1].." несуществующий игрок!", Clockwork.option:GetKey("invalid_target_icon"));
	end;
end;

COMMAND:Register();