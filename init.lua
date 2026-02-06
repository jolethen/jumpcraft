-- jumpcraft/init.lua
jumpcraft = {}

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath .. "/helm.lua")
dofile(modpath .. "/movement.lua")

minetest.log("action", "[jumpcraft] Loaded successfully")
