local PANEL = {}
local PLUGIN = PLUGIN;

function PANEL:Init()
		self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(900, 500, 0.27, 0.25)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);
end

function PANEL:Populate()
		local sw, sh = ScrW(), ScrH()
		self.SubPanel = self:Add("Panel")
		self.SubPanel:Dock(FILL)
		self.SubPanel:DockMargin(4, 4, 4, 4)
		self.SubPanel.Paint = function(s, w, h)
			surface.SetDrawColor(Color(0, 255, 255))
    		surface.DrawOutlinedRect( 0, 0, w, h, 2 )
		end;

		self.Logs = self.SubPanel:Add("BankingLogs")
		self.Logs:Dock(FILL)
		self.Logs:ADDColumn( "Action" )
		self.Logs:ADDColumn( "Who did this" )
		self.Logs:ADDColumn( "Time" )
		
        for k, v in ipairs(BankingLogs) do
            v = pon.decode(v)
            local log = self.Logs:ADDLine(v.text, v.whoIs, v.date)        
            log.priority = (v.priority == 1 && Color(255, 0, 255)) ||
                    (v.priority == 2 && Color(0, 255, 0)) ||
                    Color(0, 255, 255)
            for k, v in pairs(log.Columns) do
                
                v:SetTextColor(
                    log.priority
                )
                v:SetContentAlignment(5)
                v:SetFont("Banking info smaller")
                v.Paint = function(s, w, h)
                    if log:IsHovered() then
                        s:SetTextColor(Color(0, 0, 0))
                    else
                        s:SetTextColor(log.priority)
                    end
                end;
            end
        end

		self.CloseBG = self.SubPanel:Add("Panel")
		self.CloseBG:Dock(TOP)
		self.CloseBG:DockMargin(0, 7, 7, 0)

		self.CloseButton = self.CloseBG:Add("MButt")
		self.CloseButton:Dock(RIGHT)
		self.CloseButton:SetWide(sw * 0.02)
		self.CloseButton:SetText("X")
		self.CloseButton.Paint = function(s, w, h)
			if s:IsHovered() then
					draw.RoundedBox(0, 0, 0, w, h, Color(0, 128, 128))
			end;
		end;
		self.CloseButton.DoClick = function(btn)
				self:Close()
		end;

end

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	surface.SetDrawColor(Color(0, 0, 128))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(0, 255, 255))
    surface.DrawOutlinedRect( 0, 0, w, h, 2 )
end;

vgui.Register( "Banking_logs", PANEL, "EditablePanel" )

local PANEL = {}

function PANEL:Init()
    self:Dock(FILL)
    self:DockMargin(5, 5, 5, 5)
end

function PANEL:ADDColumn(str, pos)
    local column = self:AddColumn(str, pos)
    column.Header:SetTextColor(Color(255, 255, 0))
    column.Header:SetFont("Banking info smaller")
    column.Header.id = column:GetColumnID()
    column.Header.Paint = function(s, w, h)  end;

    return column;
end;

function PANEL:ADDLine(...)
    local line = self:AddLine(...)  
    line:SetSelectable(false)  
    line.Paint = function(s, w, h)
        if s:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 128, 128))
        end
    end;

    return line
end;


function PANEL:Paint( w, h ) 
    surface.SetDrawColor(Color(0, 255, 255))
		surface.DrawLine(0, h-0.1, w, h-0.1)      
end;

vgui.Register( "BankingLogs", PANEL, "DListView" )