include("shared.lua");
local material = Material("maps/rp_city14_utopia/effects/com_shield003a_78_340_14");
local material2 = Material("effects/com_shield004a");

function ENT:Initialize()
		local data = {};
		data.start = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -16;
		data.endpos = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -600;
		data.filter = self;
		local trace = util.TraceLine(data);

		local verts = {
			{pos = Vector(0, 0, -35)},
			{pos = Vector(0, 0, 150)},
			{pos = self:WorldToLocal(trace.HitPos - Vector(0, 0, 50)) + Vector(0, 0, 150)},
			{pos = self:WorldToLocal(trace.HitPos - Vector(0, 0, 50)) + Vector(0, 0, 150)},
			{pos = self:WorldToLocal(trace.HitPos - Vector(0, 0, 50)) - Vector(0, 0, 35)},
			{pos = Vector(0, 0, -35)},
		};

		self:PhysicsFromMesh(verts);
		self:EnableCustomCollisions(true);
end;

function ENT:Draw()
		local post = self:GetEntInfo();
		local angles = self:GetAngles();
		local matrix = Matrix();

		self:DrawModel();
		matrix:Translate(self:GetPos() + self:GetUp() * -40 + self:GetForward() * -2);
		matrix:Rotate(angles);

		render.SetMaterial(material);

		if (IsValid(post)) then
			local vertex = self:WorldToLocal(post:GetPos());
			self:SetRenderBounds(vector_origin - Vector(0, 0, 40), vertex + self:GetUp() * 150);

			cam.PushModelMatrix(matrix);
			self:DrawShield(vertex);
			cam.PopModelMatrix();

			matrix:Translate(vertex);
			matrix:Rotate(Angle(0, 180, 0));

			cam.PushModelMatrix(matrix);
			self:DrawShield(vertex);
			cam.PopModelMatrix();
		end;
end;

function ENT:DrawShield(vertex)
		if self:GetIsTurned() then

		local dist = self:GetEntInfo():GetPos():Distance(self:GetPos());
		local useAlt = self:GetDTBool(1);
		local matFac = useAlt and 70 or 45;
		local height = useAlt and 3 or 5;
		local frac = dist / matFac;
		mesh.Begin(MATERIAL_QUADS, 1);
		mesh.Position(vector_origin);
		mesh.TexCoord(0, 0, 0);
		mesh.AdvanceVertex();
		mesh.Position(self:GetUp() * 190);
		mesh.TexCoord(0, 0, height);
		mesh.AdvanceVertex();
		mesh.Position(vertex + self:GetUp() * 190);
		mesh.TexCoord(0, frac, height);
		mesh.AdvanceVertex();
		mesh.Position(vertex);
		mesh.TexCoord(0, frac, 0);
		mesh.AdvanceVertex();
		mesh.End();
		
		end;
end;