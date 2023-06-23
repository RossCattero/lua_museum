local PLUGIN = PLUGIN
local SCHEMA = Schema

util.AddNetworkString("FIXScannerData")

function PLUGIN:KeyPress(ply, char)
	if SCHEMA:IsPlayerCombineRank(ply, "SCN") then
	if char==IN_RELOAD then
		local ScannerCooldown = ply:GetNetworkedVar("ScannerCooldown", 0)
		if ScannerCooldown<=CurTime() then
			ply:SendLua([=[RequestAScreenshot()]=])
		end
	end
	if char==IN_USE then
		ply.CamMode = (!ply.CamMode or false)
		ply:SetNetworkedVar("CamMode", ply.CamMode)
		if ply.CamMode then
			local Dicks = ply
			ply:SetViewEntity(Dicks)
			ply:Spectate(OBS_MODE_CHASE)
		else
			ply:SetViewEntity(SCHEMA.scanners[ply][1])
			ply:Spectate(OBS_MODE_NONE)
		end
	end
	end
end

function PLUGIN:PlayerCharacterLoaded(ply)
	ply.CamMode = true
	ply:SetViewEntity(ply)
end
function PLUGIN:FullTo180(Ang)
	local p = Ang.p
	local y = Ang.y
	local r = Ang.r
	if (p>180) then
		p = p - 360
	end
	if (y>180) then
		y = y - 360
	end
	if (r>180) then
		r = r - 360
	end
	return Angle(p, y, r)
end

function PLUGIN:ClampAng(angle, min, max)
	return Angle(math.Clamp(angle.p, min, max), math.Clamp(angle.y, min, max), math.Clamp(angle.r, min, max))
end
function PLUGIN:Think()
	for k, v in pairs(player.GetAll()) do
		if SCHEMA:IsPlayerCombineRank(v, "SCN") and !v.CamMode then
			v:SetPos(SCHEMA.scanners[v][1]:GetPos()-Vector(0, 0, 75))
		end
		if (!v:GetViewEntity() or !v:GetViewEntity():IsValid()) then
			v:SetViewEntity(v)
		end
	end
end


--[[

FIX THIS SHIT

]]--

net.Receive("FIXScannerData", function(_, client)
	local length = net.ReadUInt(16)
	local data = net.ReadData(length)
	if client:GetNetworkedVar("ScannerCooldown", 0)<CurTime() then
		client:SetNetworkedVar("ScannerCooldown", CurTime()+12)
		if SCHEMA:IsPlayerCombineRank(client, "SCN") and !client.CamMode then
			Clockwork.datastream:Start(client, "FadeOut", {1, Color(255, 255, 255)})
			client:EmitSound("npc/scanner/scanner_photo1.wav")

			timer.Simple(0.25, function()
				client:EmitSound("npc/scanner/combat_scan"..math.random(1, 5)..".wav")
				local digits = ""
				local c = true
			end)

			timer.Simple(0.1, function()
				if (!IsValid(client)) then
					return
				end

				local receivers = {}

				for k, v in pairs(player.GetAll()) do
					if (SCHEMA:PlayerIsCombine(v)) then
						receivers[#receivers + 1] = v
					end
				end

				if (#receivers > 0) then
					net.Start("FIXScannerData")
						net.WriteUInt(#data, 16)
						net.WriteData(data, #data)
					net.Send(receivers)
				end
			end)
		end
	end
end)