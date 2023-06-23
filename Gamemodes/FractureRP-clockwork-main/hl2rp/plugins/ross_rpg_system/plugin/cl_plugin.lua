
local PLUGIN = PLUGIN;

PLUGIN.AllSkillsTable = {
    ["Выносливость"] = {
		isdefault = true,
        neededskills = {}, -- Какие навыки нужны для открытия.
        infliction = {}, -- Влияние.
        opens = {"Жизнедеятельность", "Сопротивление токсинам"}, -- Что открывает.
        tier = 0, -- Уровень.
		tiermax = 0, -- Максимальный уровень.
		descriptionClient = "Этот талант даст вам возможность открыть древо прокачки выносливости."
    },
    ["Жизнедеятельность"] = {
		isdefault = false,
        neededskills = {"Выносливость"}, -- Какие навыки нужны для открытия.
        infliction = {health = 1}, -- Влияние.
        opens = {}, -- Что открывает.
        tier = 0, -- Уровень.
		tiermax = 3, -- Максимальный уровень.
		descriptionClient = "Этот талант улучшит ваше здоровье."
	},
	["Сопротивление токсинам"] = {
		isdefault = false,
        neededskills = {"Выносливость"}, -- Какие навыки нужны для открытия.
        infliction = {toxins = 2}, -- Влияние.
        opens = {}, -- Что открывает.
        tier = 0, -- Уровень.
		tiermax = 3, -- Максимальный уровень.
		descriptionClient = "Этот талант улучшит ваше сопротивление к токсинам."
	}
};

Clockwork.quickmenu:AddCallback("Навыки", nil, function()
	return {
		Callback = function(option)
			cable.send('SendToServerSKILLS')
		end
	};
end);

function CreateTipPanel(frame, buttonID, NotificationText)

	local PosXBT, PosYBY = buttonID:GetPos()
	local RandomizedIDForTable = math.random(000000, 999999)
		
	if !buttonID.pressedUP then
			buttonID.pressedUP = true;
			local TipPanel = vgui.Create( "DPanel", frame )
			TipPanel:SetPos( PosXBT+110, PosYBY )
			TipPanel:SetSize( 200, 150 )

			local DLabel = vgui.Create( "DLabel", TipPanel )
			DLabel:SetPos( 10, 10 )
			DLabel:Dock(FILL)
			DLabel:SetText( NotificationText )
			DLabel:SetWrap(true)
			DLabel:SetAutoStretchVertical(true)

			timer.Create("TipPanelTimer"..RandomizedIDForTable, 10, 1, function() end)
				TipPanel:AlphaTo( 0, 1, 9, function()
					TipPanel:Remove()
					buttonID.pressedUP = false
				end)
		TipPanel.Paint = function(self, x, y)
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));	
			
			if timer.Exists("TipPanelTimer"..RandomizedIDForTable) then
				draw.RoundedBox(2, 0, 145, 2 * timer.TimeLeft("TipPanelTimer"..RandomizedIDForTable) * timer.TimeLeft("TipPanelTimer"..RandomizedIDForTable), 5, Color(255, 0, 0, 150));
			end;
		end;

	end;

end;

function SkillsShow(st, tierPoints)
    local scrW = surface.ScreenWidth();
    local scrH = surface.ScreenHeight();
    local sW = (scrW/2) - 250;
	local sH = (scrH/2) - 350;
	local AllSkills = PLUGIN.AllSkillsTable
	local sts = st["skills"]
	local canOpen = st["CanOpen"]

	local frame = vgui.Create("DFrame");
	frame:SetPos(sW, sH)
	frame:SetSize(660, 610)
    frame:SetTitle("")
	frame:SetBackgroundBlur( true )
	frame:SetDraggable( false )
	frame:ShowCloseButton( false )
	frame:MakePopup()
	frame.lblTitle:SetContentAlignment(8)
	frame.lblTitle.UpdateColours = function( label, skin )
		label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
	end;
	frame.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;
	
	local inventoryPanel = vgui.Create( "DPanel" )
	inventoryPanel:SetPos(sW - 210, sH)
	inventoryPanel:SetSize(200, 610)
	inventoryPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;

	local AttributesScrollPanel = vgui.Create( "DScrollPanel", inventoryPanel )
	AttributesScrollPanel:Dock( FILL )
	
	for k, v in pairs(Clockwork.attribute:GetAll()) do
			local attribute = AttributesScrollPanel:Add( "DPanel" )
			attribute:SetText("")
			attribute:Dock( TOP )
			attribute:DockMargin( 5, 5, 5, 5 )
			attribute.Paint = function(self, x, y)
				draw.RoundedBoxOutlined(2, 0, 0, x, y, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
				draw.DrawText( v.name.." [ "..Clockwork.attributes:Get(v.uniqueID).." ] ", "DermaDefault", 7, 3, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

				draw.RoundedBox(2, 0, 0, math.Clamp(Clockwork.attributes:Get(v.uniqueID) * 20, 0, 200), y, Color(100, 255, 100, 100));
			end;
	end
	
	local closebtn = vgui.Create( "DButton", frame )
	closebtn:SetText("[X]")
	closebtn:SetPos( 590, 570 )
	closebtn:SetSize(50, 30)
	closebtn:SetTextColor(Color(232, 187, 8, 255))
	closebtn.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));
		end;
	end;
	
    closebtn.DoClick = function()
		surface.PlaySound("ambient/machines/keyboard2_clicks.wav");
        frame:Close(); frame:Remove(); inventoryPanel:Remove();
	end;
	
	local firstPanel = vgui.Create( "DPanel", frame )
	firstPanel:SetPos(10, 10)
	firstPanel:SetSize(640, 550)
	firstPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;
	
	local grid = vgui.Create( "DGrid", firstPanel )
	grid:SetPos( 10, 10 )
	grid:SetCols( 5 )
	grid:SetColWide( 90 )
	grid:SetRowHeight( 60 )

	for k, v in pairs(AllSkills) do
		if v.isdefault || table.HasValue(canOpen, k) then
		    local skill = vgui.Create( "DButton" )
			skill:SetText(k)
			skill.pressedUP = false;
		    skill:SetSize(60, 50)
	    	skill:SetTextColor(Color(232, 187, 8, 255))
			skill.Paint = function(self, x, y)
				draw.RoundedBoxOutlined(2, 0, 0, x, y, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
				if tierPoints > 0 && v.tier < v.tiermax then
					surface.SetDrawColor( 247, 232, 51, 255 )
					surface.DrawLine( 50, 5, 50, 15 )
					surface.DrawLine( 55, 10, 45, 10 )
				end;
	            for i = 1, v.tier do
        	        if v.tier == v.tiermax then
    	                surface.SetDrawColor( 255, 0, 0, 255 )
	                else
                	    surface.SetDrawColor( 0, 255, 0, 255 )
					end;
        	        surface.DrawLine( 60, 45-(i*3), 0, 45-(i*3) )
    	        end;
			end;
			if sts[k] && v.tier == v.tiermax then
				skill:SetEnabled(false);
				skill:SetAlpha(100);
			end;

			skill.DoClick = function(self)
				if sts[k] && v.tier == v.tiermax then
					return;
				end;

				if v.tier == v.tiermax then
					cable.send("EditQuestOfPlayer", k, v)
					sts[k] = v.infliction;
					for k, v in pairs(v.opens) do
						table.insert(canOpen, v)
					end;
					self:SetEnabled(false);
					self:SetAlpha(100);
					frame:Close(); frame:Remove(); inventoryPanel:Remove();
					SkillsShow(st, tierPoints)
				elseif v.tier != v.tiermax && tierPoints > 0 then
					tierPoints = math.Clamp(tierPoints - 1, 0, 100);
					v.tier = math.Clamp(v.tier + 1, 0, v.tiermax)
					cable.send("EditQuestTier", tierPoints, k, v, v.tier)
					if v.tier == v.tiermax then
						self:SetEnabled(false);
						self:SetAlpha(100);
					end;
				end;
			end;
			skill.DoRightClick = function(self)
				CreateTipPanel(frame, self, v.descriptionClient)
			end;
        
			grid:AddItem(skill)
		end;
	end;
	
end;

cable.receive('CreateSkillPanel', function(st, tierPoints)
	
	SkillsShow(st, tierPoints)
end);