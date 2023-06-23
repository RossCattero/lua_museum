ix.archive.logs.dir = "helix/datapad"
ix.archive.logs.file = Format("%s/%s.txt", ix.archive.logs.dir, os.date("%x"):gsub("/", "-"))
ix.archive.logs.list = ix.archive.logs.list or {}

function ix.archive.logs.Load()
    file.CreateDir(ix.archive.logs.dir)

    ix.archive.logs.Add("Logs initialize.")
end;

function ix.archive.logs.Add(message)
    file.Append(
        ix.archive.logs.file,
        Format("[%s] %s \r\n", os.date("%X"), message)
    )
end;

function ix.archive.logs.Get()
    -- Open data file;
    local logFile = file.Open( ix.archive.logs.file, "r", "DATA" );

    -- Explode all log strings into table;
    local logs = string.Explode( "\n", logFile:Read() )

    -- Remove the last \n;
    logs[#logs] = nil;

    -- Close the file;
    logFile:Close()

    return logs;
end;

local L = Format

ix.log.AddType("ix.archive.civilian.apartment", function(client, ...)
    local arg = {...}
    local str = L("%s changed the archive character %s apartment to %s.", client:SteamName(), arg[1], arg[2])
    ix.archive.logs.Add(str)

    return str
end, FLAG_NORMAL)

ix.log.AddType("ix.archive.civilian.loyality", function(client, ...)
    local arg = {...}
    local str = L("%s changed the archive character %s loyality to %s.", client:SteamName(), arg[1], arg[2])
    ix.archive.logs.Add(str)

    return str
end, FLAG_NORMAL)

ix.log.AddType("ix.archive.civilian.criminal", function(client, ...)
    local arg = {...}
    local str = L("%s changed the archive character %s criminal points to %s.", client:SteamName(), arg[1], arg[2]);
    ix.archive.logs.Add(str)

    return str
end, FLAG_NORMAL)

ix.log.AddType("ix.archive.civilian.notes", function(client, ...)
    local arg = {...}
    local str = L("%s changed the archive character %s notes.", client:SteamName(), arg[1])
    ix.archive.logs.Add(str)

    return str
end, FLAG_NORMAL)

ix.log.AddType("ix.archive.civilian.bol", function(client, ...)
    local arg = {...}
    local str = L("%s changed the archive character %s BOL", client:SteamName(), arg[1]);
    ix.archive.logs.Add(str)

    return str
end, FLAG_NORMAL)

ix.log.AddType("ix.archive.police.sterilization", function(client, ...)
    local arg = {...}
    local str = L("%s changed the archive character %s sterilization points to %s.", client:SteamName(), arg[1], arg[2])
    ix.archive.logs.Add(str)

    return str
end, FLAG_NORMAL)

ix.log.AddType("ix.archive.police.rank", function(client, ...)
    local arg = {...}
    local str = L("%s changed the archive character %s rank to %s.", client:SteamName(), arg[1], arg[2]);
    ix.archive.logs.Add(str)

    return str
end, FLAG_NORMAL)

ix.log.AddType("ix.archive.police.add.certification", function(client, ...)
    local arg = {...}
    local str = L("%s added to the archive character %s certificate %s.", client:SteamName(), arg[1], arg[2])
    ix.archive.logs.Add(str)

    return str
end, FLAG_NORMAL)

ix.log.AddType("ix.archive.police.remove.certification", function(client, ...)
    local arg = {...}
    local str = L("%s removed from the archive character %s certificate %s.", client:SteamName(), arg[1], arg[2])
    ix.archive.logs.Add(str)

    return str
end, FLAG_NORMAL)

ix.log.AddType("ix.datapad.alert", function(client, ...)
    local arg = {...}
    local str = L("Player '%s', with steamID: %s sent adminAccess without permission, suspicious.", client:SteamName(), arg[1]);
    ix.archive.logs.Add(str)

    return str
end, FLAG_DANGER)