/*-------------------------------------------------------------------------------------------------------------------------
	Set the frags of a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Frags"
PLUGIN.Description = "Set the frags of a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "frags"
PLUGIN.Usage = "<players> [frags]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local frags = 0
		if ( tonumber( args[ #args ] ) ) then frags = tonumber( args[ #args ] ) end
		
		for _, pl in pairs( pls ) do
			pl:SetFrags( frags )
		end
		
		if ( #pls > 0 ) then
			evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has set the frags of ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, " to " .. frags .. "." )
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "frags", unpack( players ) )
	else
		args = { }
		for i = 0, 20 do
			args[i+1] = { i }
		end
		return "Frags", evolve.category.actions, args
	end
end

evolve:registerPlugin( PLUGIN )