local ITEM = Clockwork.item:New();
ITEM.name = "CP PDA";
ITEM.model = "models/nirrti/tablet/tablet_sfm.mdl";
ITEM.skin = 6;
ITEM.weight = 0.1;
ITEM.uniqueID = "cp_pda";
ITEM.useText = "Открыть";
ITEM.category = "Прочее";

ITEM:AddData("SettingsData", {
    styleSettings = {},
	password = "",
    blocked = false,
    chatBlocked = false
}, true)

function ITEM:OnUse(player, itemEntity)
    if (IsValid(itemEntity)) then return false; end;
    local pass = self:GetData("SettingsData")["password"];
    local isblocked = self:GetData("SettingsData")["blocked"];

    if !Schema.avaiblePDAs[self.itemID] then
        Schema.avaiblePDAs[self.itemID] = {
            false, 
            "none", 
            self:GetData("SettingsData")["password"], 
            false
        }
    end;

    if self:GetData("SettingsData")["password"] != Schema.avaiblePDAs[tonumber(self.itemID)][3] then
        self:GetData("SettingsData")["password"] = Schema.avaiblePDAs[tonumber(self.itemID)][3]
    end;
    self:GetData("SettingsData")["blocked"] = Schema.avaiblePDAs[tonumber(self.itemID)][1];
    self:GetData("SettingsData")["chatBlocked"] = Schema.avaiblePDAs[tonumber(self.itemID)][4];
    
    local everyonedata = {}
    for k, v in pairs(cwPlayer.GetAll()) do

        if v:GetFaction() != FACTION_REBELS && v:GetFaction() != FACTION_REFUGEES then 
            local citTBL = v:GetCharacterData("CitizenInfo");
            everyonedata[v:GetName()] = {
                ["CID"] = v:GetCharacterData("CitizenID"),
                ["Name"] = v:GetName(),
                ["ol"] = citTBL["ol"],
                ["on"] = citTBL["on"],
                ["workplace"] = citTBL["work"],
                ["liveplace"] = citTBL["liveplace"],
                ["information"] = citTBL["information"]
            } 
        end;
        if v:GetFaction() == FACTION_MPF && !string.find(v:GetName(), ":ALPHA") then
            local combineTbl = v:GetCharacterData("CombinedInfo");
            local a, b, c = string.find(v:GetName(), ".+(%d%d%d)");
            
            everyonedata[c] = {
                ["Name"] = v:GetName(),
                ["Squad"] = combineTbl["Squad"],
                ["Status"] = combineTbl["Status"],
                ["Info"] = combineTbl["Info"],
                ["Rank"] = combineTbl["CombineRank"]
            }
        end;
        table.sort(everyonedata)
    end;

    cable.send(player, 'OpenCivilProtectionPDA', everyonedata, self:GetData("SettingsData"), self.itemID, Schema.PDAlogs, CP_PDA.CivilProtectionChat);
    
return false;
end;

function ITEM:OnDrop(player, position) end;

if CLIENT then
    function ITEM:OnHUDPaintTargetID(entity, x, y, alpha)

        y = Clockwork.kernel:DrawInfo("ID: "..self.itemID, x, y, Color(70, 180, 80), alpha);

		return y;
    end;
    function ITEM:GetClientSideInfo()
        if (!self:IsInstance()) then return; end;
        local clientSideInfo = "";

        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "ID: "..self.itemID, Color(70, 180, 80));

        return (clientSideInfo != "" and clientSideInfo);
	end;
end;

ITEM:Register();