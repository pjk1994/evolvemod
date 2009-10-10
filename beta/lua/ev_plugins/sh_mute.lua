/*-------------------------------------------------------------------------------------------------------------------------
	Mute a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Mute"
PLUGIN.Description = "Mute a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "mute"
PLUGIN.Usage = "[players] [1/0]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local pls = evolve:FindPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid() ) then pls = { } end
		local enabled = true
		if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
		
		for _, pl in pairs( pls ) do
			pl.EV_Muted = enabled
		end
		
		if ( #pls > 0 ) then
			if ( enabled ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has muted ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has unmuted ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:PlayerCanHearPlayersVoice( ply1, ply2 )
	if ( ply1.EV_Muted or ply2.EV_Muted ) then return false end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "mute", unpack( players ) )
	else
		return "Mute", evolve.category.punishment, { { "Enable", 1 }, { "Disable", 0 } }
	end
end

evolve:RegisterPlugin( PLUGIN )