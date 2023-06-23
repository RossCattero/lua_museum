ITEM.name = "ПДА"
ITEM.description = ""
ITEM.model = Model("models/nirrti/tablet/tablet_sfm.mdl");
ITEM.skin = 11;

ITEM.functions.TakeALook = {
    name = "Посмотреть",
    OnRun = function(item)
        local pdaData = ix.data.Get("DataInformation");
        local chatList = ix.data.Get("PDAChat");
        netstream.Start(item.player, "OpenPDA", pdaData, chatList);

        return false;
    end,
    OnCanRun = function(item)
        return !item.entity;
    end
}