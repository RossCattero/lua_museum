
ITEM.name = "База прицелов";
ITEM.model = "models/props_junk/cardboard_box004a.mdl";
ITEM.weight = 50;
ITEM.category = "Модификации оружия";
ITEM.att_type = '';
ITEM.width = 1
ITEM.height = 1

ITEM.functions.OnUse = {
    name = "Прикрепить",
    OnRun = function(item)
        local wep = item.player:GetActiveWeapon()
        local wepitem = item.player:GetCharacter():GetInventory():HasItem(wep:GetClass())
        if wepitem then
            wepitem:GetData('WepAttachments')[item.att_type] = item.uniqueID
            wep:Attach(item.uniqueID)
        end;
        item.player:GetCharacter():RemoveCarry(item)
        return true;
    end,
    OnCanRun = function(item)
        local player = item.player; local wep = player:GetActiveWeapon()
        local isTFA = IsWeaponTFA(wep);

        return IsValid(wep) && isTFA && !wep:IsAttached(item.uniqueID)
    end
}