local ITEM = Clockwork.item:New("medic_base");
ITEM.name = "Сироп от кашля";
ITEM.model = "models/mosi/fallout4/props/aid/daytripper.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "med_cough_syrop";

ITEM.symRem = {
    cough = 90
};

ITEM:Register();