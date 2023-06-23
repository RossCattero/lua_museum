
ITEM.name = "ПДА"
ITEM.model = Model("models/kek1ch/dev_pda.mdl")
ITEM.description = "Специальный ПДА для связи со сталкерами в Зоне."
ITEM.category = "Информация"
ITEM.uniqueID = 'ross_stalker_pda'
ITEM.width = 1
ITEM.weight = 0.3
ITEM.height = 1
ITEM.noBusiness = true

ITEM.functions.CheckPDA = {
	name = "Посмотреть",
	OnRun = function(item)
		netstream.Start(item.player, "STALKER_OPENPDA", item:GetData('messageID'))
		return false
	end
}

function ITEM:OnInstanced()
	if !self:GetData('password') then
		self:SetData('password', "")
		self:SetData('messageID', os.time() + math.random(1, 100000))
		self:SetData('allmessages', {})
		self:SetData('notes', {})
	end;
end;