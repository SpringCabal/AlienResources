local base = piece ("Cube");

local flags = SFX.FIRE+SFX.SMOKE+SFX.NO_HEATCLOUD+SFX.EXPLODE_ON_HIT;

local shatterBlockNames = {
	'Cube_cell';
	'Cube_cell_001';
	'Cube_cell_002';
	'Cube_cell_004';
	'Cube_cell_005';
	'Cube_cell_006';
	'Cube_cell_007';
	'Cube_cell_008';
	'Cube_cell_009';
}

local shatterBlocks = {};
local pieceMap = {}

function script.Create()
	pieceMap = Spring.GetUnitPieceMap(unitID);
	
	for i=1,#shatterBlockNames do
		if(pieceMap[shatterBlockNames[i]]) then
			table.insert(shatterBlocks, piece(shatterBlockNames[i]));
		end
	end
	
	for i=1,#shatterBlocks do
		if(shatterBlocks[i]) then
			Hide(shatterBlocks[i]);
		end
	end
end

function script.Killed(recentDamage, maxHealth)
	if(base) then Hide(base) end
	
	for i=1,#shatterBlocks do
		if(shatterBlocks[i]) then
			Show(shatterBlocks[i]);
			EmitSfx(shatterBlocks[i],1024);
		end
	end
	
	for i=1,#shatterBlocks do
		if(shatterBlocks[i]) then
			EmitSfx(shatterBlocks[i],1024);
			Explode(shatterBlocks[i],flags);
			Sleep(math.random(400));
		end
	end
	return 0
end
