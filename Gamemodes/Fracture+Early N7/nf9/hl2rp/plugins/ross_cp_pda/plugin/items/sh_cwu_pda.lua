local ITEM = Clockwork.item:New();
ITEM.name = "CWU PDA";
ITEM.model = "models/nirrti/tablet/tablet_sfm.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "cwu_pda";
ITEM.useText = "Открыть";
ITEM.category = "Прочее";

ITEM:AddData("CWU_PDA_INFO", {
    Code = 0,
    Notepad = "",
    BackGroundColor = Color(100, 100, 255)
}, true)

function ITEM:OnUse(player, itemEntity)
    local card = player:HasItemByID("pda_password_edit")

    if card && player:FindItemByID("pda_password_edit") then
        Carding = player:FindItemByID("pda_password_edit"):GetData("PasswordEdited")
    else
        Carding = false;
    end;
    local everyonedata = {}
    for k, v in pairs(cwPlayer.GetAll()) do

    if v:GetFaction() == FACTION_CITIZEN then 
        local citTBL = v:GetCharacterData("CitizenInfo");
        if v:HasItemByID("citizen_civ_card") then
            everyonedata[v:GetName()] = {
                    ["Faction"] = v:GetFaction(),
                    ["CID"] = v:GetCharacterData("CitizenID"),
                    ["Name"] = v:GetName(),
                    ["ol"] = citTBL["ol"],
                    ["on"] = citTBL["on"],
                    ["workplace"] = citTBL["work"],
                    ["liveplace"] = citTBL["liveplace"]
                } 
        elseif !v:HasItemByID("citizen_civ_card") then
            everyonedata[v:GetName()] = {
                ["Faction"] = "Отсутствует карточка!",
                ["CID"] = "Отсутствует карточка!",
                ["Name"] = "Отсутствует карточка!",
                ["ol"] = "Отсутствует карточка!",
                ["on"] = "Отсутствует карточка!",
                ["workplace"] = "Отсутствует карточка!",
                ["liveplace"] = "Отсутствует карточка!"
            }
        end;
    end;
        
        table.sort(everyonedata)
    end;

    cable.send(player, 'OpenPDACWU', everyonedata, self:GetData("CWU_PDA_INFO"), card, Carding);

return false;
end;

function ITEM:OnDrop(player, position) end;

ITEM:Register();