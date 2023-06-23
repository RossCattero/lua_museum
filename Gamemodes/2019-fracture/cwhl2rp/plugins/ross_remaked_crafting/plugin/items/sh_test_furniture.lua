local ITEM = Clockwork.item:New("furniture_base");
ITEM.name = "Чертеж кресла";
ITEM.uniqueID = "test_furniture";
ITEM.weight = 0.5;
ITEM.furmodel = "models/props_interiors/Furniture_Couch02a.mdl";
ITEM.blueprint = {
	["items"] = {
        c_book_one = 2
    },
	["instruments"] = {}
};


ITEM:Register();