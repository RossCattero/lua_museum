local ITEM = Clockwork.item:New();
ITEM.name = "Мука";
ITEM.model = "models/props_junk/garbage_bag001a.mdl";
ITEM.weight = 0.7;
ITEM.uniqueID = "food_flour";
ITEM.category = "Прочее";

ITEM.table1 = {
    [1] = "",
    [2] = "",
    [3] = ""
};
ITEM.table2 = {
    [1] = "food_egg",
    [2] = "ross_sugar",
    [3] = "ross_sun_oil"
};

function ITEM:EntityHandleMenuOption(player, entity, option, argument)

    if (option == "Приготовить кекс") then
        for k, v in ipairs( ents.FindInSphere(entity:GetPos(), 15) ) do
            if v:IsValid() && v:GetClass() == "cw_item" && v("uniqueID") == "food_egg" && !table.HasValue(self("table1"), v("uniqueID")) then
                self("table1")[1] = v("uniqueID");
                v:Remove();
            end;
            if v:IsValid() && v:GetClass() == "cw_item" && v("uniqueID") == "ross_sugar" && !table.HasValue(self("table1"), v("uniqueID")) then
                self("table1")[2] = v("uniqueID");
                v:Remove();
            end;
            if v:IsValid() && v:GetClass() == "cw_item" && v("uniqueID") == "ross_sun_oil" && !table.HasValue(self("table1"), v("uniqueID")) then
                self("table1")[3] = v("uniqueID");
                v:Remove();
            end;
        end;
        if table.Compare(self("table1"), self("table2")) == true then
            Clockwork.entity:CreateItem(self, Clockwork.item:CreateInstance("food_cupcake"), entity:GetPos() + Vector(0, 0, 15));
            entity:Remove();
        end;
    end;
    
end;

function ITEM:GetEntityMenuOptions(entity, options)
	if (!IsValid(entity)) then
		return;
    end;
    
    options["Приготовить кекс"] = function()
		Clockwork.entity:ForceMenuOption(entity, "Приготовить кекс", nil);
    end;

end;

function ITEM:OnDrop(player, position) end;

if (CLIENT) then
	function ITEM:OnHUDPaintTargetID(entity, x, y, alpha)

        for k, v in pairs(self("table2")) do
            y = Clockwork.kernel:DrawInfo(Clockwork.item:FindByID(v)("name").."\n", x, y, Color(255, 255, 255), alpha);
        end;

		return y;
	end;
end;

ITEM:Register();