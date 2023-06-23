resource.AddSingleFile( "resource/fonts/Comfortaa.ttf" )

function PLUGIN:SaveData()
	local data = {}

	for k, v in ipairs(ents.FindByClass("farming_pot")) do
		data[#data + 1] = {
			pos = v:GetPos(), 
			angles = v:GetAngles(), 
			model = v:GetModel(),
			info = v.info,
			grown = v:getNetVar('grown'),
			uid = v._id
		}
	end

	self:setData(data)
end

function PLUGIN:LoadData()
	local data = self:getData()

	if (data) then
		for k, v in ipairs(data) do
			local pot = ents.Create("farming_pot")
			pot:SetPos(v["pos"])
			pot:SetAngles(v["angles"])
			pot:SetModel(v["model"])
			pot.info = v.info
			pot._id = v.uid
			pot:Spawn()
			pot:setNetVar("grown", v.grown)
			pot:Activate()
		end
	end;
end
