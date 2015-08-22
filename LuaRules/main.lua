-- Wiki: http://springrts.com/wiki/Gamedev:Glossary#springcontent.sdz

-- Include base content gadget handler to run synced gadgets

Spring.Utilities = Spring.Utilities or {}

local SCRIPT_DIR = Script.GetName() .. '/'
local utilFiles = VFS.DirList(SCRIPT_DIR .. 'Utilities/', "*.lua")

for i = 1, #utilFiles do
	Spring.Echo("Loading Utility", utilFiles[i])
	VFS.Include(utilFiles[i])
end

VFS.Include("luagadgets/gadgets.lua",nil, VFS.BASE)