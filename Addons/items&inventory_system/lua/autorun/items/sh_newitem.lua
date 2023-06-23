ITEM.name = "Scraps"
ITEM.model = "models/props_junk/cardboard_box003a.mdl"
ITEM.weight = 0.3
ITEM.space = 1;
ITEM.cost = 50
ITEM.description = "Scrapped metal needed for items"
ITEM.category = "Materials"
ITEM.slot = "Back";

ITEM.funcs = {
  use = {
    name = "Do something!",
    Do = function(ITEM, player)
        print('im working!')
        return false;
    end,
    CanDo = function(ITEM, player)
        return true;
    end;
  },
  ban_me = {
    name = "Ban item up!",
    Do = function(ITEM, player)

    end
  }
}
