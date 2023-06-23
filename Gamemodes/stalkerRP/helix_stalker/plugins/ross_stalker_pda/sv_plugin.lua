local PLUGIN = PLUGIN;
Schema.globalMessages = {};

local ply = FindMetaTable("Player")

function ply:HasHisOwnPDA(password, id)
    local character = self:GetCharacter()
    local FindPDAs = character:GetInventory():GetItemsByUniqueID('ross_stalker_pda')
        for k, v in pairs(FindPDAs) do
            if v && v:GetData('messageID') == id then
                if password then
                    if v:GetData('password') == password then
                        return v;
                    else
                        return false;
                    end;
                elseif !password then
                    return v;
                end;
            end;
        end;
    return false;
end;
function ply:IsLookingOnPDA(password, id)
    local trace = self:GetEyeTraceNoCursor()
    if !trace or self:GetPos():Distance(trace.HitPos) > 128 then return false end;
    local entity = trace.Entity
    local class = entity:GetClass();
    local item = entity:GetItemTable() or {};
    local data = entity:GetNetVar("data") or {};
    if class == "ix_item" && item.uniqueID == 'ross_stalker_pda' && data.messageID == id && self:GetPos():Distance(trace.HitPos) < 128 then
        if password then
            if data.password == password then
                return entity
            else
                return false;
            end;
        elseif !password then
            return entity
        end;
    end;
    return false;
end;
function ply:AddReputation(number)
    local char = self:GetCharacter();

    self:SetLocalVar('reputation', number);
    char:SetData('reputation', number);
end;
function ply:AddRank(number)
    local char = self:GetCharacter();

    self:SetLocalVar('rank', number);
    char:SetData('rank', number);
end;
netstream.Hook("PDACheck_password_step", function(player, password, ID)
    if player:HasHisOwnPDA(password, ID) then
        netstream.Start(player, "STALKER_PDA_OPENINFO", player:HasHisOwnPDA(password, ID).data, ix.data.Get("GlobalPDAWEB"), ix.data.Get("GlobalNotifications"))
        return;
    end;
    if player:IsLookingOnPDA(password, ID) then
        netstream.Start(player, "STALKER_PDA_OPENINFO", player:IsLookingOnPDA(password, ID):GetNetVar('data'), ix.data.Get("GlobalPDAWEB"), ix.data.Get("GlobalNotifications"))
        return;
    end;
end)

netstream.Hook("PDA_sendmessage", function(player, ti, wh, msg, ID)
    if !player:HasHisOwnPDA(false, ID) && !player:IsLookingOnPDA(false, ID) then
        return;
    end;

    for k, v in pairs(ix.item.instances) do
        if v:GetData('messageID') && tostring(v:GetData('messageID')) == tostring(wh) then
            table.insert(v:GetData('allmessages'), {
                title = ti,
                who = wh,
                text = msg
            })
        end;
    end;
end)

netstream.Hook("PDA_AddPin", function(player, pintxt, id)
    if player:HasHisOwnPDA(false, id) then
        if #player:HasHisOwnPDA(false, id):GetData('notes') > 15 then return end;
        table.insert(player:HasHisOwnPDA(false, id):GetData('notes'), pintxt);
        return;
    end;
    if player:IsLookingOnPDA(false, id) then
        if #player:IsLookingOnPDA(false, id):GetNetVar('data').notes > 15 then return end;
        table.insert(player:IsLookingOnPDA(false, id):GetNetVar('data').notes, pintxt);
    end;
end)
netstream.Hook("PDA_EditPin", function(player, txt, tblid, id)
    if player:HasHisOwnPDA(false, id) then
        if #player:HasHisOwnPDA(false, id):GetData('notes') > 15 then return end;
        player:HasHisOwnPDA(false, id):GetData('notes')[tblid] = txt;
        return;
    end;
    if player:IsLookingOnPDA(false, id) then
        if #player:IsLookingOnPDA(false, id):GetNetVar('data').notes > 15 then return end;
        player:IsLookingOnPDA(false, id):GetNetVar('data').notes[tblid] = txt;
    end;
end)

netstream.Hook("PDA_message", function(client, msg, who, fac, id)

    if !client.PDAmessageCool or CurTime() >= client.PDAmessageCool then
        client.PDAmessageCool = CurTime() + 5;
        if client:HasHisOwnPDA(false, id) or client:IsLookingOnPDA(false, id) then
            table.insert(ix.data.Get("GlobalPDAWEB"), {message = msg, whois = who, faction = fac})
            ix.data.Set("GlobalPDAWEB", ix.data.Get("GlobalPDAWEB"))

            for k, v in pairs(player.GetAll()) do
                netstream.Start(v, "PDA_message_undercontrol", msg, who, fac)
            end;
            return;
        end;
    end;
end)

netstream.Hook("PDA_changepassword", function(client, pass, id)
    if player:HasHisOwnPDA(false, id) then
        player:HasHisOwnPDA(false, id):SetData('password', pass)
        return;
    end;
    if player:IsLookingOnPDA(false, id) then
        player:IsLookingOnPDA(false, id):GetNetVar('data').password = pass
    end;
end);
function PLUGIN:OnCharacterCreated(client, character)
    character:SetData("reputation", 0)
    character:SetData("rank", 0)
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        client:SetLocalVar("reputation", character:GetData("reputation", 0))
        client:SetLocalVar("rank", character:GetData("rank", 0))
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("reputation", client:GetLocalVar("reputation", 0))
        character:SetData("rank", client:GetLocalVar("rank", 0))
    end
end
 
function PLUGIN:InitializedPlugins()
    if !ix.data.Get("GlobalPDAWEB") then
        ix.data.Set("GlobalPDAWEB", {})
    end;
    if !ix.data.Get("GlobalNotifications") then
        ix.data.Set("GlobalNotifications", {})
    end;
end;