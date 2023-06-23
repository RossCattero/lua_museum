local PLUGIN = PLUGIN;
local NEXT_WEAPONS_UPDATE = CurTime();

local weaponsinfoss = {}

netstream.Hook("Populate_repair_table", function(tbl, entity)
    if (PLUGIN.repairTable and PLUGIN.repairTable:IsValid()) then
		PLUGIN.repairTable:Close();
    end;

    PLUGIN.repairTable = vgui.Create("STALKER_OpenRepair");
    PLUGIN.repairTable:Populate( tbl, entity )
end)

netstream.Hook("OpenRepairKit", function(id, unique)
    if (PLUGIN.repairTable and PLUGIN.repairTable:IsValid()) then
		PLUGIN.repairTable:Close();
    end;
    local inventory = LocalPlayer():GetCharacter():GetInventory():GetItems();
    if inventory[id] && inventory[id].uniqueID == unique then
        PLUGIN.repairTable = vgui.Create("STALKER_OpenLittleRepair");
        PLUGIN.repairTable:Populate(inventory[id])
    end;
end)

function PLUGIN:OnLoaded()
    for k, v in pairs(ix.item.list) do
        if v.base == 'base_weapons' then
            if v.GearInfo then
                weaponsinfoss[ v.class ] = {
                    Model = v.model, 
                    Bone = v.GearBone or "ValveBiped.Bip01_Spine1", 
                    BoneOffset = v.GearOffset or {Vector(0, 0, 0), Angle(0, 0, 0)} 
                }
            end;
        end;
    end;
end;
 
local function CalcOffset(pos,ang,off)
    return pos + ang:Right() * off.x + ang:Forward() * off.y + ang:Up() * off.z;
end
     
local function clhasweapon(pl,weaponclass)
    for i,v in pairs(pl:GetWeapons()) do
        if string.lower(v:GetClass())==string.lower(weaponclass) then return true end
    end
     
    return false;
end
 
local function clgetweapon(pl,weaponclass)
    for i,v in pairs(pl:GetWeapons()) do
        if string.lower(v:GetClass())==string.lower(weaponclass) then return v end
    end
     
    return nil;
end
 
local function playergettf2class(ply)
    return ply:GetPlayerClass()
end
 
local function IsTf2Class(ply)
   return LocalPlayer().IsHL2 && !LocalPlayer():IsHL2()
end
 
local function GetHolsteredWeaponTable(ply,indx)
    local class=IsTf2Class(ply) and playergettf2class(ply) or nil
    if !class then  return weaponsinfoss[indx]
    else return (weaponsinfoss[indx] && weaponsinfoss[indx][class]) and weaponsinfoss[indx][class] or nil
    end
end
 
local function thinkdamnit()
    for _,pl in pairs(player.GetAll()) do
        if !IsValid(pl) then continue end
         
        if !pl.CL_CS_WEPS then
            pl.CL_CS_WEPS={}
        end
         
        if !pl:Alive() then pl.CL_CS_WEPS={} continue end
         
        if NEXT_WEAPONS_UPDATE<CurTime() then
            pl.CL_CS_WEPS={} 
            NEXT_WEAPONS_UPDATE=CurTime()+5
        end
         
        for i,v in pairs(pl:GetWeapons())do
            if !IsValid(v) then continue; end
             
            if pl.CL_CS_WEPS[v:GetClass()] then continue end
             
            if !pl.CL_CS_WEPS[v:GetClass()] then
                local worldmodel=v.WorldModelOverride or v.WorldModel
                local attachedwmodel=v.AttachedWorldModel;
                 
                if GetHolsteredWeaponTable(pl,v:GetClass()) && GetHolsteredWeaponTable(pl,v:GetClass()).Model then
                    worldmodel=GetHolsteredWeaponTable(pl,v:GetClass()).Model
                end
                if !worldmodel || worldmodel=="" then continue end;
                 
                 
                pl.CL_CS_WEPS[v:GetClass()]=ClientsideModel(worldmodel,RENDERGROUP_OPAQUE)
                pl.CL_CS_WEPS[v:GetClass()]:SetNoDraw(true)
                pl.CL_CS_WEPS[v:GetClass()]:SetSkin(v:GetSkin())
                pl.CL_CS_WEPS[v:GetClass()]:SetColor(v:GetColor())
                 
                if GetHolsteredWeaponTable(pl,v:GetClass()) && GetHolsteredWeaponTable(pl,v:GetClass()).Scale then
                    pl.CL_CS_WEPS[v:GetClass()]:SetModelScale(GetHolsteredWeaponTable(pl,v:GetClass()).Scale);
                end
                 
                if GetHolsteredWeaponTable(pl,v:GetClass()) && GetHolsteredWeaponTable(pl,v:GetClass()).BBP then
                    pl.CL_CS_WEPS[v:GetClass()].BuildBonePositions=GetHolsteredWeaponTable(pl,v:GetClass()).BBP;
                end
                 
                if v.MaterialOverride || v:GetMaterial() then
                    pl.CL_CS_WEPS[v:GetClass()]:SetMaterial(v.MaterialOverride || v:GetMaterial())
                end
                if worldmodel == "models/weapons/w_models/w_shotgun.mdl" then
                    pl.CL_CS_WEPS[v:GetClass()]:SetMaterial("models/weapons/w_shotgun_tf/w_shotgun_tf")
                end
                 
                pl.CL_CS_WEPS[v:GetClass()].WModelAttachment=v.WModelAttachment
                pl.CL_CS_WEPS[v:GetClass()].WorldModelVisible=v.WorldModelVisible
                 
                 
                if attachedwmodel then
                    pl.CL_CS_WEPS[v:GetClass()].AttachedModel=ClientsideModel(attachedwmodel,RENDERGROUP_OPAQUE)
                    pl.CL_CS_WEPS[v:GetClass()].AttachedModel:SetNoDraw(true)
                    pl.CL_CS_WEPS[v:GetClass()].AttachedModel:SetSkin(v:GetSkin())
                    pl.CL_CS_WEPS[v:GetClass()].AttachedModel:SetParent(pl.CL_CS_WEPS[v:GetClass()])
                    pl.CL_CS_WEPS[v:GetClass()].AttachedModel:AddEffects( EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES )
                end
            end
        end
    end
end
 
local function playerdrawdamnit(pl,legs)
    if !IsValid(pl) then return end
    if !pl.CL_CS_WEPS then return end
    for i,v in pairs(pl.CL_CS_WEPS) do
 
             
        if GetHolsteredWeaponTable(pl,i) && (pl:GetActiveWeapon()==NULL || pl:GetActiveWeapon():GetClass()~=i) && clhasweapon(pl,i) then
            if GetHolsteredWeaponTable(pl,i).Priority then
                local priority=GetHolsteredWeaponTable(pl,i).Priority
                local bol=GetHolsteredWeaponTable(pl,priority) && (pl:GetActiveWeapon()==NULL || pl:GetActiveWeapon():GetClass()!=priority) && clhasweapon(pl,priority)
                if bol then continue; end
            end
             
            local oldpl=pl;
            local wep=clgetweapon(oldpl,i)
             
            if legs && IsValid(legs) then
            pl=legs;
            end
             
            if legs && IsValid(legs) && (string.find(string.lower(GetHolsteredWeaponTable(oldpl,i).Bone),"spine") or string.find(string.lower(GetHolsteredWeaponTable(oldpl,i).Bone),"clavi") ) then
            pl=oldpl;
            continue;
            end
             
            local bone=pl:LookupBone(GetHolsteredWeaponTable(oldpl,i).Bone or "")
            if !bone then pl=oldpl;continue; end
 
             
            local matrix = pl:GetBoneMatrix(bone)
            if !matrix then pl=oldpl;continue; end
            local pos = matrix:GetTranslation()
			local ang = matrix:GetAngles()
            local pos=CalcOffset(pos,ang,GetHolsteredWeaponTable(oldpl,i).BoneOffset[1])
            if GetHolsteredWeaponTable(oldpl,i).Skin then v:SetSkin(GetHolsteredWeaponTable(oldpl,i).Skin) end
             
            v:SetRenderOrigin(pos)
             
            ang:RotateAroundAxis(ang:Forward(),GetHolsteredWeaponTable(oldpl,i).BoneOffset[2].p)
            ang:RotateAroundAxis(ang:Up(),GetHolsteredWeaponTable(oldpl,i).BoneOffset[2].y)
            ang:RotateAroundAxis(ang:Right(),GetHolsteredWeaponTable(oldpl,i).BoneOffset[2].r)
             
            v:SetRenderAngles(ang)
            if v.WorldModelVisible==nil || (v.WorldModelVisible!=false) then
                v:DrawModel();
            end
             
            if IsValid(v.AttachedModel) then
                v.AttachedModel:DrawModel();
            end
            if v.WModelAttachment && multimodel then
                multimodel.Draw(v.WModelAttachment, wep, {origin=pos, angles=ang})
                multimodel.DoFrameAdvance(v.WModelAttachment, CurTime(),wep)
            end
             
            if GetHolsteredWeaponTable(oldpl,i).DrawFunction then
                GetHolsteredWeaponTable(oldpl,i).DrawFunction(v,oldpl)
            end
            pl=oldpl;
        end
    end
end
 
local function drawlegsdamnit(legs)
    playerdrawdamnit(LocalPlayer(),legs)
end
 
hook.Add("PostLegsDraw", "HG_DrawOnLegs", drawlegsdamnit)
hook.Add("Think", "HG_Think", thinkdamnit)
hook.Add("PostPlayerDraw", "HG_Draw", playerdrawdamnit)
hook.Remove( "ContextMenuOpen", "TFAContextBlock" ) hook.Remove( "Think", "TFAInspectionMenu" )

netstream.Hook("Frequency", function(oldFrequency)
	Derma_StringRequest("Частота", "Какую частоту вы хотите поставить?", oldFrequency, function(text)
		ix.command.Send("SetFreq", text)
	end)
end)