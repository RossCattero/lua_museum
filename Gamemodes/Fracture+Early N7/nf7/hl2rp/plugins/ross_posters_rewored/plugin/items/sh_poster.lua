local ITEM = Clockwork.item:New();
ITEM.name = "Постер";
ITEM.model = "models/props_junk/garbage_bag001a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "ross_poster_item";
ITEM.useText = "Приклеить";
ITEM.category = "Прочее";

ITEM.poster = 'models/posters/poster02.mdl';

function ITEM:OnUse(player, itemEntity)

    local poster = ents.Create("ross_poster_entity");
    poster:SetModel( self('poster') );
    poster:SetPos( player:GetPos() );
    poster:Spawn();

    player:TakeItem(self);
    if IsValid(itemEntity) then
        itemEntity:Remove();
    end;
end;

function ITEM:OnDrop(player, position) end;

ITEM:Register();
