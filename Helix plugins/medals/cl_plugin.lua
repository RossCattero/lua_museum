local PLUGIN = PLUGIN;

local boneOffset = Vector(0, 0, 4)
local standingOffset = Vector(0, 0, 72)
local crouchingOffset = Vector(0, 0, 38)
local medalDrawMax = 3;
local medalSize = 128

// Taken from typing.lua in helix plugins;
function PLUGIN:GetTypingIndicatorPosition(client)
		local head

		for i = 1, client:GetBoneCount() do
			local name = client:GetBoneName(i)

			if (string.find(name:lower(), "head")) then
				head = i
				break
			end
		end

		local position = head and client:GetBonePosition(head) or (client:Crouching() and crouchingOffset or standingOffset)
		return position + boneOffset
end

function PLUGIN:PostDrawTranslucentRenderables()
		local client = LocalPlayer();
		local trace = client:GetEyeTrace()
		local ent = trace.Entity;

		if !ent || !ent:IsPlayer() || ent == client || !ent:GetNetVar("Medals") then
				return;
		end

		if client:GetPos():DistToSqr( ent:GetPos() ) > 512 * 512 then
				return;
		end

		local angle = EyeAngles()
		angle:RotateAroundAxis(angle:Forward(), 90)
		angle:RotateAroundAxis(angle:Right(), 90)

		cam.Start3D2D(self:GetTypingIndicatorPosition(ent), Angle(0, angle.y, 90), 0.05)
			local data = ent:GetNetVar("Medals");
			if data then
					local i = 1;
					for k, v in pairs( data ) do
							if i > medalDrawMax then break end;
								if self.medals[k] then
									surface.SetMaterial( self.medals[k] )
									surface.SetDrawColor(Color(255, 255, 255))
									surface.DrawTexturedRect( i * medalSize, 0, medalSize, medalSize )
								end;
							i = i + 1;
					end
			end
		cam.End3D2D()
end;