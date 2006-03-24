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

local _NAME        = "dummy"
local _DESCRIPTION = "Template module (no functionality)"
local _USAGE       = [[dummy

Used as template file for new SAM modules. This module has not function
otherwise.
]]

-- CLI -----------------------------------------------------------------------
require "sam.cli"

local function CLI_exit(self, ...)
	self:send("[INFO] exiting")
	self:finish()
end

local CLI = sam.cli({ 
	exit  = CLI_exit,
})

-- MAIN-----------------------------------------------------------------------

local function main(...)
	sam.info(_NAME, "main() in module %s\n", _NAME)

	sam.dbg(_NAME, "Arguments (%d):\n", #arg)
	for i=1,#arg do 
		sam.dbg(_NAME, "   %s\n", arg[i])
	end

	sam.dbg(_NAME, "Starting CLI:\n")
	CLI()
end

-- SAM MODULE INIT ---------------------------------------------------------
return { 
	_NAME = _NAME,
	_DESCRIPTION = _DESCRIPTION,
	_USAGE = _USAGE,
	
	main = main, 
}

