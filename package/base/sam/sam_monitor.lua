-- --- T2-COPYRIGHT-NOTE-BEGIN ---
-- This copyright note is auto-generated by ./scripts/Create-CopyPatch.
-- 
-- T2 SDE: package/.../sam/sam_config.lua
-- Copyright (C) 2006 The T2 SDE Project
-- 
-- More information can be found in the files COPYING and README.
-- 
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; version 2 of the License. A copy of the
-- GNU General Public License can be found in the file COPYING.
-- --- T2-COPYRIGHT-NOTE-END ---

local _NAME        = "monitor"
local _DESCRIPTION = "Monitor the build process of a given config."
local _USAGE       = [[monitor <config-name>

This will show the build log of the respective configuration.
]]

require "sam.config"

local function main(...)
	sam.info(_NAME, "main() in module %s\n", _NAME)
	local t2dir = os.getenv("T2DIR") or "."

	if not arg[1] then
		sam.error(_NAME, "missing config name")
		return
	end

	local cfg = sam.config(arg[1])
	local log = t2dir .. "/build/" .. cfg.ID .. "/TOOLCHAIN/logs/build_target.log"

	os.execute("tail -f " .. log)
end

-- SAM MODULE INIT ---------------------------------------------------------
return { 
	_NAME = _NAME,
	_DESCRIPTION = _DESCRIPTION,
	_USAGE = _USAGE,
	
	main = main, 
}
