local INJURY = INJURIES.meta or {}

/*
	.name: Название повреждения, которое будет отображаться на теле
	.index: Индекс повреждения из глобальной таблицы игры
	.appearChance: При попадании высчитывается вероятность появления этого повреждения. Чем выше - тем больше шанс
	.damagePercent: Процент урона, который сконвертируется в боль при получении повреждения.
	.causeInfection: Вызовет ли инфекцию через определенное количество времени.
	.stages: При попадании, в зависимости от урона, накладывается стадия повреждения. Каждая из них имеет описание.
	.causeBleeding: Вызывает ли кровотечение.
	.woundTime: Время до исправления(удаления) повреждения. При наличии .causeInfection в true - вызывает инфекцию
	.stageCritical: Критическая стадия
*/

INJURY.__index = INJURY

INJURY.name = "Неизвестно"
INJURY.index = DMG_GENERIC
INJURY.appearChance = 0
INJURY.damagePercent = 0
INJURY.woundTime = 60;
INJURY.causeBleeding = false
INJURY.causeInfection = false
INJURY.stageCritical = 3;
INJURY.stages = {}

function INJURY:__tostring()
	return "INJURY["..self.uniqueID.."]"
end

function INJURY:__eq(other)
	return self:GetID() == other:GetID()
end

function INJURY:GetID()
	return self.id
end

function INJURY:GetOwner()
	return self.charID
end;

function INJURY:SetData(key, value)
	self.data = self.data || {}

	self.data[key] = value

	self:Network()
end;

function INJURY:GetData(key, default)
	return self.data[key] || default
end

function INJURY:IsLegs()
	local bone = self:GetData("bone");

	return bone:match("foot") || bone:match("leg")
end;

function INJURY:IsHead()
	local bone = self:GetData("bone");

	return bone:match("head")
end

function INJURY:IsInfected()
	return self:GetData("Infected", false)
end;

function INJURY:IsHealed()
	return self:GetData("heal", false)
end;

function INJURY:IsBleeding()
	return self:GetData("bleed", 0) > 0
end;

function INJURY:CanInfect()
	return self.causeInfection
end;

function INJURY:GetInfected()
	return self:GetData("Infected")
end;

function INJURY:Infect()
	if self:CanInfect() then
		self:SetData("Infected", true)

		self:SetData("expire", os.time() + LIMBS.ROT_TIME)
	end;
end;

function INJURY:GetOwner()
	return self.charID && ix.char.loaded[ self.charID ]
end;

function INJURY:Remove()
	local char = self:GetOwner()

	if char then
		local owner = char.player;
		if owner then
			owner:Blood( nil, -self:GetData("bleed") )

			owner:RemoveInjByID( self.id )
		end
	end

	INJURIES.INSTANCES[ self.id ] = nil;

	if self:GetOwner() then
		netstream.Start(self:GetOwner(), "NETWORK_INJURY_REMOVE", self:GetID())
	end;
end;

function INJURY:CanRemove()
	local expire = self:GetData("expire");

	return expire && expire >= os.time() && !self:CanInfect()
end;

function INJURY:Network()
	if self:GetOwner() then
		netstream.Start(self:GetOwner(), "NETWORK_INJURY_INSTANCE", self.index, self:GetID(), self.data)
	end;
end;

function INJURY:Heal( uniqueID )
	local item = ix.item.list[uniqueID];
	if item then
		self:SetData("heal", uniqueID)
		self:SetData("healTime", os.time() + item:GetHealTime())
	else
		self:SetData("heal", '')
		self:SetData("healTime", 0)
	end;

	self:SetData("occured", os.time())

	self:Network()
end;

INJURIES.meta = INJURY