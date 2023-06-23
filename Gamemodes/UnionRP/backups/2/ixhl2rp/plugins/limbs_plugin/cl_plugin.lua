local PLUGIN = PLUGIN;

-- function PLUGIN:CreateCharacterInfo( panel )
-- 	local limbs = LocalPlayer():GetLocalVar('limbs')

-- 	for k, v in pairs(limbs) do

-- 		local protBar = panel:Add("Panel")
-- 		protBar:Dock(TOP)
-- 		protBar:DockMargin(0, 0, 0, 8)
-- 		protBar.Paint = function(_, w, h) 
-- 			surface.SetDrawColor(0, 0, 0, 150)
-- 			surface.DrawRect(0, 0, w, h)
-- 		end
-- 		local barAmount = protBar:Add("Panel")
-- 		barAmount:SetTall(22)
-- 		barAmount:Dock(FILL)
-- 		barAmount.Paint = function(s, w, h)
-- 			local value = math.Clamp(v['health'] / 100, 0, 1)
-- 			surface.SetDrawColor(100, 100, 255, 230)
-- 			surface.DrawRect(2, 2, (w - 4) * value, h - 4)		
-- 		end;
-- 		local barName = protBar:Add("DLabel")
-- 		barName:Dock(FILL)
-- 		barName:SetText(v['name'])
-- 		barName:SetFont("ixMenuButtonFontSmall")
-- 		barName:SetContentAlignment( 5 )
-- 	end;
-- end;