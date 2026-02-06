-- jumpcraft/helm.lua

minetest.register_node("jumpcraft:helm", {
    description = "Craft Helm",
    tiles = {"default_steel_block.png"},
    groups = {cracky = 1, level = 2},

    on_rightclick = function(pos, node, player)
        if not player or not player:is_player() then return end

        local name = player:get_player_name()
        jumpcraft.active_pilots[name] = {
            helm_pos = vector.new(pos)
        }

        minetest.chat_send_player(name, "You are now piloting the craft.")
    end,

    on_destruct = function(pos)
        for name, data in pairs(jumpcraft.active_pilots or {}) do
            if vector.equals(data.helm_pos, pos) then
                jumpcraft.active_pilots[name] = nil
            end
        end
    end,
})
