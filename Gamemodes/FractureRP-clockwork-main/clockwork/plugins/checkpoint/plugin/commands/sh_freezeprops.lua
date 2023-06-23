
local COMMAND = Clockwork.command:New("FreezeProps");
COMMAND.tip = "Freezes all props.";
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local props = ents.GetAll()
	local counter = 0;

	for k, prop in pairs(props) do
		local physicsObject = prop:GetPhysicsObject()
		if IsValid(physicsObject) then
			physicsObject:Sleep()
			physicsObject:EnableMotion(false)
			counter = counter + 1;
		end;
	end;

	player:CPNotify("You have frozen "..counter.." props.", "lock");
end;

COMMAND:Register();

function FrozeAllEnts()
	local props = ents.GetAll()
	local counter = 0;

	for k, prop in pairs(props) do
		local physicsObject = prop:GetPhysicsObject()
		if IsValid(physicsObject) then
			physicsObject:Sleep()
			physicsObject:EnableMotion(false)
			counter = counter + 1
		end
	end
end