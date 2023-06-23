local ITEM = Clockwork.item:New("furniture_base");
ITEM.name = "Чертеж шкафа";
ITEM.uniqueID = "wooden_locker_bp";
ITEM.weight = 0.3;
ITEM.furmodel = "models/props_c17/FurnitureDresser001a.mdl";
ITEM.blueprint = {
	["items"] = {
        materials_wood_pallet = 4,
        materials_wood = 4,
        materials_nails_box = 1
    },
	["instruments"] = {
        tfa_nmrih_bcd = 1
    }
};


ITEM:Register();