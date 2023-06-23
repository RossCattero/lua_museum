local PLUGIN = PLUGIN;

LIMB_INJURIES = {
	[DMG_GENERIC] = {
		name="Ушиб", 
		chance=95, 
		stages = 3, 
		stageList = {
			[1] = "Описание первого уровня тяжести",
			[2] = "Описание второго уровня тяжести",
			[3] = "Описание третьего уровня тяжести"	
		}
	},
	[DMG_CRUSH] = {name="Ушиб", chance=90},
	[DMG_CLUB] = {name="Ушиб", chance=80},
	[DMG_PREVENT_PHYSICS_FORCE] = {name="Ушиб", chance=99},
	[DMG_VEHICLE] = {name="Сильный ушиб", chance=95},

	[DMG_BLAST] = {name="Рваная рана", chance=95, causeBlood = true},
	[DMG_SONIC] = {name="Рваная рана", chance=90, causeBlood = true},
	[DMG_NEVERGIB] = {name="Рваная рана", chance=95, causeBlood = true},
	[DMG_ALWAYSGIB] = {name="Рваная рана", chance=95, causeBlood = true},
	[DMG_DISSOLVE] = {name="Рваная рана", chance=100, causeBlood = true},
	[DMG_BLAST_SURFACE] = {name="Рваная рана", chance=99, causeBlood = true},
	[DMG_DIRECT] = {name="Рваная рана", chance=99, causeBlood = true},
	[DMG_REMOVENORAGDOLL] = {name="Рваная рана", chance=99, causeBlood = true},
	[DMG_PHYSGUN] = {name="Рваная рана", chance=95, causeBlood = true},
	[DMG_MISSILEDEFENSE] = {name="Рваная рана", chance=100, causeBlood = true},

	[DMG_DROWN] = {name="Асфиксия", chance=100},
	[DMG_DROWNRECOVER] = {name="Асфиксия", chance=100},

	-- [DMG_PARALYZE] = {name="Повреждение нервной системы", chance=100},
	-- [DMG_NERVEGAS] = {name="Повреждение нервной системы", chance=100},

	[DMG_BULLET] = {name="Пулевое ранение", chance=95, stages = 3},
	[DMG_AIRBOAT] = {name="Пулевое ранение", chance=99, stages = 3},
	[DMG_SNIPER] = {name="Пулевое ранение", chance=100, stages = 3},

	[DMG_ENERGYBEAM] = {name="Ожог", chance=99},
	[DMG_BURN] = {name="Ожог", chance=95},
	[DMG_SLOWBURN] = {name="Ожог", chance=95},
	[DMG_PLASMA] = {name="Ожог", chance=95},

	[DMG_SLASH] = {name="Порез", chance=95, causeBlood = true},

	[DMG_FALL] = {name="Перелом кости", chance=99},

	[DMG_SHOCK] = {name="Электрический ожог", chance=95},
	[DMG_POISON] = {name="Интоксикация", chance=100},
	[DMG_RADIATION] = {name="Радиационное отравление", chance=99},
	-- [DMG_ACID] = {name="Химический ожог", chance=95},
}