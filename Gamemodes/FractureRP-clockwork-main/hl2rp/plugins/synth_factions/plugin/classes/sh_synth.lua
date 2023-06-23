local CLASS = Clockwork.class:New("Синтеты");
	CLASS.color = Color(255, 165, 0, 255);
	CLASS.factions = {
		FACTION_CREMATOR,
		FACTION_GUARDER,
		FACTION_STALKER,
		FACTION_ASSASIN
	};
	CLASS.isDefault = true;
CLASS_SYNTHTETS = CLASS:Register();