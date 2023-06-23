local ITEM = Clockwork.item:New(nil, true);

ITEM.name = "База медицины";
ITEM.model = "";
ITEM.weight = 100;
ITEM.category = "Медицина";
ITEM.customFunctions = {"Применить к себе", "Применить к кому-то"};
ITEM.useSound = "";
ITEM.uniqueID = "medic_base"

ITEM.immunity = 0;

ITEM.healAmount = 0;
ITEM.healTime = 0;
ITEM.diseasesRem = {};
ITEM.symRem = {};
ITEM.MedattrBoost = {};

ITEM:AddData('healAmount', -1, true);
ITEM:AddData('healTime', -1, true);
ITEM:AddData('diseasesTbl', -1, true);
ITEM:AddData('symTbl', -1, true);

function ITEM:OnDrop(player, position) end;

if SERVER then

    function ITEM:OnInstantiated()
        local heals = self:GetData('healAmount');
        local time = self:GetData('healTime');
        local dis = self:GetData('diseasesTbl');
        local syms = self:GetData('symTbl');

        if heals == -1 then
            self:SetData('healAmount', self.healAmount)
        end;

        if time == -1 then
            self:SetData('healTime', self.healTime)
        end;

        if dis == -1 then
            self:SetData('diseasesTbl', self.diseasesRem)
        end;

        if syms == -1 then
            self:SetData('symTbl', self.symRem)
        end;
    end;

    function ITEM:OnCustomFunction(player, funcName)
        local diseases = self:GetData('diseasesTbl');
        local syms = self:GetData('symTbl');
        local diseasesIsNil = next(diseases) == nil;
        local symsIsNil = next(syms) == nil;
        local health = player:Health();
        local maxhealth = player:GetMaxHealth();
        local time = self:GetData("healTime");
        local healamount = self:GetData("healAmount");
        local Timestamp = os.time();
        local aB = self.MedattrBoost;
        local buffs = player:GetMedBuffs();
        local aBisNil = next(self.MedattrBoost) == nil;

        if funcName == "Применить к себе" then       

            if !diseasesIsNil then
                for disease, chance in pairs(diseases) do
                    if math.random(0, 100) - GetSkillValue(player, ATB_SUSPECTING) <= chance && player:HasLocalDisease(disease) then
                        player:RemLocalDisease(disease);
                    end;
                end;
            end;

            if self('immunity') && self('immunity') > 0 then
                player:SetCharacterData("Immunity", math.Clamp(player:GetCharacterData('Immunity') + self('immunity'), 0, 100))
            end;

            if !symsIsNil then
                for sympthom, chance in pairs(syms) do
                    player:RemSym(sympthom);
                end;
            end;
            if !aBisNil then
                for attribute, amount in pairs(aB) do
                    Clockwork.attributes:Boost(player, attribute, "AdrenalineBoost", amount, 300)
                end;
            end;
            if healamount > 0 then
                player:EmitSound(self.usesound);
                cable.send(player, 'HealEffectOn', 0.3);
                if player:IsValid() && player:Alive() && player:HasInitialized() && (buffs['time'] + time <= 60) && (buffs['amount'] + healamount <= 100) then
                    player:AddBuff(math.Clamp(buffs['time'] + time, 0, 60), math.Clamp(buffs['amount'] + healamount, 0, 100));
                end;
            end;

            player:TakeItem(self);
            player:UpdateAttribute(ATB_SUSPECTING, self.healAmount/1000);
        elseif funcName == "Применить к кому-то" then
            local trace = player:GetEyeTraceNoCursor(); local EntTrace = trace.Entity;

            if EntTrace:IsPlayer() then
                local buffs = EntTrace:GetMedBuffs();
                if !diseasesIsNil then
                    for disease, chance in pairs(diseases) do
                        if math.random(0, 100) - GetSkillValue(player, ATB_SUSPECTING) <= chance && EntTrace:HasLocalDisease(disease) then
                            EntTrace:RemLocalDisease(disease);
                        end;
                    end;
                end;
                if !symsIsNil then
                    for sympthom, chance in pairs(syms) do
                        EntTrace:RemSym(sympthom);
                    end;
                end;
                if !aBisNil then
                    for attribute, amount in pairs(aB) do
                        Clockwork.attributes:Boost(EntTrace, attribute, "AdrenalineBoost", amount, 300)
                    end;
                end;
    
                if healamount > 0 then
                    EntTrace:EmitSound(self.usesound);
                    cable.send(EntTrace, 'HealEffectOn', 0.3);
                    if EntTrace:IsValid() && EntTrace:Alive() && EntTrace:HasInitialized() && (buffs['time'] + time <= 60) && (buffs['amount'] + healamount <= 100) then
                        EntTrace:AddBuff(math.Clamp(buffs['time'] + time, 0, 60), math.Clamp(buffs['amount'] + healamount, 0, 100));
                    end;
                end;
    
                player:TakeItem(self);
                player:UpdateAttribute(ATB_SUSPECTING, self.healAmount/1000);
                player:UpdateAttribute(ATB_TOX, self.healAmount/1000);
                
                EntTrace:UpdateAttribute(ATB_SUSPECTING, self.healAmount/1000);
                EntTrace:UpdateAttribute(ATB_TOX, self.healAmount/1000);
            end;
        end;
    end;

end;

Clockwork.item:Register(ITEM);