local mc = math.Clamp;
local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Медицина";
ITEM.uniqueID = "med_base";
ITEM.model = "models/props_junk/cardboard_box001a.mdl";
ITEM.weight = 5;
ITEM.category = "Медицина";
ITEM.customFunctions = {"Применить к себе", "Применить к кому-то"};
ITEM.remsympthoms = {};
ITEM.timereg = 0;
ITEM.amount = 0;
ITEM.toxrem = 0;

ITEM:AddData("TimeToRegen", -1, true);
ITEM:AddData("Amount", -1, true);
ITEM:AddData("RemSympthoms", {}, true);
ITEM:AddData("Toxins", -1, true)

function ITEM:OnDrop(player, position) end;

if SERVER then
    function ITEM:OnInstantiated()
       
        if (self:GetData("RemSympthoms") == {}) then
            self:SetData("RemSympthoms", self("remsympthoms"));
        end;
        if (self:GetData("Amount") == -1) then
            self:SetData("Amount", self("amount"));
        end;
        if (self:GetData("Toxins") == -1) then
            self:SetData("Toxins", self("toxrem"));
        end;
        if (self:GetData("TimeToRegen") == -1) then
            self:SetData("TimeToRegen", self("timereg"));
        end;


    end;
    function ITEM:OnCustomFunction(player, funcName)
        local trace = player:GetEyeTraceNoCursor();
        local target = trace.Entity:IsPlayer();
        local tbl = player:GetCharacterData("RegenMeHealth")

        if (funcName == "Применить к себе") then
            if tbl[1]["healthadd"] == 0 then
                tbl[1]["healthadd"] = math.Clamp(tbl[1]["healthadd"] + self:GetData("Amount"), 0, 250);
            else
                tbl[1]["healthadd"] = math.Clamp(tbl[1]["healthadd"] + self:GetData("Amount")/10, 0, 250);
            end;
            tbl[1]["timeregen"] = math.Clamp(tbl[1]["timeregen"] + self:GetData("TimeToRegen"), 0, 100);
            if GetSkillValue(player, ATB_SUSPECTING) < 10 then
                Clockwork.attributes:Update(player, ATB_SUSPECTING, self:GetData("Amount") - (1 - GetSkillValue(player, ATB_SUSPECTING)/10))
            end;

            if self:GetData("RemSympthoms") != {} then
                for k, v in pairs( self:GetData("RemSympthoms") ) do
                    if player:HasSym(v) then
                        if math.random(1, 100) >= 50 then
                            player:RemSym(v)
                        end;
                    end;
                end;
            end;

            if self:GetData("Toxins") > 0 then
                player:SetNeed("toxins", mc(player:GetNeed("toxins") - self:GetData("Toxins"), 0, 100))
            end;

            player:TakeItem(self)
		end;
		if (funcName == "Применить к кому-то") then
            if target then
                local tbl1 = target:GetCharacterData("RegenMeHealth")

                if tbl1[1]["healthadd"] == 0 then
                    tbl1[1]["healthadd"] = math.Clamp(tbl1[1]["healthadd"] + self:GetData("Amount"), 0, 250);
                else
                    tbl1[1]["healthadd"] = math.Clamp(tbl1[1]["healthadd"] + self:GetData("Amount")/10, 0, 250);
                end;
                tbl1[1]["timeregen"] = math.Clamp(tbl1[1]["timeregen"] + self:GetData("TimeToRegen"), 0, 100);
                if GetSkillValue(player, ATB_SUSPECTING) < 10 then
                    Clockwork.attributes:Update(player, ATB_SUSPECTING, self:GetData("Amount") - (1 - GetSkillValue(player, ATB_SUSPECTING)/10))
                end;
                
                if self:GetData("RemSympthoms") != {} then
                    for k, v in pairs( self:GetData("RemSympthoms") ) do
                        if target:HasSym(v) then
                            if math.random(1, 100) >= 50 then
                                target:RemSym(v)
                            end;
                        end;
                    end;
                end;
    
                if self:GetData("Toxins") > 0 then
                    target:SetNeed("toxins", mc(target:GetNeed("toxins") - self:GetData("Toxins"), 0, 100))
                end;
                player:TakeItem(self)
            end;
		end;		
	end;
end;

Clockwork.item:Register(ITEM);
