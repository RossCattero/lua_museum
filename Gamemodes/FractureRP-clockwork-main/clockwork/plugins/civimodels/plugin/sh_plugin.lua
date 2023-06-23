local PLUGIN = PLUGIN;

local Clockwork = Clockwork;

FACTION_CITIZENS_FEMALE = {
	"models/frp/citizens_female_01.mdl"
}
FACTION_CITIZENS_MALE = {
	"models/frp/citizen_male_01.mdl"
}
for i = 2, 16 do 

	if i < 10 then
		table.insert(FACTION_CITIZENS_MALE, "models/frp/citizen_male_0"..i..".mdl")
		Clockwork.animation:AddMaleHumanModel("models/frp/citizen_male_0"..i..".mdl")
	else
		table.insert(FACTION_CITIZENS_MALE, "models/frp/citizen_male_"..i..".mdl")
		Clockwork.animation:AddMaleHumanModel("models/frp/citizen_male_"..i..".mdl")
	end;

end;

for i = 2, 9 do 
	table.insert(FACTION_CITIZENS_FEMALE, "models/frp/citizens_female_0"..i..".mdl")
	Clockwork.animation:AddFemaleHumanModel("models/frp/citizens_female_0"..i..".mdl")
end;