-- --- T2-COPYRIGHT-NOTE-BEGIN ---
-- This copyright note is auto-generated by ./scripts/Create-CopyPatch.
-- 
-- T2 SDE: internal.lua
-- Copyright (C) 2006 The T2 SDE Project
-- 
-- More information can be found in the files COPYING and README.
-- 
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; version 2 of the License. A copy of the
-- GNU General Public License can be found in the file COPYING.
-- --- T2-COPYRIGHT-NOTE-END ---

function plus(a,b)
   total=bash.getVariable("total")
   if total == nil then total=0 end
   prod=a*b
   total=total+prod
   print(a.." * "..b.." = "..prod)
   bash.setVariable("total", total)
   return result
end

function callbash()
   bash.call("some_bashy_function", "trash", "test", "a", "is", "this")
end

bash.register("plus")
bash.register("callbash")
