ix.medical = ix.medical || {};

ix.medical.list = ix.medical.list || {}
ix.medical.instances = ix.medical.instances || {}

function ix.medical.CreateInstance(id, data)
	if !ix.medical.instances[ id ] then
		ix.medical.instances[ id ] = data
	end;
end;