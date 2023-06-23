local ITEM = Clockwork.item:New("furniture_base");
ITEM.name = "Железный шкаф";
ITEM.uniqueID = "iron_locker_bp";
ITEM.weight = 0.2;
ITEM.furmodel = "models/props_wasteland/controlroom_storagecloset001a_old.mdl";
ITEM.blueprint = {
	["items"] = {
        materials_metal_p = 4,
        materials_metal_podd = 4
    },
	["instruments"] = {
        ross_pajalnek = 1
    }
};


ITEM:Register();