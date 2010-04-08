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
		pl:SetMoveType( MOVETYPE_NOCLIP )
		return true
	end
end

function PLUGIN:PhysgunDrop( ply, pl )
	if ( pl:IsPlayer() ) then
		pl:SetMoveType( MOVETYPE_WALK )
		return true
	end
end

evolve:RegisterPlugin( PLUGIN )