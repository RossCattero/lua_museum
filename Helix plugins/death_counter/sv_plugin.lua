local PLUGIN = PLUGIN;


--[[ Serverside global boolean below to enable or disable DeathCounter: ]]--
EnableDeathCounter = EnableDeathCounter or false;

--[[ netstream hook, which changes active global death counter bool. Only for admins ]]--

netstream.Hook('ToggleDeathCounter', function(client, bool)
	if client:IsAdmin() or client:IsSuperAdmin() then
        EnableDeathCounter = bool;

        for k, v in pairs(player.GetAll()) do
            netstream.Start(v, 'NetworkGlobalDeathCounters', EnableDeathCounter)
        end;
	end;
end);

--[[ this code below adds death counter to character and synchronize it with player; ]]--
function PLUGIN:OnCharacterCreated(client, character)
    character:SetData("deathCounter", 0)
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    timer.Simple(0.25, function()
        client:SetLocalVar("deathCounter", character:GetData("deathCounter", 0))
    end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("deathCounter", client:GetLocalVar("deathCounter", 0))
    end
end

--[[ Global hook to check if player has died. ]]--
function PLUGIN:PlayerDeath(victim, inflictor, attacker)
	if EnableDeathCounter && victim:GetCharacter() then
        victim:AddDeath(1);
	end;
end

--[[ meta ]]--
local ply = FindMetaTable("Player")

function ply:AddDeath(number) -- function to add death to character and synchronize it;
    local char = self:GetCharacter();
    local charDeath = char:GetData('deathCounter');
    local playerDeath = self:GetLocalVar('deathCounter')

    char:SetData('deathCounter', charDeath + number);
    self:SetLocalVar('deathCounter', playerDeath + number);
end;

function ply:EditDeath(number) -- function to edit death to character and synchronize it;
    local char = self:GetCharacter();

    char:SetData('deathCounter', number);
    self:SetLocalVar('deathCounter', number);
end;