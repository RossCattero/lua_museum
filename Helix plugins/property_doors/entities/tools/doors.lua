TOOL.AddToMenu = true
TOOL.Category = "HL2RP - property system"
TOOL.Name = "Assign door"

function TOOL.BuildCPanel( CPanel )
	ix.gui.doors = vgui.Create("PropertySystem", CPanel);
end;

function TOOL:LeftClick( trace )
	if CLIENT then
		local entity = trace.Entity;

		if entity then
			if entity:IsDoor() then
				if IsValid(ix.gui.doors) then
					net.Start("ix.doors.setDoor")
						net.WriteString(ix.gui.doors:GetDoorName())
					net.SendToServer()
				end;
			else
				ix.util.Notify("You need to aim at door to do this.")
			end;
		end;
	end;

	return true;
end;

function TOOL:RightClick( trace ) return false; end;
function TOOL:FreezeMovement() return false; end;
function TOOL:DrawHUD() return false end;
function TOOL:ReleaseGhostEntity() return false; end;
function TOOL:GetHelpText() return false; end;
function TOOL:UpdateData() return false; end;
function TOOL:Think() return; end