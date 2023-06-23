local PLUGIN = PLUGIN;

ITEM.name = "Таблетки"
ITEM.description = ""
ITEM.model = "models/props_junk/cardboard_box003a.mdl"
ITEM.category = 'Медицина'
ITEM.useSound = "ui/mainprocess.wav"

/*
	ITEM.parameters:
		category: Категория предмета. ban = Бандаж, pills = Таблетки, surge = Наборы хирургии
		blood: Количество крови для восстановления
		pain: Количество снимаемой боли после применения одной таблетки.
		painMin: Количество понижаемого болевого порога.
		shock: Количество добавляемого анафилактического шока.
		inf: Шанс удаления инфекции после применения. Может вернуться через определенный промежуток времени.
		sick: Хранит индекс и шанс удаляемой болезни
		amount: Максимальное количество предмета.
		bonuses: Бонусы, которые начисляются персонажу при использовании препарата или предмета.
		canHeal: Список повреждений, которые можно вылечить. Содержит значение стадии, ниже или равное которому оно вылечит.
		healTime: Количество времени, в течении которого будет идти эффект лечения.
		healAmount: Сколько будет прибавляться в течении лечения.
		useTime: Время применения или использования.
		stopBleeding: Останавливает ли кровотечение(Полностью).

	* Бандажи и наборы хирургии можно использовать только на персонаже и его частях тела.
	Таблетки можно есть, они действуют "глобально".
	* Бандажи можно нанести на раны. И если они имеют параметр 'inf', то будут блокировать инфекцию до излечения.
	Таблетки убирают инфекцию на случайной части тела с определенным шансом
	* Бандажи и наборы имеют время, в течении которого будет происходить лечение.
	Таблетки имеют моментальное действие.
*/

ITEM.parameters = {
	category = "",
	blood = 0,
	pain = 0, 
	painMin = 0,
	shock = 0,
	inf = 0,
	sick = {},
	amount = 1,
	bonuses = {},
	canHeal = {},
	healTime = 0,
	healAmount = 0,
	useTime = 1,
	stopBleeding = false,
}

// target: Цель, которую лечат
// data: {Кость, индекс}
function ITEM:Heal(target, bone, index)
	local par = self:GetParams()
	local limbs = target:GetLimbs()

	local id = bone && index && limbs[bone][index]
	local Wound = INJURIES.Find(id)
	local canHeal = Wound && self:CanHeal( Wound.index );

	local shock, pain, min, blood = par.shock, par.pain, par.painMin, par.blood

	if self:IsPills() then
		target:Shock( (shock || 0) + (target:GetShock() * (1 + (LIMBS.ADD_SHOCK/100))) ) 
		target:SetHurt( pain || 0, min || 0 ) 
		target:Blood( 0, self:CanStopBleeding() && -target:GetBleed() )
		
		if par.inf && par.inf > 0 then
			math.randomseed(os.time())

			if Wound:GetInfected() && math.random(100) <= self:GetInfChance(100) then
				Wound:SetData("Infected", false)
				Wound:SetData("expire", os.time() + Wound.woundTime )
			end
		end
	end;

	if self:CanStopBleeding() then
		target:Blood( blood || 0, (Wound && -Wound:GetData("bleed", 0)) )
	end;

	if (self:IsSurgeon() || self:IsBandage()) && canHeal then
		Wound:Heal( self.uniqueID )
	end;

	self:UpdateAmount(target)
	
	target:EmitSound(self.useSound)
end;

function ITEM:OnInstanced()
	if !self:GetData("Amount") then
		self:SetData("Amount", self:MaxAmount())
	end
end;

function ITEM:GetParams()
	return self.parameters
end;

// Максимальное количество предмета
function ITEM:MaxAmount()
	return self:GetParams().amount or 1
end;

// Актуальное количество предмета
function ITEM:GetAmount()
	return self:GetData("Amount")
end;

// Обновление количетва предмета
function ITEM:UpdateAmount()
	local amount = self:GetAmount()
	amount = amount - 1;
	
	self:SetData("Amount", amount)
	if amount <= 0 then self:Remove(); end

	return amount
end;

function ITEM:GetMedCategory()
	return self:GetParams().category;
end;

// Предмет является таблетками
function ITEM:IsPills()
	return self:GetMedCategory() == "pills"
end;

// Предмет для перевязки
function ITEM:IsBandage()
	return self:GetMedCategory() == "ban"
end;

// Предмет для хирургии
function ITEM:IsSurgeon()
	return self:GetMedCategory() == "surge"
end;

// Предмет болеутоляющий
function ITEM:IsPainkiller()
	local params = self:GetParams();
	return self:IsPills() && params.pain && params.pain > 0;
end;

// Может ли предмет вылечить конкретное повреждение
function ITEM:CanHeal(index)
	local params = self:GetParams()
	return INJURIES.Get(index) && (!params.canHeal || params.canHeal && params.canHeal[index]);
end;

// Получить эффективность лечения
function ITEM:GetHealEfficiency(default)
	return self:GetParams().healAmount or default
end;

// Получить время, в течении которого будет лечение
function ITEM:GetHealTime(default)
	return self:GetParams().healTime or default
end;

// Может ли остановить кровотечение
function ITEM:CanStopBleeding(default)
	return self:GetParams().stopBleeding or default
end;

// Шанс удаления заражения
function ITEM:GetInfChance(default)
	return self:GetParams().inf or default
end;