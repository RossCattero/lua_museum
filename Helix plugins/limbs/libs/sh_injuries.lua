local PLUGIN = PLUGIN;

--[[
-- Название травмы
name = "Ушиб",

-- Шанс, с которым будет вызвано повреждение
chance = 95,

-- Количество урона, сколько будет отправлено от полученного урона в часть тела
percent = 90,

-- Количество уровней тяжести
stages = 3,

-- Вызывает ли кровотечение.
causeBlood = false, 

-- Может ли гноиться часть тела из-за этой раны.
canInfect = false,

-- Сколько времени потребуется, чтобы исправиться или загноиться. Если не установлено, то будет использована константа "LIMB_ROT_TIME"
injTime = 60,

-- Описание, которое появится при наведении на травму;
stageList = { 
	[1] = "Описание первого уровня тяжести",
	[2] = "Описание второго уровня тяжести",
	[3] = "Описание третьего уровня тяжести"	
}

]]--

LIMB_INJURIES = {
	[DMG_GENERIC] = {
		name = "Ушиб",
		chance = 95,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_CRUSH] = {
		name="Ушиб", 
		chance=90,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_CLUB] = {
		name="Ушиб", 
		chance=80,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_PREVENT_PHYSICS_FORCE] = {
		name="Ушиб", 
		chance=99,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_VEHICLE] = {
		name="Сильный ушиб", 
		chance=95,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_BLAST] = {
		name="Рваная рана", 
		chance=95,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[134217792] = {
		name="Рваная рана", 
		chance=100,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	}, // Взрывной урон, не документирован
	[DMG_SONIC] = {
		name="Рваная рана", 
		chance=90,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_NEVERGIB] = {
		name="Рваная рана", 
		chance=95,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_ALWAYSGIB] = {
		name="Рваная рана", 
		chance=95,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_DISSOLVE] = {
		name="Рваная рана", 
		chance=100,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_BLAST_SURFACE] = {
		name="Рваная рана", 
		chance=99,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_DIRECT] = {
		name="Рваная рана", 
		chance=99,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_REMOVENORAGDOLL] = {
		name="Рваная рана", 
		chance=99,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_PHYSGUN] = {
		name="Рваная рана", 
		chance=95,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_MISSILEDEFENSE] = {
		name="Рваная рана", 
		chance=100,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_DROWN] = {
		name="Асфиксия", 
		chance=100,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_BULLET] = {
		name="Пулевое ранение", 
		chance=95,
		percent = 90, 
		stages = 3, 
		causeBlood = true, 
		canInfect = true, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_AIRBOAT] = {
		name="Пулевое ранение", 
		chance=99,
		percent = 90, 
		stages = 3, 
		causeBlood = true, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_SNIPER] = {
		name="Пулевое ранение", 
		chance=100,
		percent = 100, 
		stages = 3, 
		causeBlood = true, 
		canInfect = true, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},

	[DMG_ENERGYBEAM] = {
		name="Ожог",
		percent = 10, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_BURN] = {
		name="Ожог", 
		chance=95,
		percent = 10, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_SLOWBURN] = {
		name="Ожог", 
		chance=95,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_PLASMA] = {
		name="Ожог", 
		chance=95,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_SLASH] = {
		name="Порез", 
		chance=95,
		percent = 10, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_FALL] = {
		name="Перелом кости", 
		chance=99,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		injTime = 10,
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_SHOCK] = {
		name="Электрический ожог",
		chance=95,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_POISON] = {
		name="Интоксикация", 
		chance=100,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[8197] = {
		name="Ушиб", 
		chance=100,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[4202501] = {
		name="Ушиб", 
		chance=100,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[4098] = {
		name="Пулевое ранение", 
		chance=100,
		percent = 90, 
		stages = 3, 
		causeBlood = false, 
		canInfect = false, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[536870914] = {
		name="Картечь", 
		chance=100,
		percent = 90, 
		stages = 3, 
		causeBlood = true, 
		canInfect = true, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[536875010] = {
		name="Пулевое ранение", 
		chance=100,
		percent = 90, 
		stages = 3, 
		causeBlood = true, 
		canInfect = true, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},

}

LIMB_PAIN = {
	{name = "Легкая боль", min = 5, max = 25},
	{name = "Боль", min = 25, max = 50},
	{name = "Сильная боль", min = 50, max = 75},
	{name = "Агония", min = 75, max = 1000},
}

LIMB_STAGES = {
	{rim = "I", min = 5, max = 25},
	{rim = "II", min = 25, max = 50},
	{rim = "III", min = 50, max = 75},
	{rim = "IV", min = 75, max = 1000},
}

function LIMB_INJURIES:CanRot(index)
	return LIMB_INJURIES[index] && LIMB_INJURIES[index].canInfect
end;