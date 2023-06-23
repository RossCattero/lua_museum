local PLUGIN = PLUGIN;

ITEM.name = "Таблетки"
ITEM.description = ""
ITEM.model = "models/props_junk/cardboard_box003a.mdl"
ITEM.category = 'Медицина'
ITEM.useSound = "usesound/pills.wav"

ITEM.parameters = {
	-- Количество боли
	givePain = 0, 
	-- Болевой порог
	painStep = 0,
	-- Анафилактический шок
	anaphShock = 0,
	-- Убрать воспаление на определенной конечности, шанс(Найдет все воспаленные конечности и с проверкой уберет или нет)
	remInf = 0,
	-- Удалить какие-либо болезни с шансом
	remSick = {cough = 50},
	-- Количество
	amount = 1,
}

ITEM.functions.Give = {
	name = "Передать",
	OnRun = function(self)
		
	end,
	OnCanRun = function(self)
		local player = self.player;
		local trace = player:GetEyeTraceNoCursor();

		return player && trace && trace.Entity:IsPlayer() && trace.Entity:GetPos():DistToSqr( player:GetPos() ) <= 512 * 512
	end
}

function ITEM:OnUse(target, bone)
	if !target then return end;
	if !target:IsPlayer() || !target:IsValid() then return end;
	local amount = self:GetAmount()

	-- tut

	amount = amount - 1;

	self:SetData("Amount", amount)
	target:EmitSound(self.useSound)

	if amount <= 0 then
		self:Remove();
	end
end;

function ITEM:OnInstanced()
	if !self:GetData("Amount") then
		self:SetData("Amount", self:MaxAmount())
	end
end;

//
function ITEM:MaxAmount()
	return self.parameters.amount or 1
end;

function ITEM:GetAmount()
	return self:GetData("Amount")
end;