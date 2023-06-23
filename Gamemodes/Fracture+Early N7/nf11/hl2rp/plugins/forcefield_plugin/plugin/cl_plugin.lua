
local PLUGIN = PLUGIN;

function OpenFactionInfo(ent, factionTBL)
    local scrW = surface.ScreenWidth();
    local scrH = surface.ScreenHeight();
    local sW = (scrW/2) - 250;
	local sH = (scrH/2) - 350;

	local frame = vgui.Create("DFrame");
	frame:SetPos(sW, sH)
	frame:SetSize(300, 400)
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
		if ( self.m_bBackgroundBlur ) then
            Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
        end
		draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
    end;

    local factions = vgui.Create( "DScrollPanel", frame )
	factions:Dock( FILL )
    factions.factions = {}
    
    local closebtn = vgui.Create( "DButton", frame )
	closebtn:SetText("[X]")
	closebtn:SetPos( 260, 10 )
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
        frame:Close(); frame:Remove();
    end;
    
	local tbl;

	if table.Count(factionTBL) == 0 then
		tbl = Clockwork.faction.stored;
	else
		tbl = factionTBL;
	end;

	for k, v in pairs(tbl) do
		local FactionBox = factions:Add( "DCheckBoxLabel" )
		FactionBox:Dock(TOP)
		FactionBox:SetText( k )
		if table.Count(factionTBL) == 0 then
			factions.factions[k] = true;
		else
			factions.factions[k] = v;
		end;
		FactionBox:SetValue(factions.factions[k])
		function FactionBox:OnChange( val )
			factions.factions[k] = val;

			cable.send('GetForceFieldFactionM', ent, factions.factions);
		end

	end;
    
end;

cable.receive('OpenForceFieldSettings', function(entity, table)
    OpenFactionInfo(entity, table)
end);