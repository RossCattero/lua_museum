local FACTION = Clockwork.faction:New("Administrator");
local PLUGIN = PLUGIN;
FACTION.whitelist = true;
FACTION.material = "";
FACTION.models = {
  male = {"models/odessa.mdl"}};

function FACTION:GetName(player, character)
  return player:SteamName();
end;

function FACTION:GetModel(player, character)
  if (character.gender == GENDER_MALE) then
    return self.models.male[1];
  end;
end;

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
  if (player:IsAdmin() || player:IsSuperAdmin()) then
	Clockwork.player:GivePlayerFlags(player, "petGD");
  player:SetCharacterData( "hunger", -1 );
  player:SetCharacterData( "thirst", -1 );
  player:SetCharacterData( "sleep", -1 );
else
  player:SetCharacterData( "hunger", -1 );
  player:SetCharacterData( "thirst", -1 );
  player:SetCharacterData( "sleep", -1 );
  end;
end;

-- Called when a player's scoreboard class is needed.
function PLUGIN:GetPlayerScoreboardClass(player)
 local faction1 = player:GetFaction();
 local clientfaction = Clockwork.Client:GetFaction();
  if (faction1 == FACTION_INCOG) then
  if (Clockwork.Client:GetFaction() == FACTION_INCOG) then
   return "Administration"; -- Edit this part for the name on the scoreboard.
  elseif (Clockwork.Client:IsAdmin()) then
   return "Hidden Faction(ADMIN/OOC View)";
  else
   return false;
  end;
 end;
end;
 
FACTION_INCOG = FACTION:Register();