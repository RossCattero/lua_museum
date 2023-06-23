local ITEM = Clockwork.item:New("furniture_base");
ITEM.name = "Чертеж стола";
ITEM.uniqueID = "blueprint_table";
ITEM.weight = 0.2;
ITEM.furmodel = "models/props_c17/FurnitureTable001a.mdl";
ITEM.blueprint = {
	["items"] = {
        materials_wood_pallet = 1,
        materials_wood = 4,
        materials_nails_box = 1
    },
	["instruments"] = {
        tfa_nmrih_bcd = 1
    }
};


ITEM:Register();