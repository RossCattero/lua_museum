local ITEM = Clockwork.item:New("medic_base");
ITEM.name = "Таблетки для улучшения иммунитета";
ITEM.model = "models/frp/props/models/rad_pills.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "med_immunitet";
ITEM.usesound = 'usesound/pills.mp3'
ITEM.immunity = 100;

ITEM:Register();