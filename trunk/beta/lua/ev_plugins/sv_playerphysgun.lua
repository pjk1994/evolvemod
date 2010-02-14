/*-------------------------------------------------------------------------------------------------------------------------
	Physgun players
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Physgun Players"
PLUGIN.Description = "Physgun a player."
PLUGIN.Author = "Overv"
PLUGIN.Privileges = { "Physgun players" }

function PLUGIN:PhysgunPickup( ply, pl )
	if ( ply:EV_HasPrivilege( "Physgun players" ) and pl:IsPlayer() ) then
		pl.EV_PickedUp = true
		return true
	end
end

function PLUGIN:PhysgunDrop( ply, pl )
	if ( ply:EV_HasPrivilege( "Physgun players" ) and pl:IsPlayer() ) then
		pl.EV_PickedUp = false
		return true
	end
end

function PLUGIN:EntityTakeDamage( ent, inflictor, attacker, dmg, dmginfo )
	if ent.EV_PickedUp and dmginfo:IsFallDamage() then
		dmginfo:ScaleDamage( 0 )
	end
end

evolve:RegisterPlugin( PLUGIN )