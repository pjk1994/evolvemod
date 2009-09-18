/*-------------------------------------------------------------------------------------------------------------------------
	Enable noclip for someone
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Noclip"
PLUGIN.Description = "Enable noclip for a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "noclip"
PLUGIN.Usage = "[players] [1/0]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local pls = evolve:findPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid() ) then pls = { } end
		local enabled = true
		if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
		
		for _, pl in pairs( pls ) do
			if ( enabled ) then pl:SetMoveType( MOVETYPE_NOCLIP ) else pl:SetMoveType( MOVETYPE_WALK ) end
		end
		
		if ( #pls > 0 ) then
			if ( enabled ) then
				evolve:notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has noclipped ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			else
				evolve:notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has un-noclipped ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			end
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
		RunConsoleCommand( "ev", "noclip", unpack( players ) )
	else
		return "Noclip", evolve.category.actions, { { "Enable", 1 }, { "Disable", 0 } }
	end
end

evolve:registerPlugin( PLUGIN )