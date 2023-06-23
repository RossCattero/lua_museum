local PLUGIN = PLUGIN;

local PANEL = {}
function PANEL:Init()
		self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(1000, 500, 0.25, 0.537)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);
end

function PANEL:Paint(w, h)
end;

function PANEL:Populate()
		self.answerList = {};

		self.answers = self:Add("ModScroll")
		self.answers:Dock(BOTTOM)
		self.answers:SetTall(185)
		self.answers.Paint = function(s, w, h)
			surface.SetDrawColor(Color(70, 70, 70, 150))
    	surface.DrawRect(0, 0, w, h)
    	surface.SetDrawColor(Color(0, 99, 191))
    	surface.DrawOutlinedRect( 0, 0, w, h, 1 )
		end;

		local firstTime = {};
		for k, v in pairs(PLUGIN.Answers) do
			if v.close || v.CanShow && v.CanShow(LocalPlayer()) == true then
				firstTime[#firstTime + 1] = k;
			end
		end
		self:Remake(firstTime)

		self.talkBack = self:Add("ModLabel")
		self.talkBack.tb = "";
		for k, v in pairs(PLUGIN.TalkBacks) do
			if v.OnOpen then
					self.talkBack.tb = k;
					break;
			end
		end
		self.talkBack:Dock(BOTTOM)
		local tb = PLUGIN.TalkBacks[self.talkBack.tb];
		BUFF_TALKBACK = PLUGIN.TalkBacks[self.talkBack.tb].text
		self.talkBack:SetText(tb.format && tb.format(tb.text) || tb.text || "");
		self.talkBack:SetFont("Generic Banking")
		self.talkBack:DockMargin(10, 10, 10, 10)		
		self.talkBack:SetAlpha(0)

		self.talkBack:AlphaTo(255, .3, 0, function(anim, pnl)
				pnl:SetAlpha(255);
		end)
end;

function PANEL:Remake(massive)
		if #massive == 0 then return end;
		self.answers:Clear();

		for k, v in pairs(massive) do
			local data = PLUGIN.Answers[v];

			if !data then continue; end;
			local ans = self.answers:Add("Answer")
			ans:SetData(v, data)

			self.answerList[#self.answerList + 1] = ans;
		end
end;

function PANEL:Reinform(data, defTalk)
		local interface = PLUGIN.interface
		buff = {}
		if data.talkBack then
			local talkBack = PLUGIN.TalkBacks[data.talkBack];
			if !defTalk then
					interface.talkBack:SetText(talkBack.format && talkBack.format(talkBack.text) || talkBack.text || "");
				else
					interface.talkBack:SetText(BUFF_TALKBACK);
			end;
			interface.talkBack:SetWrap(interface.talkBack:GetText():len() > 10 + interface.talkBack:GetWide()/10)
			interface.talkBack:AlphaTo(255, .2, 0, function(anim, pnl)
					pnl:SetAlpha(255)
			end)
		end

		if data.remClick && #data.remClick > 0 then
				for id, answ in ipairs(data.remClick) do
						local a = PLUGIN.Answers[answ]
						if interface.answerList[id] && a && (!a.close || !a.CanShow || a.CanShow && !a.CanShow(LocalPlayer())) then
								interface.answerList[id]:Remove();
								interface.answerList[id] = nil;
						end;
				end;
				for k, v in pairs(interface.answerList) do
						buff[#buff + 1] = k;
				end;
		end

		if data.callClick && #data.callClick > 0 then
				for k, answ in ipairs(data.callClick) do
						local a = PLUGIN.Answers[answ]
						if a && (a.close || !a.CanShow || a.CanShow && a.CanShow(LocalPlayer())) then
								buff[#buff + 1] = answ
						end;
				end
		end

		return buff;
end;

vgui.Register( "Talking", PANEL, "EditablePanel" )