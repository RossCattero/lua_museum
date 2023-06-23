local PLUGIN = PLUGIN

local user = FindMetaTable("Player")

// Получить таблицу баффов персонажа;
function user:GetPoints()
	return self:GetCharacter():GetData("Points", {})
end;

// Получить определенный бонус;
function user:GetBonus(index)
	return self:GetPoints()[index];
end;

// Применить бонус
function user:ApplyBonus(index, data)
	local bonus = self:GetBonus(index);
	local points = self:GetPoints();

	// Обновит бонус, если уже есть подобный или установит в пустой индекс
	if !bonus then
		points[index] = data
	else
		local amount = bonus.amount;
		points[index] = data
		points[index].amount = points[index].amount + amount
	end;
	
	// Сохранить информацию о бонусах
	self:UpInfo("Points", points)
end;