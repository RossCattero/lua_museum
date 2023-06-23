local PLUGIN = PLUGIN;

local PANEL = {}
function PANEL:Init()
		self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(450, 240, 0.42, 0.35)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);
end

function PANEL:Populate()
    local sw, sh = ScrW(), ScrH()
    local char = LocalPlayer():getChar();
    local bankID = char:getData("banking_account")

    local funcs = {
        [1] = {
          name = "Withdraw",
          Disable = function()
              return bankID == 0;
          end,
          Exe = function(btn)
            if !btn.disabled then
                if !self.TypeBG || !self.TypeBG:IsValid() then
                  self.btnList[2]:Dis(true)
                  self:SizeTo(self:GetWide(), self:GetTall() + sw * 0.035, .2, 0, -1, function()        
                    self.TypeBG = self:Add("Panel") 
                    self.TypeBG:Dock(BOTTOM)
                    self.TypeBG:SetZPos(-1) 
                    self.TypeBG:DockMargin(10, 10, 10, 10)
                    self.TypeBG:SetAlpha(0)
                    self.TypeBG:SetTall(sw * 0.035)

                    self.TypeBG:AlphaTo(255, .2, 0, function() end)

                    self.PayLBL = self.TypeBG:Add("ModLabel")
                    self.PayLBL:Dock(TOP)
                    self.PayLBL:SetText("Specify amount: ")
                    self.PayLBL:SetFont("Banking id")

                    self.TypeAmount = self.TypeBG:Add("ModEntry")
                    self.TypeAmount:Dock(TOP)
                    self.TypeAmount:SetFont("Banking id")

                    self.TypeAgree = self.TypeBG:Add("MButt")
                    self.TypeAgree:Dock(TOP)
                    self.TypeAgree:SetText("Submit")
                    self.TypeAgree:SetFont("Banking id")
                    self.TypeAgree:SetTall(sw * 0.015)

                    self.TypeAgree.DoClick = function(btn)
                        local ply = LocalPlayer();
                        local amount = tonumber(self.TypeAmount:GetText());
                        if !amount || amount <= 0 then 
                          surface.PlaySound("buttons/button8.wav")
                          return 
                        end;
                        if !ply.execCD || CurTime() >= ply.execCD then
                          netstream.Start('bankeer::exec', "bank_withdrawmoney", amount)
                          self.TypeAmount:SetText("")
                          ply.execCD = CurTime() + 5;
                        else
                            surface.PlaySound("buttons/button8.wav")
                        end;
                    end;
                end)
              else
                  self.TypeBG:AlphaTo(0, .2, 0, function(anim, pnl) 
                      pnl:Remove()
                  end)
                  self:SizeTo(self:GetWide(), self:GetTall() - sw * 0.035, .2, .3, -1, function() 
                    self.btnList[2]:Dis(false)
                  end)
              end
            end
          end,
        },
        [2] = {
          name = "Deposit",
          Disable = function()
            return bankID == 0;
          end,
          Exe = function(btn)
            if !btn.disabled then
              if !self.TypeBG || !self.TypeBG:IsValid() then
                  self.btnList[1]:Dis(true)
                self:SizeTo(self:GetWide(), self:GetTall() + sw * 0.035, .2, 0, -1, function()        
                    self.TypeBG = self:Add("Panel") 
                    self.TypeBG:Dock(BOTTOM)
                    self.TypeBG:SetZPos(-1) 
                    self.TypeBG:DockMargin(10, 10, 10, 10)
                    self.TypeBG:SetAlpha(0)
                    self.TypeBG:SetTall(sw * 0.035)

                    self.TypeBG:AlphaTo(255, .2, 0, function() end)

                    self.PayLBL = self.TypeBG:Add("ModLabel")
                    self.PayLBL:Dock(TOP)
                    self.PayLBL:SetText("Specify amount: ")
                    self.PayLBL:SetFont("Banking id")

                    self.TypeAmount = self.TypeBG:Add("ModEntry")
                    self.TypeAmount:Dock(TOP)
                    self.TypeAmount:SetFont("Banking id")

                    self.TypeAgree = self.TypeBG:Add("MButt")
                    self.TypeAgree:Dock(TOP)
                    self.TypeAgree:SetText("Submit")
                    self.TypeAgree:SetFont("Banking id")
                    self.TypeAgree:SetTall(sw * 0.015)
                    self.TypeAgree.DoClick = function(btn)
                        local ply = LocalPlayer();
                        local amount = tonumber(self.TypeAmount:GetText());
                        if !amount || amount <= 0 then 
                          surface.PlaySound("buttons/button8.wav")
                          return 
                        end;
                        if !ply.execCD || CurTime() >= ply.execCD then
                          netstream.Start('bankeer::exec', "bank_depositmoney", amount)
                          self.TypeAmount:SetText("")
                          ply.execCD = CurTime() + 5;
                        else
                            surface.PlaySound("buttons/button8.wav")
                        end;
                    end;
                end)
              else
                  self.TypeBG:AlphaTo(0, .2, 0, function(anim, pnl) 
                      pnl:Remove()
                  end)
                  self:SizeTo(self:GetWide(), self:GetTall() - sw * 0.035, .2, .3, -1, function() 
                      self.btnList[1]:Dis(false)
                  end)
              end
            end
          end, 
        },
        [3] = {
          name = "Exit",
          Exe = function()
              self:Close()
          end,
        }
    }

    self.ATMLabel = self:Add("ModLabel")
    self.ATMLabel:Dock(TOP)
    self.ATMLabel:SetText("ATM")
    self.ATMLabel:SetFont("Banking id")

    self.ATMInfo = self:Add("ModScroll")
    self.ATMInfo:Dock(RIGHT)
    self.ATMInfo:SetWide(sw * 0.12)

    self.bankID = self.ATMInfo:Add("ModLabel")
    self.bankID:SetText("Account id: " .. bankID)
    self.bankID:SetFont("Banking id")

    self.MoneyAmount = self.ATMInfo:Add("ModLabel")
    self.MoneyAmount:SetText("Money: " .. PLUGIN.bankINFO["money"] .. nut.currency.symbol )
    self.MoneyAmount:SetFont("Banking id")

    self.Loan = self.ATMInfo:Add("ModLabel")
    self.Loan:SetText("Loan: " .. PLUGIN.bankINFO["loan"] .. nut.currency.symbol)
    self.Loan:SetFont("Banking id")

    self.ButtonList = self:Add("ModScroll")
    self.ButtonList:Dock(RIGHT)
    self.ButtonList:SetWide(sw * 0.15)
    self.btnList = {}

    for k, v in pairs(funcs) do
      self.btnList[k] = self.ButtonList:Add("MButt")
      self.btnList[k]:SetTall(sh * 0.06)
      self.btnList[k]:SetText(v.name)
      self.btnList[k]:SetFont("Banking id")
      self.btnList[k]:Dis(v.Disable && v.Disable())
      self.btnList[k].DoClick = function(btn)
          if !btn.Click || CurTime() > btn.Click then
            v.Exe(btn)
            btn.Click = CurTime() + 1;
          end;
      end;
    end
end;

function PANEL:Paint( w, h )
    -- self:CreateClose_()
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		surface.SetDrawColor(Color(70, 70, 70, 150))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(0, 99, 191))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )
end;

vgui.Register( "ATMUI", PANEL, "EditablePanel" )