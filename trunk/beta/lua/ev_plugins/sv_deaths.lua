/*-------------------------------------------------------------------------------------------------------------------------
	Set the deaths of a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Deaths"
PLUGIN.Description = "Set the deaths of a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "deaths"
PLUGIN.Usage = "<players> [deaths]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local deaths = 0
		if ( tonumber( args[ #args ] ) ) then deaths = tonumber( args[ #args ] ) end
		
		for _, pl in pairs( pls ) do
			pl:SetDeaths( deaths )
		end
		
		if ( #pls > 0 ) then
			evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has set the deaths of ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, " to " .. deaths .. "." )
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )