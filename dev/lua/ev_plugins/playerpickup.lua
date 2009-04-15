/*-------------------------------------------------------------------------------------------------------------------------
	Picking up players
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Player Pickup"
PLUGIN.Description = "Players can pick up other players with a lower rank"
PLUGIN.Author = "Overv"

function PLUGIN:PhysgunPickup( ply, ent )
	if ent:IsPlayer() and ply:IsAdmin() and !Evolve:SameOrBetter( ply, ent ) then
		ent:SetNWBool( "Physgunned", true )
		return true
	end
end

function PLUGIN:PhysgunDrop( ply, ent )
	if ent:IsPlayer() and ply:IsAdmin() and !Evolve:SameOrBetter( ply, ent ) then
		timer.Simple( 0.5, function() ent:SetNWBool( "Physgunned", false ) end )
		return true
	end
end

function PLUGIN:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo ) 
	if ent:IsPlayer() and ent:GetNWBool( "Physgunned", false ) and dmginfo:IsFallDamage() then
		dmginfo:ScaleDamage( 0 )
	end
end

Evolve:RegisterPlugin( PLUGIN )