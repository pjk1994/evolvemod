/*-------------------------------------------------------------------------------------------------------------------------
	Set the health of a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Health"
PLUGIN.Description = "Set the health of a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "hp"
PLUGIN.Usage = "<players> [health]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local hp = 100
		if ( tonumber( args[ #args ] ) ) then hp = tonumber( args[ #args ] ) end
		
		for _, pl in pairs( pls ) do
			pl:SetHealth( hp )
		end
		
		if ( #pls > 0 ) then
			evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has set the health of ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, " to " .. hp .. "." )
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )