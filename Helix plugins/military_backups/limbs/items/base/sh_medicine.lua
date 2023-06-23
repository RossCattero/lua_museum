local PLUGIN = PLUGIN;

ITEM.name = "Таблетки"
ITEM.description = ""
ITEM.model = "models/props_junk/cardboard_box003a.mdl"
ITEM.category = 'Медицина'
ITEM.useSound = "" -- usesound/pills.wav

ITEM.parameters = {
	/*
		Категория предмета.
		ban = Бандаж, pills = Таблетки, surge = Наборы хирургии
	*/
	cat = "",
	-- Дополнительное количество крови
	blood = 0,
	-- Количество снимаемой боли. 
	pain = 0, 
	-- Количество понижаемого болевого порога
	painMin = 0,
	-- Анафилактический шок
	shock = 0,
	-- Убрать воспаление на определенной конечности, шанс(Найдет все воспаленные конечности и с проверкой уберет или нет)
	inf = 0,
	-- Удалить какие-либо болезни с шансом
	sick = {cough = 50},
	-- Количество
	amount = 1,
	/*
		Бонусы, которые начисляются персонажу при использовании препарата или предмета.
		Могут быть как положительными, так и отрицательными.
	*/
	bonuses = {
	/*
		["pain"] = {
			// Количество
			amount = 10,
			// Время, через которое пропадет
			time = CurTime() + 30
		},
	*/
	},
	/*
		Список повреждений, которые можно вылечить.
		Содержит значение стадии, ниже или равное которому оно вылечит.
	*/
	canHeal = {
		-- [DMG_GENERIC] = 1,
		-- [DMG_CRUSH] = 1,
	},
	/* 
		Эффективность предмета лечения
		Это значение прибавляется к количеству лечения ранения раз в секунду
		Когда количество доходит до 100 - рана считается вылеченной
	*/
	efficiency = 0,
	-- Количество времени, в течении которого будет идти эффект лечения.
	addTime = 0,
	-- Время использования
	useTime = 1,
}

// TODO: Возможность использовать таблетки без перехода на страницу использования

// target: Цель, которую лечат
// data: {Кость, индекс}
function ITEM:Use(target, data)
	if !target || !target:IsPlayer() then return end;
	local par = self:GetParams()

	local shock, pain, min = par.shock, par.pain, par.painMin

	local bandage = self:IsBandages();

	if shock && shock > 0 then target:AddShock( shock + (target:GetShock() * (1 + (LIMB.ADD_SHOCK/100))) ) end;
	if min && min > 0 then target:SetMinHurt( -min ) end;
	if pain && pain > 0 then target:AddHurt( -pain ) end

	if bandage then
		local limbs = target:GetLimbs();
		local bone, inj = unpack(data);
		local injury = limbs[bone][inj]
		
		if injury && injury.heal == "" then
			target:SetHeal(bone, inj, self.uniqueID)
		end;
	end;

	// TODO: Добавить эффект от получения шока
	self:UpdateAmount(target)
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
function ITEM:UpdateAmount(target)
	local amount = self:GetAmount()
	amount = amount - 1;
	
	self:SetData("Amount", amount)
	target:EmitSound(self.useSound)
	if amount <= 0 then self:Remove(); end

	return amount
end;

function ITEM:GetMedCategory()
	return self:GetParams().cat;
end;

// Предмет является таблетками
function ITEM:IsPills()
	return self:GetMedCategory() == "pills"
end;

// Предмет для перевязки
function ITEM:IsBandages()
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
function ITEM:GetCanHeal(index)
	local par = self:GetParams()
	return LIMB.INJURIES[index] && par.canHeal && par.canHeal[index]
end;

// Получить эффективность лечения
function ITEM:GetHealEfficiency(default)
	return self:GetParams().efficiency or default
end;

// Получить время, в течении которого будет лечение
function ITEM:GetHealTime(default)
	return self:GetParams().addTime or default
end;