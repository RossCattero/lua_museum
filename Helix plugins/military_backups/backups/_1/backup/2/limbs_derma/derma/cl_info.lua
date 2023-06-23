local sw, sh = ScrW(), ScrH()

function draw.BloodDrop(x, y, w, h, alpha)
	surface.SetMaterial( LIMBS.bloodDrop )
	surface.SetDrawColor(Color(150, 50, 50, alpha))
	surface.DrawTexturedRect( x, y, w, h )
end;

function draw.DrawBloodInfo(text, alpha)
	draw.SimpleText(text, "LIMB_TEXT", sw * 0.072, sh * 0.057, Color(200, 50, 50, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end;

function draw.PainInfo(text, alpha)
	draw.SimpleText(text, "LIMB_TEXT", sw * 0.072, sh * 0.08, Color(200, 50, 50, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end;

function draw.BodyLimb(x, y, w, h, alpha)
	local body = LIMBS.images["body"]

	surface.SetMaterial( body )
	surface.SetDrawColor( Color(255, 255, 255, alpha) )
	surface.DrawTexturedRect( x, y, w || body:Width(), h || body:Height() )	
end;

function draw.BodyData( x, y, w, h )
	local limbs = LocalPlayer():GetLimbs()

	for name, material in pairs( LIMBS.images ) do
		if limbs[name] then
			surface.SetMaterial( material )
			surface.SetDrawColor(Color(255, 0, 0, math.min(#limbs[name] * 35, 150) ))
			surface.DrawTexturedRect( x, y, w || material:Width(), h || material:Height() )
		end
	end
end;

local PANEL = {}

function PANEL:Init()
    local ConVas, ScrollBar = self:GetCanvas(), self:GetVBar()
    ScrollBar:SetWidth(1)
	ScrollBar:SetHideButtons( true )
	function ScrollBar.btnGrip:Paint(w, h) 
		draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 255)) 
	end
end
vgui.Register( "LScroll", PANEL, "DScrollPanel" )