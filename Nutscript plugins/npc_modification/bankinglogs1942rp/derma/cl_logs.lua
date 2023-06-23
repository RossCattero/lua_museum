local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();
local PANEL = {}
function PANEL:Init()
	self:Adaptate(1024, 800)
	self.sides = {};

	PAGE = 1;
	ITEMS_ON_PAGE = 25;
end;

function PANEL:Populate()
		local i = 1;
		while (i <= 2) do
				local side = self:Add("NewBS")
				side:Populate(i)
				self.sides[i] = side;
				i = i + 1;
		end

		self:ReloadItems()
end;

function PANEL:ReloadItems()
		local logs = BANKING_LOGS.logs
		local s = 1;
		for i = PAGE, PAGE + 1 do
				local min = (i - 1) * ITEMS_ON_PAGE + 1;
				local max = (i * ITEMS_ON_PAGE)
				local side = self.sides[s]
				side.info:Clear();
				side.number:SetText(i)
				side.number:SizeToContents()

				for j = min, max do
						local log = logs[j];
						if log then
								local line = side.info:line(log.who, log.text, log.time)
								line.type = log.tp
						end
				end

				s = s + 1;
		end
		
		if !logs[(PAGE - 1) * ITEMS_ON_PAGE - 1] then
			self.sides[1].button:SetEnabled(false)
		else
			self.sides[1].button:SetEnabled(true)
		end
		if !logs[(PAGE) * ITEMS_ON_PAGE - 1] then			
			self.sides[2].button:SetEnabled(false)
		else
			self.sides[2].button:SetEnabled(true)
		end
end;

function PANEL:Paint( w, h )
		if CLOSEDEBUG then self:DebugClose() end;
		self:DrawBlur()

		surface.SetMaterial( BankBook )
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect( 0, 0, w, h )
end;
vgui.Register( 'BankingLogs', PANEL, 'SPanel' )

local PANEL = {}
function PANEL:Init() end;
function PANEL:Populate(i)
	self:Dock(i == 1 && LEFT || RIGHT)
	self:SetWide(i == 1 && sw * 0.245 || sw * 0.255)
	self:DockMargin( 
		i == 1 && sw * 0.0135 || 0, 
		sh * 0.03, 
		i == 1 && 0 || sw * 0.012,
		i == 1 && sh * 0.025 || sh * 0.024
	)

	self.info = self:Add( "LogList" )
	self.info:Dock( FILL )
	self.info:SetMultiSelect( false )
	self.info:column("ID")
	self.info:column("Text")
	self.info:column("Time")

	self.footer = self:Add("DPanel")
	self.footer:Dock(BOTTOM)
	self.footer:SetTall(sh * 0.03)

	self.number = self.footer:Add("DLabel")
	self.number:SetFont("Gbanking")
	self.number:Dock(i == 1 && LEFT || RIGHT)
	self.number:SetText(i)
	self.number:SizeToContents();
	self.number:SetTextColor( Color(0, 0, 0) )
	self.number:DockMargin(
		i == 1 && sw * 0.01 || 0, 
		0, 
		i == 1 && 0 || sw * 0.01, 
		0 
	)

	if i == 1 then
			self.close = self.footer:Add("DButton")
			self.close:Dock(FILL)
			self.close:SetFont("Gbanking")
			self.close:SetText("Close book")
			self.close:SizeToContents()
			self.close.Paint = nil;
			self.close.DoClick = function(btn)
					if INT_LOGS && INT_LOGS:IsValid() then
						INT_LOGS:Close()
					end;
			end;
	end;

	self.button = self.footer:Add("DButton")
	self.button:Dock(i == 1 && RIGHT || LEFT)
	self.button:SetFont("Gbanking")
	self.button:SetText(i == 1 && "Previous" || "Next")
	self.button:SizeToContents()
	self.button.index = i;
	self.button:DockMargin(
		i == 1 && 0 || sw * 0.015,
		0,
		i == 1 && sw * 0.015 || 0,
		0
	)

	self.button.DoClick = function(btn)
			if INT_LOGS && INT_LOGS:IsValid() then
					PAGE = PAGE + (btn.index == 2 && 2 || -2);
					INT_LOGS:ReloadItems()
			end;
	end;

	self.footer.Paint = nil;
	self.button.Paint = nil
	self.info.Paint = nil

end;
function PANEL:Paint( w, h ) end;
vgui.Register( 'NewBS', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init() end;
function PANEL:column(str, num)
		local column = self:AddColumn(str, num)
		column.Header:SetFont("Typewriter-check")
		column.Header.Paint = nil;
		if str == "Text" then
				column:SetWidth(250)
		end
end;
function PANEL:line(...)
		local line = self:AddLine(...)
		line:SetSelectable(false)
		line.Paint = nil;

		timer.Simple(0, function()
				for k, v in pairs(line.Columns) do
						v:SetFont("Gbanking-handy")
						v:SetContentAlignment(5)
						v:SetTextColor(BANKING_LOGS.colors[line.type] || Color(0, 0, 0))
						v.Paint = nil;
						-- v:SizeToContents()
				end
		end)

		return line;
end;
function PANEL:Paint( w, h )
	
end;
vgui.Register( 'LogList', PANEL, 'DListView' )
