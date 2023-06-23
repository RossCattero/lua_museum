local CLASS = Clockwork.class:New("Муравьиные львы")

CLASS.color = Color(120, 250, 20, 255);
CLASS.wages = false;
CLASS.factions = {FACTION_ANTLION};
CLASS.description = "Alien insect species, able to fly short distances"
CLASS.defaultPhysDesc = "An insect creature with greenish skin and wings."

CLASS_ANTLION = CLASS:Register();