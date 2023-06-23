ITEM.name = "Партбилет"
ITEM.description = "Патрбилет, на котором есть данные определенного рабочего."
ITEM.model = Model("models/union/props/labskeycard.mdl");

function ITEM:GetDescription()
    local default = "Патрбилет, на котором есть данные определенного рабочего."
    local partyID = self:GetData('partyID', 0);
    local name = self:GetData('owner_name', '');
    local status = self:GetData('status', '');
    local liveplace = self:GetData('liveplace', '');
    local age = self:GetData('age', 0);
    local town = self:GetData('town', '')
    
    if partyID != 0 then
        return default..' ID: '..partyID..'; Имя и фамилия: '..name..'; Статус: '..status..'; Место жительства: '..liveplace..'; Возраст: '..age..'; Город: '..town..'.'
    end;

    return default

end;

ITEM.functions.ShowItem = {
    name = "Показать",
    OnRun = function(item)
        local client = item.player;
        local partyID = item:GetData('partyID');
        local name = item:GetData('owner_name');
        local status = item:GetData('status');
        local liveplace = item:GetData('liveplace');
        local age = item:GetData('age');
        local town = item:GetData('town')

        ix.chat.Send(client, 'me', 'показал свой партбилет. Номер: '..partyID..'; Имя и фамилия: '..name.."; Статус: "..status..'; Место жительства: '..liveplace..'; Возраст: '..age..'; Город: '..town..'.');
  
        return false;
    end,
    OnCanRun = function(item)
        return !item.entity;
    end
}

ITEM.functions.ShowItemPersonaly = {
    name = "Показать лично",
    OnRun = function(item)
        local client = item.player;
        local target = client:GetEyeTraceNoCursor().Entity;
        local partyID = item:GetData('partyID', 0);
        local name = item:GetData('owner_name', '');
        local status = item:GetData('status', '');
        local liveplace = item:GetData('liveplace', '');
        local age = item:GetData('age', 0);
        local town = item:GetData('town', '')

        ix.chat.Send(client, 'me', 'показал свою карту лично.')
        target:Notify(client:Name()..' показал вам свою карточку. Номер: '..partyID..'; Имя и фамилия: '..name.."; Статус: "..status..'; Место жительства: '..liveplace..'; Возраст: '..age..'; Город: '..town..'.');
  
        return false;
    end,
    OnCanRun = function(item)
        local client = item.player;
        local target = client:GetEyeTraceNoCursor().Entity;

        return !item.entity && (IsValid(client) && target:IsPlayer());
    end
}

function ITEM:OnInstanced()
    local identificator = self:GetData('partyID');

    if !identificator then
        self:SetData('partyID', 0);
        self:SetData('owner_name', 'Unauthorized');
        self:SetData('status', 'ALPHA');
        self:SetData('liveplace', 'Parts unknown');
        self:SetData('age', 0);
        self:SetData('town', 'Parts unknown')
    end;
end;