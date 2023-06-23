local PLUGIN = PLUGIN;

ITEM.name = "A paper check"
ITEM.model = "models/props_c17/paper01.mdl"
ITEM.description = "Can be used to transfer money between accounts."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 0
ITEM.category = "Bureaucracy"

ITEM.functions.Sign = {
	name = "Look",
	onRun = function(item)
			local user = item.player;
			local data = item:getData("check")

			netstream.Start(user, 'Banking::Check', data)
			return false;
	end,
	onCanRun = function(item)
			local user = item.player;

			return user:HasAcc()
	end,
}

function ITEM:onInstanced(id)
		if !self:getData("check") then
				local data = {
						amount = 0,
						orderFor = "",
						sign = "",
						checkID = math.random(1000, 9999),
						itemID = self:getID(),
						whoIs = "",
						accountNumber = 0,
				}
				self:setData("check", data);
		end
end