local PLUGIN = PLUGIN;
PLUGIN.getJobs = PLUGIN.getJobs or {}

function PLUGIN:PlayerLoadedChar(client, character, lastChar)
		timer.Simple(0.25, function()
			character:setData("job_info", 
					character:getData("job_info", {
						reputation = 0,
						job_id = 0,
						jobPrice = 0,
						job_name = ""
					})
			)
			client:setLocalVar("job_info", 
					character:getData("job_info")
			)
		end);
end;

function PLUGIN:CharacterPreSave(character)
		local client = character:getPlayer()
    if (IsValid(client)) then
				character:setData("job_info", 
					character:getData("job_info", {
						reputation = 0,
						job_id = 0,
						jobPrice = 0,
						job_name = ""
					})
			)
			client:setLocalVar("job_info", 
					character:getData("job_info")
			)
		end;
end;

// Pick the job for the character;
// Adds the timer for the job. When timer expires - the job for the character clears;
// Timer checks each second;
netstream.Hook('jobVendor::pickWork', function(client, workName)
		if client:GetJobID() != 0 then return end;

		if PLUGIN.jobsList[workName] then
				client:CreateJob(PLUGIN.jobsList[workName])		
				
				// send character to faction "Labourers Union of Miami"
				local faction = FACTION_LABUNION
				local fac = nut.faction.indices[faction]
				client:getChar():setFaction(faction)
				client:notify("You were transfered to faction " .. fac.name)

				local uniqueID = "WorkTime: " .. client:getChar():getID()
				timer.Create(uniqueID, 1, PLUGIN.jobsList[workName].timeForRepair, function()
						if !timer.Exists(uniqueID) || !client:IsValid() then timer.Remove(uniqueID) return; end;
						client:ClearJob()
				end);
		end;
end);

// Hook for add position of job. 
// Adds the default entity to position;
// Adds the position to job list;
// Refreshes the list to all admin players;
netstream.Hook('jobVendor::PosAdd', function(client, uniqueID)
		local vector = client:GetEyeTraceNoCursor().HitPos
		local jobList = PLUGIN.jobsList[uniqueID]

		if !client:IsAdmin() || !client:IsSuperAdmin() then			
			return;
		end
		if !jobList then
			client:notify("This job don't exists")
			return;
		end
		if #jobList >= JOBREP.vectorsAmount then
			client:notify("There's too much vectors of this job")
			return;
		end
		if (!isvector(vector) || !util.IsInWorld(vector)) then
			client:notify("This vector is not valid or not in world")
			return
		end

		// Spawn the entity;
		// This entity is DEACTIVATED until the player picks job;
		// When player picks the job - entity breaks for X seconds;
		// If there's no entities to be broken for new job - the job will be unavailable;
		local ent = ents.Create(jobList.ent)
		ent:SetPos(vector)
		ent:Spawn()

		// Add position;
		local workPos = PLUGIN:AddJobPosition(
			uniqueID, 
			tostring(vector), 
			client:GetName(), 
			ent
		)

		ent:SetWorkPos(uniqueID, workPos)
		
		// Refresh the list for all admin players;
		PLUGIN:ListRefresh(uniqueID);
end);

// Hook to remove the job from list;
// When job removes - the entity removes too;
netstream.Hook('jobVendor::removeJob', function(client, uniqueID, id)
		local jobList = PLUGIN.jobPoses[uniqueID]

		if !client:IsAdmin() || !client:IsSuperAdmin() then			
				return;
		end
		if !jobList || !jobList[id] then
				client:notify("This job don't exists")
				return;
		end

		PLUGIN:RemoveJobPosition(uniqueID, id)
end);

// v Сделать так, чтобы при выдаче задачи спавнился энтити, не поломанный
// Когда игрок берет работу - рандомный энтити из этих работ ломается, игрок перемещается во фракцию
// По окончанию работы игрок должен трансфериться обратно в базовую фраку
// Делать проверку на отсутствие игрока на сервере во время работы. Если персонаж взял работу и пропал(вышел) - работа обрывается
// При обрывании или невыполнении работы во время - у игрока снимаются очки репутации, вплоть до -100
// Сделать проверку на наличие ломаемых энтити. Если нету возможности сломать какой-либо энтити, то работа должна быть недоступна
// Не забыть про проверку на существование энтити, ведь его могут удалить.

// Система такси будет позже.

// Закончил на том, что нужно сделать хендлы для того, чтобы нельзя было брать работу, если нет доступных энтити или их уже все взяли.
// Идея: Создавать отдельные энумы для разработки таблиц, а сами таблицы делать индексированными. Это упростит работу.
// Например:
// Есть таблица или массив {["test"] = 1, ["test2"] = 6444};
// Надо создать массивы {[1] = 1, [2] = 6444}(На стороне игрока); И {[1] = "test", [2] = "test2"}(На стороне сервера). Это слегка уменьшит
// нагрузку массивов на память. Интересно...