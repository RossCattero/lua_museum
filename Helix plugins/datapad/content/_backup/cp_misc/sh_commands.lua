ix.command.Add("CCASetRank", {
	description = "Set the character's CCA rank.",
    superAdminOnly = true,
    arguments = {
		ix.type.player,
        ix.type.text
	},
	OnRun = function(self, client, target, rankText)
        if not ix.ranks.Allowed(target:GetFaction()) then
            client:Notify("Target's faction is not allowed to set ranks. See console for more details.")
            error("Say dev to add faction index into cp_ranks/libs/sh_ranks.lua file.")
            return;
        end;

        if not ix.ranks.Get(rankText) then
            client:Notify("Specified rank is not valid!")
            return;
        end;

        ix.ranks.SetRank(target:GetCharacter(), rankText)
        client:Notify("You've successfully changed the target rank to %s", rankText)
	end
})