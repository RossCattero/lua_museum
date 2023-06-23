ix.command.Add("DEBUG_open_datapad", {
	description = "Open datapad for debugging purposes",
    superAdminOnly = true,
	OnRun = function(self, client)
        ix.datapad.OpenUI()
	end
})