-- jumpcraft/movement.lua

jumpcraft.active_pilots = {}

local MOVE_INTERVAL = 0.4 -- seconds
local MOVE_DISTANCE = 1  -- nodes per step

-- SAFETY: ensure jumpdrive exists
if not jumpdrive or not jumpdrive.jump then
    minetest.log("error", "[jumpcraft] Jumpdrive not found!")
    return
end

local timer = 0

minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer < MOVE_INTERVAL then return end
    timer = 0

    for playername, pdata in pairs(jumpcraft.active_pilots) do
        local player = minetest.get_player_by_name(playername)
        if not player then
            jumpcraft.active_pilots[playername] = nil
            goto continue
        end

        local ctrl = player:get_player_control()
        if not ctrl then goto continue end

        local dir = vector.new(0, 0, 0)
        local yaw = player:get_look_horizontal()

        -- Forward / backward
        if ctrl.up then
            dir.x = -math.sin(yaw) * MOVE_DISTANCE
            dir.z =  math.cos(yaw) * MOVE_DISTANCE
        elseif ctrl.down then
            dir.x =  math.sin(yaw) * MOVE_DISTANCE
            dir.z = -math.cos(yaw) * MOVE_DISTANCE
        end

        -- Vertical (aircraft / subs)
        if ctrl.jump then
            dir.y = MOVE_DISTANCE
        elseif ctrl.sneak then
            dir.y = -MOVE_DISTANCE
        end

        if vector.equals(dir, vector.zero()) then
            goto continue
        end

        -- SAFETY: jumpdrive API expects rounded ints
        dir = vector.round(dir)

        -- Call jumpdrive WITHOUT touching its data
        local success, err = pcall(function()
            jumpdrive.jump(pdata.helm_pos, dir)
        end)

        if not success then
            minetest.chat_send_player(playername,
                "Jumpdrive error: " .. tostring(err))
        end

        ::continue::
    end
end)
