local CLASS = Clockwork.class:New("Вортигонты");

CLASS.color = Color(255, 200, 100, 255);
CLASS.factions = {FACTION_VORT};
CLASS.isDefault = true;
CLASS.wagesName = "Доля";
CLASS.description = "Инопланетная раса с другой планеты";
CLASS.defaultPhysDesc = "Зеленое существо с красными глазами.";
	
CLASS_VORT = CLASS:Register();