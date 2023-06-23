
FACTION.name = "Министерство правопорядка"
FACTION.description = "Министерство правопорядка - министерство, целью которого является поддержание порядка в городе."
FACTION.color = Color(55, 123, 32)
FACTION.pay = 10
FACTION.models = {
	"models/union/metropolice/female_01.mdl",
	"models/union/metropolice/female_02.mdl",
	"models/union/metropolice/female_03.mdl",
	"models/union/metropolice/female_04.mdl",
	"models/union/metropolice/female_05.mdl",
	"models/union/metropolice/female_06.mdl",
	"models/union/metropolice/female_07.mdl"
}

for i = 1, 9 do 
	table.insert(FACTION.models, 'models/union/metropolice/male_0'..i..'.mdl')
	ix.anim.SetModelClass('models/union/metropolice/male_0'..i..'.mdl', "metrocop")
end;
for i = 10, 17 do 
	table.insert(FACTION.models, 'models/union/metropolice/male_'..i..'.mdl')
	ix.anim.SetModelClass('models/union/metropolice/male_'..i..'.mdl', "metrocop")
end;

FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {[0] = "NPC_MetroPolice.RunFootstepLeft", [1] = "NPC_MetroPolice.RunFootstepRight"}

function FACTION:GetDefaultName(client)
	return "MPF-RCT." .. Schema:ZeroNumber(math.random(1, 99999), 5), true
end

function FACTION:OnTransfered(client)
	local character = client:GetCharacter()

	character:SetName(self:GetDefaultName())
	character:SetModel(self.models[1])
end

function FACTION:OnNameChanged(client, oldValue, value)
	local character = client:GetCharacter()
end

FACTION_MINISTERY_OF_ORDER = FACTION.index
