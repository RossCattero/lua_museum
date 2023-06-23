ITEM.name = "A paper check"
ITEM.model = "models/props_c17/paper01.mdl"
ITEM.description = "Can be used to transfer money between accounts."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 0
ITEM.category = "Bureaucracy"

ITEM.functions.Sign = {
	name = "Sign",
	onRun = function(item)
		local user = item.player;

		net.Start("nut.banking.check.open")
			net.WriteString( item:getID() )
			net.WriteString( item:getData("accountSender") )
			net.WriteString( item:getData("amount") )
			net.WriteString( item:getData("orderFor") )
			net.WriteString( item:getData("nameReceiver") )
			net.WriteBool( item:getData("submited") )
		net.Send( user )

		return false;
	end,
	onCanRun = function(item)
		local user = item.player;

		return !item:getData("submited") && nut.banking.instances[ user:getChar():getID() ] && !item.entity
	end,
}

ITEM.functions.Look = {
	name = "Look",
	onRun = ITEM.functions.Sign.onRun,
	onCanRun = function(item)
		return item:getData("submited")
	end,
}

function ITEM:onInstanced(id)
	if !self:getData("submited") then
		self:setData("accountSender", 0)
		self:setData("amount", 0);
		self:setData("orderFor", "");
		self:setData("nameReceiver", "");
		self:setData("submited", false)
	end
end