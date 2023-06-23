local PLUGIN = PLUGIN;

_G.cw_ScannerShot = PLUGIN

local SCANNER_PIC_W = 550
local SCANNER_PIC_H = 380

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

function PLUGIN:SendScreenshot()
		local viewEntity = LocalPlayer():GetViewEntity()

		if (!IsValid(viewEntity)) then
			--return
		end

		local light = DynamicLight(0)
		light.Pos = LocalPlayer():GetPos()
		light.r = 255
		light.g = 255
		light.b = 255
		light.Brightness = 4
		light.Size = 2000
		light.Decay = 4000
		light.DieTime = CurTime() + 2
		light.Style = 0

		timer.Simple(FrameTime(), function()
			local scrW, scrH = ScrW(), ScrH()
			local w, h = SCANNER_PIC_W, SCANNER_PIC_H
			local x, y = scrW*0.5 - (w * 0.5), scrH*0.5 - (h * 0.5)
			local data = util.Base64Encode(render.Capture({
				quality = 50,
				x = x,
				y = y,
				w = w,
				h = h,
				format = "jpeg"
			}))

			if (data) then
				Clockwork.datastream:Start("ScannerShot", data)
			end
		end)
end

Clockwork.datastream:Hook("ScannerData", function(data)
	PLUGIN:CreateScannerImage(data)
end)

function PLUGIN:CreateScannerImage(data)
	local function CreateImagePanel(x, y, w, h)
		local parent = vgui.Create("DPanel")
		parent:SetDrawBackground(false)
		parent:SetPos(x, y)
		parent:SetSize(w, h)
		
		
		local panel = parent:Add("DHTML")
		panel:DockMargin(0, 0, 0, 0)
		panel:Dock(FILL)
		panel:SetHTML([[<html style="padding:0px;margin:0px;overflow:hidden;"><img width="100%" height="100%" src="data:image/jpeg;base64,]]..data..[[" alt="" /></html>]])	
		panel.PaintOver = function(panel, w, h)
			surface.SetDrawColor(255, 255, 255, 25)
			surface.DrawTexturedRect(8, 8, w - 16, h)
				
			local flash = math.abs(math.sin(RealTime() * 3) * 150)
			surface.SetDrawColor(40 + flash, 40 + flash, 40 + flash, 255)
			
			for i = 1, 3 do
				surface.DrawOutlinedRect(7 + i, 7 + i, w - 14 - i*2, h - 6 - i*2)
			end
		end
		
		parent.html = panel
		
		return parent
	end

	local width, height = SCANNER_PIC_W, SCANNER_PIC_H
	local panel = CreateImagePanel(128, 16, width, height)
	local w, h = width * 0.75, height * 0.75
	
	panel:SetPos(ScrW() + w + 16, 16)
	panel:SetSize(w, h)
	panel:MoveTo(ScrW() - (w*(IMAGE_ID or 1) + 16), 16, 0.35, 0.1, 0.33)

	IMAGE_ID = (IMAGE_ID or 1) + 1

	timer.Simple(15, function()
		if (IsValid(panel)) then
			panel:MoveTo(ScrW() + (w + 16), 16, 0.4, 0)
			
			timer.Simple(0.5, function()
				IMAGE_ID = math.max(IMAGE_ID - 1, 0)
				panel:Remove()
			end)
		end
	end)
end