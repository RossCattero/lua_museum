local PLUGIN = PLUGIN;

ITEM.name = "A paper check"
ITEM.model = "models/props_c17/paper01.mdl"
ITEM.description = "Can be used to take money from your account."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 0
ITEM.category = "Bureaucracy"

ITEM.functions.Sign = {
	name = "Look",
	onRun = function(item)
			local user = item.player;
			local data = item:getData("checkData")

			netstream.Start(user, 'bank::showCheck', data)
			return false;
	end,
	onCanRun = function(item)
			local user = item.player;
			local char = user:getChar();

			return char:getData("banking_account") != 0
	end,
}

function ITEM:onInstanced(id)
		if !self:getData("checkData") then
				local data = pon.encode({
						amount = 0,
						orderFor = "",
						sign = "",
						checkID = math.random(1000, 9999),
						itemID = self:getID(),
						whoIs = "",
				})
				self:setData("checkData", data);
		end
end