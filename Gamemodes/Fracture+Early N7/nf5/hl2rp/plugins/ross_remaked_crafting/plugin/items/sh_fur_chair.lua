local ITEM = Clockwork.item:New("furniture_base");
ITEM.name = "Чертеж студа";
ITEM.uniqueID = "fur_wood_chair";
ITEM.weight = 0.3;
ITEM.furmodel = "models/props_c17/FurnitureChair001a.mdl";
ITEM.blueprint = {
	["items"] = {
        materials_wood = 4,
        materials_nails_box = 1
    },
	["instruments"] = {
        tfa_nmrih_bcd = 1
    }
};


ITEM:Register();