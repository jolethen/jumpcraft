-- jumpcraft/controls.lua

jumpcraft.show_controls = function(playername)
    minetest.show_formspec(playername, "jumpcraft:controls", [[
        formspec_version[4]
        size[6,6]

        button[2,0;2,1;fwd;Forward]
        button[0,1;2,1;left;Left]
        button[4,1;2,1;right;Right]
        button[2,2;2,1;back;Back]

        button[2,3;2,1;up;Up]
        button[2,4;2,1;down;Down]

        button_exit[2,5;2,1;exit;Exit]
    ]])
end

-- Handle button presses
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "jumpcraft:controls" then return false end
    if not player then return false end

    local name = player:get_player_name()
    local pdata = jumpcraft.active_pilots[name]
    if not pdata or not pdata.helm_pos then return false end

    local dir = vector.new(0, 0, 0)

    if fields.fwd then dir.z = 1 end
    if fields.back then dir.z = -1 end
    if fields.left then dir.x = -1 end
    if fields.right then dir.x = 1 end
    if fields.up then dir.y = 1 end
    if fields.down then dir.y = -1 end

    if vector.equals(dir, vector.zero()) then return true end

    -- SAFETY: round vector
    dir = vector.round(dir)

    -- Safe jumpdrive call
    pcall(function()
        jumpdrive.jump(pdata.helm_pos, dir)
    end)

    return true
end)
