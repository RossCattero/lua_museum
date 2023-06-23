-- Set character rank by admin;
ix.command.Add("setPoliceRank", {
	description = "Set character CCA rank.",
    superAdminOnly = true,
    arguments = {
		ix.type.character,
		ix.type.text
	},
	OnRun = function(self, client, target, rankName)
        rankName = rankName:lower()
        if not ix.ranks.Get(rankName) then
            client:Notify("Invalid rank uniqueID specified.")
            return;
        end;

        if not ix.archive.police.IsCombine(target:GetFaction()) then
            client:Notify("Target faction is not CCA faction.")
            return;
        end;

        local id = target:GetID()
        local charData = ix.archive.Get(id)
        charData:SetRank(rankName)

        target.player:Notify(Format("Your rank was changed to %s by %s", rankName, client:GetName()))
        client:Notify(Format("You've changed %s's rank to %s", target:GetName(), rankName))
	end
})