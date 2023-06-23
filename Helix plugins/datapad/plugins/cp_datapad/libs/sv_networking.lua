util.AddNetworkString("ix.datapad.open")
util.AddNetworkString("ix.datapad.data")
util.AddNetworkString("ix.datapad.send")
util.AddNetworkString("ix.datapad.logs.send")

net.Receive("ix.datapad.send", function(len, client)
    local data = net.ReadString()
    data = util.JSONToTable(data)

    local character = client:GetCharacter()
    local id = character:GetID()
    
    -- just in case;
    if data.id == id then
        return;
    end;

    local archivedData = ix.archive.Get(id)
    local rank;

    -- Check if player acessing data as admin via /admin_datapad
    if data.asAdmin and CAMI.PlayerHasAccess(client, "helix - Open datapad") then
        -- Players can't reach here if even they're send 'asAdmin' from clientside script
        -- Because of CAMI.
        rank = ix.ranks.Get("dispatcher")
    elseif data.asAdmin and not CAMI.PlayerHasAccess(client, "helix - Open datapad") then
        -- Alarm admins in logs somebody tried to hack here;
        ix.log.Add(client, "ix.datapad.alert", client:SteamID())
    else
        rank = archivedData.GetRank and ix.ranks.Get(archivedData:GetRank())
    end;

    -- If player is not having rank - don't allow to go forward;
    if not rank then
        return;
    end;
    
    -- Check if player can access datapad
    local datapad = ix.ranks.Permission(rank.uniqueID, ix.ranks.permissions.open_datapad)
    if not datapad then
        return;
    end;

    -- Check if player can access change citizen data
    local citizen = ix.ranks.Permission(rank.uniqueID, ix.ranks.permissions.edit_citizens)

    if citizen and data.cid then
        citizen = ix.archive.Get(data.id);
        if citizen:GetApartment() ~= data.apartment then
            ix.log.Add(client, "ix.archive.civilian.apartment", data.id, data.apartment)
            citizen:SetApartment(data.apartment)
        end;
        if citizen:GetLoyality() ~= data.loyality then
            ix.log.Add(client, "ix.archive.civilian.loyality", data.id, data.loyality)
            citizen:SetLoyality(data.loyality)
        end;
        if citizen:GetCriminal() ~= data.criminal then
            ix.log.Add(client, "ix.archive.civilian.criminal", data.id, data.criminal)
            citizen:SetCriminal(data.criminal)
        end;
        if citizen:GetNotes() ~= data.notes then
            ix.log.Add(client, "ix.archive.civilian.notes", data.id)
            citizen:SetNotes(data.notes)
        end;
        if citizen:GetBOL() ~= data.bol then
            ix.log.Add(client, "ix.archive.civilian.bol", data.id)
            citizen:SetBOL(data.bol)
        end;

        client:Notify(Format("You successfully changed data for civilian #%s", data.cid))
        return;
    end;

    -- Check if player can access CCA data
    local cca = ix.ranks.Permission(rank.uniqueID, ix.ranks.permissions.cca_access)
    if cca and data.rank and not data.cid then
        local setSterelized = ix.ranks.Permission(rank.uniqueID, ix.ranks.permissions.set_sterilized)
        local setRanks = ix.ranks.Permission(rank.uniqueID, ix.ranks.permissions.set_ranks)
        local setCertifications = ix.ranks.Permission(rank.uniqueID, ix.ranks.permissions.set_certifications)
        local changed = false;

        cca = ix.archive.Get(data.id)

        if setSterelized and data.sterilization ~= cca:GetSterelize() then
            ix.log.Add(client, "ix.archive.police.sterilization", data.id, data.sterilization)

            cca:SetSterelize(data.sterilization)
            changed = true
        end;
        if setRanks 
        and rank.value > ix.ranks.Get(cca:GetRank()).value 
        and rank.value > ix.ranks.Get(data.rank).value
        and data.rank ~= cca:GetRank() then
            ix.log.Add(client, "ix.archive.police.rank", data.id, data.rank)

            cca:SetRank(data.rank)
            changed = true
        end;
        if setCertifications then
            for name, boolean in pairs(data.certifications) do
                if boolean then
                    ix.log.Add(client, "ix.archive.police.add.certification", data.id, name)
                    cca:AddCertification( name:lower() )
                else
                    ix.log.Add(client, "ix.archive.police.remove.certification", data.id, name)
                    cca:RemoveCertification(name)
                end;
            end;
            changed = true;
        end;

        if changed then
            client:Notify(Format("You successfully changed %s data", cca:GetName()))
        else
            client:Notify("You don't have permissions to change data for this character.")
        end;
    end;
end)