local PLUGIN = PLUGIN;

// Типизация костей. Необходима для формирования костей для модели персонажа.
PLUGIN.BONES_CONSISTS = {
	{
		bone = "leg",
		parent = "legs"
	},
	{
		bone = "foot",
		parent = "legs"
	},
	{
		bone = "calf",
		parent = "legs"
	}, 
	{
		bone = "thigh",
		parent = "legs"
	},
	{
		bone = "calf",
		parent = "legs"
	},
	{
		bone = "toe",
		parent = "legs"
	},
	{
		bone = "trapezius",
		parent = "body"
	},
	{
		bone = "spine",
		parent = "body"
	},
	{
		bone = "pectoral",
		parent = "body"
	},
	{
		bone = "pelvis",
		parent = "body"
	},
	{
		bone = "body",
		parent = "body"
	},
	{
		bone = "latt",
		parent = "body"
	},
	{
		bone = "clavical",
		parent = "body"
	},
	{
		bone = "neck",
		parent = "head"
	},
	{
		bone = "arm",
		parent = "hands"
	},
	{
		bone = "hand",
		parent = "hands"
	},
	{
		bone = "pincky",
		parent = "hands"
	},
	{
		bone = "finger",
		parent = "hands",
	},
	{
		bone = "ulna",
		parent = "hands"
	},
	{
		bone = "shoulder",
		parent = "hands"
	},
	{
		bone = "wrist",
		parent = "hands"
	},
	{
		bone = "head",
		parent = "head"
	},
}

BODY_PARTS = {
	{
		index = "head",
		name = "Голова",
		equiped = {}
	},
	{
		index = "body",
		name = "Тело",
		equiped = {}
	},
	{
		index = "hands",
		name = "Руки",
		equiped = {}
	},
	{
		index = "legs",
		name = "Ноги",
		equiped = {}
	},
	{
		index = "spine",
		name = "Спина",
		equiped = {}
	},
}

PLUGIN.protectionsList = {
	{
		index = "fire",
		name = "Огонь",
		amount = 0,
	},
	{
		index = "electro",
		name = "Электричество",
		amount = 0,
	},
	{
		index = "blunt",
		name = "Удар",
		amount = 0,
	},
	{
		index = "radiation",
		name = "Радиация",
		amount = 0,
	},
	{
		index = "chem",
		name = "Химия",
		amount = 0,
	},
	{
		index = "explosion",
		name = "Взрыв",
		amount = 0,
	},
	{
		index = "bullets",
		name = "Пули",
		amount = 0,
	},
}

// Типы урона для быстрого поиска
PLUGIN.damage = {
	[8197] = "blunt",
	[4202501] = "blunt",
	[134217792] = "explosion",
	[4098] = "bullets",
	[536875010] = "bullets",
	[134348800] = "chem",
	[DMG_CRUSH] = "blunt",
	[DMG_SLASH] = "blunt",
	[DMG_CLUB] = "blunt",
	[DMG_GENERIC] = "blunt",
	[DMG_BURN] = "fire",
	[DMG_SLOWBURN] = "fire",
	[DMG_BLAST] = "explosion",
	[DMG_BULLET] = "bullets",
	[DMG_BUCKSHOT] = "bullets",
	[DMG_SNIPER] = "bullets",
	[DMG_PLASMA] = "bullets",
	[DMG_ACID] = "chem",
	[DMG_PARALYZE] = "chem",
	[DMG_POISON] = "chem",
	[DMG_RADIATION] = "radiation",
	[DMG_SHOCK] = "electro",
}

PLUGIN.minlvl = 1;
PLUGIN.maxlvl = 3;