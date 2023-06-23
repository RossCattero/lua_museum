local PLUGIN = PLUGIN;

local ScreenshotRequested = false
function RequestAScreenshot()
	ScreenshotRequested = true
end

_G.cw_ScannerShot = PLUGIN

local SCANNER_PIC_W = 550
local SCANNER_PIC_H = 380
local PICTURE_WIDTH, PICTURE_HEIGHT = 580, 420
local PICTURE_WIDTH2, PICTURE_HEIGHT2 = PICTURE_WIDTH * 0.5, PICTURE_HEIGHT * 0.5

surface.CreateFont("ScannerText", {
	font = "Arial",
	weight = 800,
	size = 26,
	antialias = false,
	outline = true
})

function PLUGIN:CalcView(client, origin, angles, fov)
	local viewEntity = LocalPlayer():GetViewEntity()

	if (IsValid(viewEntity) and Schema:IsPlayerCombineRank(Clockwork.Client, "SCN")) then
		local view = {}
			view.angles = client:GetAimVector():Angle()
		return view
	end
end


function PLUGIN:HUDPaint()
	viewEntity = LocalPlayer():GetViewEntity()
	
	if Clockwork.Client:GetFaction() == FACTION_SCANNER and !LocalPlayer():GetNetworkedVar("CamMode", true) then
	local scrW, scrH = ScrW(), ScrH()
	local w, h = SCANNER_PIC_W, SCANNER_PIC_H
	local x, y = scrW*0.5 - (w * 0.5), scrH*0.5 - (h * 0.5)
	local x2, y2 = x + w*0.5, y + h*0.5

	surface.SetDrawColor(255, 255, 255, 10 + math.random(0, 1))
	surface.DrawRect(x, y, w, h)

	surface.SetDrawColor(255, 255, 255, 150 + math.random(-50, 50))
	surface.DrawOutlinedRect(x, y, w, h)

	surface.DrawLine(x2, 0, x2, y)
	surface.DrawLine(x2, y + h, x2, ScrH())
	surface.DrawLine(0, y2, x, y2)
	surface.DrawLine(x + w, y2, ScrW(), y2)

	x = x + 8
	y = y + 8

	local position = LocalPlayer():GetPos()

	draw.SimpleText("POS: ("..math.floor(position.x)..","..math.floor(position.y)..","..math.floor(position.z)..")", "ScannerText", x, y, color_white, 0, 0)
	local c = true
	local digits = ""
	for i=1, #LocalPlayer():GetName() do
		local n = LocalPlayer():GetName()
		if !string.find(string.sub(n, #n-i, #n-i), "[.-]") and c then
			digits = string.sub(n, #n-1, #n-1) .. digits
		else
			c = false
		end
	end
	draw.SimpleText("UNIT: ("..digits..")", "ScannerText", x + w - surface.GetTextSize("UNIT: ("..digits..")"), y, color_white, 0, 0)
	local p = math.floor(-LocalPlayer():GetAimVector():Angle().p+360)
	if p > 180 then
		p = p - 360
	end
	
	draw.SimpleText("YAW: "..math.floor(LocalPlayer():GetAimVector():Angle().y).."; PITCH: "..p, "ScannerText", x, y + 24, color_white, 0, 0)
	draw.SimpleText("HULL: "..math.floor(LocalPlayer():Health()).."%", "ScannerText", x, y + 48, Color(math.Clamp(100-(LocalPlayer():Health()*2)+100, 0, 100)*2.55, math.Clamp(LocalPlayer():Health(), 0, 100)*2.55, 0), 0, 0)

	local r, g, b = 185, 185, 185
	local length = 64
	local trace = util.QuickTrace(viewEntity:GetPos(), LocalPlayer():GetAimVector()*3600, viewEntity)
	local entity = trace.Entity

	if (IsValid(entity) and entity:IsPlayer()) then
		self.target = entity
		draw.SimpleText("TARGET: "..string.upper(entity:GetName()).."; VITALS: "..entity:Health().."%", "ScannerText", x, y + 48 + 24, color_white, 0, 0)
		r = 255
		g = 255
		b = 255
	else
		draw.SimpleText("TARGET: NONE", "ScannerText", x, y + 48 + 24, color_white, 0, 0)
	end
	
	local ScannerCooldown = LocalPlayer():GetNetworkedVar("ScannerCooldown", 0)
	if (ScannerCooldown>CurTime()) then
		draw.SimpleText("RECHARGING: "..string.sub(tostring(CurTime()-ScannerCooldown), 1, 5), "ScannerText", x, y + h - 48, Color(255, 0, 0), 0, 0)
	end
	end
end

Clockwork.datastream:Hook("FadeOut", function(data)
		local color = data[2] or Color(255, 255, 255)

		if (color) then
			local r, g, b, a = color.r, color.g, color.b, color.a or 255
			local time = data[1]
			local start = CurTime()
			local finish = start + time

			hook.Add("HUDPaint", "FadeIn", function()
				local fraction = 1 - math.TimeFraction(start, finish, CurTime())

				if (fraction < 0) then
					return hook.Remove("HUDPaint", "nut_FadeIn")
				end

				surface.SetDrawColor(r, g, b, fraction * a)
				surface.DrawRect(0, 0, ScrW(), ScrH())		
			end)
		end
	end)


--[[

FIX THIS SHIT

]]--
function PLUGIN:PostRender()
	if ( !ScreenshotRequested ) then return end
	ScreenshotRequested = false
	local data = util.Base64Encode(render.Capture({
		format = "jpeg",
		h = PICTURE_HEIGHT,
		w = PICTURE_WIDTH,
		quality = 35,
		x = ScrW() * 0.5 - PICTURE_WIDTH2,
		y = ScrH() * 0.5 - PICTURE_HEIGHT2
	}))
	net.Start("FIXScannerData")
		net.WriteUInt(#data, 16)
		net.WriteData(data, #data)
	net.SendToServer()
end

local CURRENT_PHOTO = nil
local TEMPLATE = [[
	<html>
		<body style="background: black; overflow: hidden; margin: 0; padding: 0;">
			<img src="data:image/jpeg;base64,%s" width="%s" height="%s" />
		</body>
	</html>
]]

net.Receive("FIXScannerData", function()
	local data = net.ReadData(net.ReadUInt(16))

	if (data) then
		LocalPlayer():EmitSound("npc/overwatch/radiovoice/preparevisualdownload.wav")

		if (IsValid(CURRENT_PHOTO)) then
			local panel = CURRENT_PHOTO

			CURRENT_PHOTO:AlphaTo(0, 0.25, 0, function()
				if (IsValid(panel)) then
					panel:Remove()
				end
			end)
		end

		local html = string.format(TEMPLATE, data, PICTURE_WIDTH, PICTURE_HEIGHT)
		local panel = vgui.Create("DPanel")
		panel:SetSize(PICTURE_WIDTH + 8, PICTURE_HEIGHT + 8)
		panel:SetPos(ScrW(), 8)
		panel:SetPaintBackground(true)
		panel:SetAlpha(150)

		panel.body = panel:Add("DHTML")
		panel.body:Dock(FILL)
		panel.body:DockMargin(4, 4, 4, 4)
		panel.body:SetHTML(html)

		panel:MoveTo(ScrW() - (panel:GetWide() + 8), 8, 0.5)

		timer.Simple(15, function()
			if (IsValid(panel)) then
				panel:MoveTo(ScrW(), 8, 0.5, 0, -1, function()
					panel:Remove()
				end)
			end
		end)

		CURRENT_PHOTO = panel
	end
end)