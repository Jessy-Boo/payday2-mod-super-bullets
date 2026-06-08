if RequiredScript == "lib/units/weapons/raycastweaponbase" then
    Hooks:PostHook(RaycastWeaponBase, "init", "BC_Init", function(self)
        self._can_shoot_through_wall = true
        self._can_shoot_through_shield = true
        self._can_shoot_through_enemy = true
    end)

    Hooks:PostHook(RaycastWeaponBase, "setup", "BC_Setup", function(self)
        self._can_shoot_through_wall = true
        self._can_shoot_through_shield = true
        self._can_shoot_through_enemy = true
    end)

    local BC_orig_collect_hits = RaycastWeaponBase.collect_hits
    function RaycastWeaponBase.collect_hits(from, to, setup_data)
        setup_data = setup_data or {}

        setup_data.can_shoot_through_wall = true
        setup_data.can_shoot_through_shield = true
        setup_data.can_shoot_through_enemy = true

        local ignore_unit = setup_data.ignore_units or {}
        local bullet_slotmask = setup_data.bullet_slotmask or managers.slot:get_mask("bullet_impact_targets")
        local wall_mask = setup_data.wall_mask or managers.slot:get_mask("world_geometry")
        local enemy_mask = setup_data.enemy_mask
        local shield_mask = setup_data.shield_mask

        if setup_data.stop_on_impact then
            local ray_hits = {}
            local hit = World:raycast("ray", from, to, "slot_mask", bullet_slotmask, "ignore_unit", ignore_unit)
            if hit then
                table.insert(ray_hits, hit)
            end
            local hit_enemy = hit and hit.unit:in_slot(enemy_mask) or false
            return ray_hits, hit_enemy, hit_enemy and {[hit.unit:key()] = hit.unit} or nil
        end

        local ray_hits = World:raycast_wall("ray", from, to,
            "slot_mask", bullet_slotmask,
            "ignore_unit", ignore_unit,
            "thickness", 999999,
            "thickness_mask", wall_mask)

        local unique_hits = {}
        local enemies_hit = {}
        local hit_enemy = false
        local units_hit = {}
        local in_slot_func = Unit.in_slot

        for _, hit in ipairs(ray_hits) do
            local unit = hit.unit
            local u_key = unit:key()

            if not units_hit[u_key] then
                units_hit[u_key] = true
                unique_hits[#unique_hits + 1] = hit
                hit.hit_position = hit.position

                if in_slot_func(unit, enemy_mask) then
                    enemies_hit[u_key] = unit
                    hit_enemy = true
                end
            end
        end

        return unique_hits, hit_enemy, hit_enemy and enemies_hit or nil
    end
elseif RequiredScript == "lib/units/enemies/cop/copdamage" then
    Hooks:PreHook(CopDamage, "damage_bullet", "BC_ArmorPierce", function(self, attack_data)
        if attack_data and attack_data.attacker_unit then
            attack_data.armor_piercing = true
        end
    end)

    Hooks:PreHook(CopDamage, "damage_bullet", "BC_DamageMult", function(self, attack_data)
        if attack_data and attack_data.attacker_unit and attack_data.attacker_unit == managers.player:player_unit() then
            attack_data.damage = attack_data.damage * 4000
        end
    end)
end