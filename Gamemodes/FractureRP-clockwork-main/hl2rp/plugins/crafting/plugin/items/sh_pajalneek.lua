local ITEM = Clockwork.item:New();
ITEM.name = "Паяльник";
ITEM.uniqueID = "ross_pajalnek";
ITEM.model = "models/jessev92/bfv/weapons/blowtorch_w.mdl";
ITEM.value = 0.5;
ITEM.category = "Материалы";
ITEM.customFunctions = {"Добавить топливо"};

ITEM:AddData("Fuel", 0, true)

function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, funcName)
		if (funcName == "Добавить топливо") then
            if player:HasItemByID("ross_pajalnek_fuel") && self:GetData("Fuel") == 0 then
                player:TakeItem("ross_pajalnek_fuel");
                self:SetData("Fuel", 10);
            end;
		end;	
	end;
else
    function ITEM:GetClientSideInfo()
        if (!self:IsInstance()) then return; end;
        local clientSideInfo = "";

        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Количество топлива: "..self:GetData("Fuel"), Color(120, 120, 255));
        
        return (clientSideInfo != "" and clientSideInfo);
    end;

end;

ITEM:Register();