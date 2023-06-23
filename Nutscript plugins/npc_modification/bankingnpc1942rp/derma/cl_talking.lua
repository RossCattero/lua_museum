local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();
local PANEL = {}

function PANEL:Init()
		self:Adaptate(600, 1080)
end;
function PANEL:Populate()
		self.answers = self:Add("ModScroll")
		self.answers:Dock(BOTTOM)
		self.answers:SetTall(sh * 0.2)

		self.answers.Paint = function(s, w, h)
				if self.question.DInput && self.question.DInput:IsValid() then return end;
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
		end;

		self.question = self:Add("DPanel")
		self.question:Dock(BOTTOM)
		-- self.question:DockMargin(0, 0, 0, sh * 0.05)
		self.question.Paint = function(s, w, h)
				if s.DInput && s.DInput:IsValid() then return end;
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
		end;

		self:CallQuestion(PLUGIN.startQs)
		self:CallAnswers(PLUGIN.startAns)
end;

function PANEL:CallQuestion(index)
		self.question:Clear()
		local data = PLUGIN.questions[index]
		local info = data.text;
		local text = _WrapText((data.format && data.format(info) || info), sw * 0.3, "Typewriter-small")

		for k, v in pairs(text) do
				local textLine = self.question:Add("DLabel")
				textLine:SetFont("Typewriter-small")
				textLine:Dock(TOP)
				textLine:SetContentAlignment(5)
				textLine:SetText(v)
		end
		self.question:InvalidateLayout( true )
		self.question:SizeToChildren( false, true )
end;

function PANEL:CallAnswers(data)
		self.answers:Clear()
		local i = 1;
		while (i <= #data) do
				local info = PLUGIN.answers[ data[i] ];
				if info && (info.canSee && info.canSee(LocalPlayer()) || info.service) then
						local btn = self.answers:Add("Answer")
						btn:SetText( info.text )
						btn.index = data[i]
				end;
				i = i + 1;
		end;
end;

function PANEL:Paint( w, h ) end;
vgui.Register( 'Talking', PANEL, 'SPanel' )

local PANEL = {}
function PANEL:Init()
		self:Dock(TOP)
		self:SetCursor("hand")
		self:SetMouseInputEnabled(true)
	
		self.text = self:Add("DLabel")
		self.text:SetFont("Typewriter-small")
		self.text:Dock(FILL)
		self.text:SetText("")
		self.text:SizeToContents();
		self.text:SetTextColor(Color(255, 255, 255))
		self.text:SetContentAlignment(5);
end;
function PANEL:SetText(text)
		self.text:SetText(text)
		self.text:InvalidateLayout( true )
		self.text:SizeToChildren( false, true )
end;
function PANEL:Paint( w, h ) 
		if self:IsHovered() then
				self.text:SetTextColor( Color(236,98,34) )
		else
				self.text:SetTextColor( Color(255,255,255) )
		end
end;
function PANEL:OnMousePressed()
		if INT_TALKING && INT_TALKING:IsValid() then
				local buffer = {};
				local index = self.index;
				local verb = PLUGIN.answers[index];
				if verb.service == "exit" then INT_TALKING:Close() return  end;
				local createNew = verb.newAns
				local qs = verb.question

				local i = 1;
				while (i <= #PLUGIN.answers) do
						local a = PLUGIN.answers[i];
						if a && createNew[i] then buffer[#buffer + 1] = i; end
						i = i + 1;
				end;

				if verb.input then
						INT_TALKING.question:Clear()
						INT_TALKING.answers:Clear()

						INT_TALKING.question.DInput = INT_TALKING.question:Add("DInput")
						local info = PLUGIN.questions[verb.input];
						INT_TALKING.question.DInput.text:SetText((info.format && info.format(info.text) || info.text) or "Type here:")
						INT_TALKING.question.DInput.decline.DoClick = function(s, w, h)
								INT_TALKING:CallQuestion(qs)
								INT_TALKING:CallAnswers(buffer)
						end;
						INT_TALKING.question.DInput.accept.DoClick = function(s, w, h)
								if verb.callback then
										netstream.Start('Banking::TalkerActivity', index, INT_TALKING.question.DInput.input:GetText())
								end;

								INT_TALKING:CallQuestion(qs)
								INT_TALKING:CallAnswers(buffer)
						end;

						return;
				end

				if verb.callback then
						netstream.Start('Banking::TalkerActivity', self.index)
				end

				INT_TALKING:CallQuestion(qs)
				INT_TALKING:CallAnswers(buffer)
		end
end;
vgui.Register( 'Answer', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init()
	self:Dock(BOTTOM)

	self.text = self:Add("DLabel")
	self.text:SetFont("Typewriter-small")
	self.text:Dock(TOP)
	self.text:SetText("")
	self.text:SizeToContents();
	self.text:SetTextColor(Color(255, 255, 255))
	self.text:SetContentAlignment(5);
	self.text:DockMargin(0, 0, 0, sh * 0.0025)
	
	self.input = self:Add("DTextEntry")
	self.input:Dock(TOP)
	self.input:SetTall(sh * 0.025)
	self.input:SetFont("Typewriter-small")
	self.input:SetUpdateOnType(true)
	self.input:DockMargin(sw * 0.05, 0, sw * 0.05, 0)
	self.input.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(242, 249, 255))
			s:DrawTextEntryText( Color(0, 0, 0), Color(0, 0, 0), Color(0, 0, 0) )
	end;
	self.input.OnValueChange = function(pnl, val)
		surface.PlaySound(TypeWriter)
	end;

	self.accept = self:Add("DButton")
	self.accept:SetFont("Typewriter-small")
	self.accept:Dock(LEFT)
	self.accept:SetText("Accept")
	self.accept:SetTextColor(Color(255, 255, 255))
	self.accept:SetWide(sw * 0.15)
	self.accept.Paint = function(s, w, h)
			if s:IsHovered() then
					s:SetTextColor( Color(236,98,34) )
			else
					s:SetTextColor( Color(255,255,255) )
			end
	end;

	self.decline = self:Add("DButton")
	self.decline:SetFont("Typewriter-small")
	self.decline:Dock(FILL)
	self.decline:SetText("Decline")
	self.decline:SetTextColor(Color(255, 255, 255))
	self.decline.Paint = function(s, w, h)
			if s:IsHovered() then
					s:SetTextColor( Color(236,98,34) )
			else
					s:SetTextColor( Color(255,255,255) )
			end
	end;

	local height = sh * 0.07
	self:SetTall(height)
	INT_TALKING.question:SetTall(height)
end;
function PANEL:Paint( w, h ) end;
vgui.Register( 'DInput', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init()
    local ConVas, ScrollBar = self:GetCanvas(), self:GetVBar()
    ScrollBar:SetWidth(5)
    ScrollBar:DockMargin(5, 5, 5, 5)
		ScrollBar:SetHideButtons( true )
		function ScrollBar:Paint(w, h) draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 50)) end
		function ScrollBar.btnGrip:Paint(w, h) draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 100)) end
end
vgui.Register( "ModScroll", PANEL, "DScrollPanel" )