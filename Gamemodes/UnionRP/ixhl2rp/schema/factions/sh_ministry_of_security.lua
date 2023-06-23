
FACTION.name = "Министерство государственной безопасности"
FACTION.description = "Министерство, направленное на защиту государственных тайн и задач"
FACTION.color = Color(61, 47, 159, 255)
FACTION.isDefault = false
FACTION.models = {};

for i = 1, 9 do 
	table.insert(FACTION.models, 'models/union/dark_guard/male_0'..i..'.mdl')
	ix.anim.SetModelClass('models/union/dark_guard/male_0'..i..'.mdl', "metrocop")
end;
for i = 10, 17 do 
	table.insert(FACTION.models, 'models/union/dark_guard/male_'..i..'.mdl')
	ix.anim.SetModelClass('models/union/dark_guard/male_'..i..'.mdl', "metrocop")
end;

FACTION_MINISRY_OF_SECURITY = FACTION.index