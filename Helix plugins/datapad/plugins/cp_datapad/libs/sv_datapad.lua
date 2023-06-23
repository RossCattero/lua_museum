--- Send data to client;
---@param client table (Player)
---@param asAdmin boolean|nil (Receive data as admin)
function ix.datapad.SendData(client, asAdmin)
    local rank = ix.datapad.CanOpen(client, asAdmin);

    if not rank then return false end;
    
    -- Copy data for formatting;
    local data = table.Copy(ix.archive.instances);

    -- Check if player can access CCA data
    local ccaAccess = ix.ranks.Permission(rank.uniqueID, ix.ranks.permissions.cca_access);

    -- Remove all CCA's if data is not allowed for this police member.
    for k, v in pairs(data) do
        if not v.cid and (not ccaAccess or (rank.value < ix.ranks.Get(v:GetRank()).value)) then
            data[k] = nil;
        end;
    end;

    -- Check if player can receive logs;
    local logs = ix.ranks.Permission(rank.uniqueID, ix.ranks.permissions.access_logs);
    if logs then
        logs = util.TableToJSON( ix.archive.logs.Get() )
        logs = util.Compress( logs )
        local len = #logs
        
        net.Start("ix.datapad.logs.send")
            net.WriteUInt( len, 16 )
            net.WriteData( logs, len )
        net.Send(client)
    end;

    data = util.TableToJSON( data )
    data = util.Compress( data )
    local len = #data
    
    net.Start("ix.datapad.data")
        net.WriteUInt( len, 16 )
        net.WriteData( data, len )
    net.Send(client)

    return true;
end;

--- Check if player can open datapad
---@param client table (player)
---@param asAdmin boolean|nil (As admin)
---@return table (rank table)
function ix.datapad.CanOpen(client, asAdmin)
    local character = client:GetCharacter()
    local id = character:GetID()
    local archivedData = ix.archive.Get(id)

    local rank;

    -- Check if player trying to receive data as admin;
    if asAdmin and CAMI.PlayerHasAccess(client, "helix - Open datapad") then
        rank = ix.ranks.Get("dispatcher")
    else
        rank = archivedData.GetRank and ix.ranks.Get(archivedData:GetRank())
    end;

    -- Get player's rank;
    if not rank then
        client:Notify("You don't have permissions to do this!")
        return false;
    end;

    return rank;
end;

--- Open UI for client
---@param client table (target)
---@param asAdmin boolean|nil (Is player opening as admin)
function ix.datapad.Open(client, asAdmin)
    if ix.datapad.SendData(client, asAdmin) then
        timer.Simple(0, function()
            net.Start("ix.datapad.open")
                net.WriteBool(asAdmin)
            net.Send(client)
        end)
    end;
end;