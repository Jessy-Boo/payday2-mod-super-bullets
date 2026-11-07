# payday2-mod-super-bullets

Every weapon hits 4000x harder and every bullet goes through everything. The mod.txt calls this "Ballistic Consistency" — standardizing bullet penetration profiles across all weapon categories, for consistency. Sure.

## what it actually does

Read the code so you do not have to take the description's word for it:

- bullet damage is multiplied by 4000 before the game applies it (only when you are the shooter — NPC bullets are left alone)
- every bullet is flagged armor piercing, so armor does not save anyone
- bullets punch through walls, shields, and other enemies standing in the way. the raycast wall thickness check is set to 999999, cause apparently the game asks "how thick is too thick" and this mod answers

## install

1. install [SuperBLT](https://superblt.znix.xyz) first
2. drop the `Super Bullets` folder into your Payday 2 `mods` directory
3. done. no options, no keybinds, no config file. it is just on now

## warnings

- this is a cheat mod. it is not subtle. do not bring it to lobbies with people who did not sign up for it
- single file, hooks `RaycastWeaponBase` and `CopDamage`, depends on nothing but SuperBLT — no shared framework, no settings menu
- written against the game as of mid-2026 and not re-tested against later updates. if a game patch renames those functions, it breaks quietly

## files

- `Super Bullets/main.lua` — all of it
- `Super Bullets/mod.txt` — SuperBLT hook manifest
