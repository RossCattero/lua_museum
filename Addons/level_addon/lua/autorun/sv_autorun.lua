
AddCSLuaFile('cl_autorun.lua')
AddCSLuaFile('sv_meta.lua')


if SERVER then
    hook.Add( "PlayerSpawn", "[ROSS]..PlayerSpawn", function(ply)
        local steamID = ply:SteamID()
        sql.Query("INSERT INTO exp(steamID, exp) SELECT "..steamID..", 0 WHERE NOT EXISTS(SELECT 1 FROM exp WHERE steamID = "..steamID.." AND exp = 0);")
    end)

    hook.Add( "OnGamemodeLoaded", "[ROSS]..GamemodeLoaded", function()
        if !sql.Query("SELECT sql FROM sqlite_master WHERE tbl_name = 'exp' AND type = 'table';") then
            sql.Query("CREATE TABLE exp(steamID TEXT, exp FLOAT)")
        end;
    end)
end;