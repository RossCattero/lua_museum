include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

function ENT:OnSetData()
	self.data.factions = self.data.factions or {};
	self.data.time = self.data.time or 0;
end;

function ENT:Use(act)
	if !act:IsAdmin() then
		self:Paycheck(act)
	end;
end;

function ENT:Paycheck( act )
	local char = act:getChar();
	local faction = nut.faction.get( char:getFaction() );
	if char && faction.payout && self:CanGetPaycheck( act ) then
		local item = nut.item.get("check");
		if char:getInv():canItemFitInInventory(item, 1, 1) then
			act:notify(Format("Paychecked! Next paycheck on %s", 
			os.date("%H:%M:%S - %d/%m/%Y", char:getData("paycheckTime"))))

			char:getInv():add( "check" )
			:next(function(item)
				item:setData("accountSender", "Government")
				item:setData("amount", (faction.payout + nut.loyalty.instances[char.id].points) or 0 )
				item:setData("nameReceiver", act:GetName())
				item:setData("orderFor", "Paycheck")
				item:setData("submited", true)
			end)

			char:setData("paycheckTime", os.time() + (60 * self.data.time))
		else
			act:notify("Can't fit the paycheck in inventory.")
		end;
	else
		act:notify("You can't get the paycheck from this NPC.")
	end
end;

function ENT:CanGetPaycheck( act )
	local char = act:getChar()
	local index = char:getFaction();
	local time = char:getData("paycheckTime")

	return self.data.factions[ index ] && (!time || time < os.time())
end;