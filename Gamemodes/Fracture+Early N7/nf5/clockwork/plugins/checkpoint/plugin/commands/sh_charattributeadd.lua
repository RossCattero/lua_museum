
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("CharAttributeAdd");
COMMAND.tip = "Добавить +(количество) к атрибуту персонажа.";
COMMAND.text = "<имя_персонажа> <атрибут> <количество>";
COMMAND.access = "s";
COMMAND.arguments = 3;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		local amount = tonumber(arguments[3]);
		if (amount and amount > 0) then
			local success, err = Clockwork.attributes:Update(target, arguments[2], amount);
			if (!success) then
				if (!err) then
					err = "Что-то пошло не так!"
				end;
			    player:CPNotify(err, Clockwork.option:GetKey("cannot_do_icon"));
			else
				if (Clockwork.config:Get("global_echo"):Get()) then
					for k, v in pairs(_player.GetAll()) do
						if (v != player and v != target) then
							v:CPNotify(player:Name().." добавил "..amount.." к "..target:Name().."'s "..arguments[2]..".", "add");
						end;
					end;
				end;

				player:CPNotify("Вы добавили "..amount.." к "..target:Name().."'s "..arguments[2]..".", "add");
				target:CPNotify(player:Name().." добавил "..amount.." к Вашему "..arguments[2]..".", "add");
			end;
		else
			player:CPNotify("Вы должны ввести нормальное количество!", Clockwork.option:GetKey("cannot_do_icon"));
		end;
	else
		player:CPNotify(arguments[1].." несуществующий игрок!", Clockwork.option:GetKey("invalid_target_icon"));
	end;
end;

COMMAND:Register();