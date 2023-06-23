-- Add permission 'Open datapad' to group you trust on SAM or ULX;
ix.command.Add("admin_datapad", {
	description = "Open datapad (for superadmins).",
	privilege = "Open datapad",
	superAdminOnly = true,
	OnRun = function(self, client)
		client:SetLocalVar("_persona", ix.archive.police.New(
			{
				id = client:GetCharacter():GetID(), 
				name = "SUPERADMIN", 
				rank = "dispatcher"
			}))
		ix.datapad.Open(client, true)
	end
})