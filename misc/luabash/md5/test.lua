#!/usr/bin/env lua

-- --- T2-COPYRIGHT-NOTE-BEGIN ---
-- This copyright note is auto-generated by ./scripts/Create-CopyPatch.
-- 
-- T2 SDE: misc/luabash/md5/test.lua
-- Copyright (C) 2006 The T2 SDE Project
-- 
-- More information can be found in the files COPYING and README.
-- 
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; version 2 of the License. A copy of the
-- GNU General Public License can be found in the file COPYING.
-- --- T2-COPYRIGHT-NOTE-END ---

require"md5"

-- test some known sums
assert(md5.sum("") == "d41d8cd98f00b204e9800998ecf8427e")
assert(md5.sum("a") == "0cc175b9c0f1b6a831c399e269772661")
assert(md5.sum("abc") == "900150983cd24fb0d6963f7d28e17f72")
assert(md5.sum("message digest") == "f96b697d7cb7938d525a2f31aaf161d0")
assert(md5.sum("abcdefghijklmnopqrstuvwxyz") == "c3fcd3d76192e4007dfb496cca67e13b")
assert(md5.sum("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
 == "d174ab98d277d9f5a5611c2c9f419d9f")


-- test padding borders
assert(md5.sum(string.rep('a',53)) == "e9e7e260dce84ffa6e0e7eb5fd9d37fc")
assert(md5.sum(string.rep('a',54)) == "eced9e0b81ef2bba605cbc5e2e76a1d0")
assert(md5.sum(string.rep('a',55)) == "ef1772b6dff9a122358552954ad0df65")
assert(md5.sum(string.rep('a',56)) == "3b0c8ac703f828b04c6c197006d17218")
assert(md5.sum(string.rep('a',57)) == "652b906d60af96844ebd21b674f35e93")
assert(md5.sum(string.rep('a',63)) == "b06521f39153d618550606be297466d5")
assert(md5.sum(string.rep('a',64)) == "014842d480b571495a4a0363793f7367")
assert(md5.sum(string.rep('a',65)) == "c743a45e0d2e6a95cb859adae0248435")
assert(md5.sum(string.rep('a',255)) == "46bc249a5a8fc5d622cf12c42c463ae0")
assert(md5.sum(string.rep('a',256)) == "81109eec5aa1a284fb5327b10e9c16b9")

assert(md5.sum(
"12345678901234567890123456789012345678901234567890123456789012345678901234567890")
   == "57edf4a22be3c955ac49da2e2107b67a")


print"OK"

-- our t2 use case
-- cut -d ' ' -f 2 /var/adm/flists/gtk+ | grep -v '^var/adm/' | sed -e 's,^.*,/"\0",' | xargs -r /usr/embutils/md5sum

local f = io.open ("/var/adm/flists/gtk+", "r")

for line in f:lines() do
   local sum, file = string.match (line, "(%S*)%s(.*)")
   --print (sum .. ": " ..file)

   local f2 = io.open ("/"..file)
   print (md5.sum(f2) .. "  " .. "/"..file)

   f2:close()
end
f:close()
