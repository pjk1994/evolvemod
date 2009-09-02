/*-------------------------------------------------------------------------------------------------------------------------
	Display a notification at the top
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Notice"
PLUGIN.Description = "Pops up a notification for everyone."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "notice"
PLUGIN.Usage = "<message> [time=10]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local time = 10
		if ( tonumber( args[ #args ] ) ) then
			time = math.Clamp( tonumber( args[ #args ] ), 1, 120 )
			args[ #args ] = nil
		end
		local msg = table.concat( args, " " )
		
		if ( #msg > 0 ) then
			umsg.Start( "EV_Notify" )
				umsg.Short( time )
				umsg.String( msg )
			umsg.End( )
			
			for _, pl in pairs( player.GetAll( ) ) do
				if ( pl:EV_IsAdmin( ) ) then evolve:notify( pl, evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has added a notice." ) end
			end
			evolve:notify( evolve.colors.red, msg )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

if ( CLIENT ) then
	usermessage.Hook( "EV_Notify", function( um )
		local time = um:ReadShort( )
		local msg = um:ReadString( )
		
		GAMEMODE:AddNotify( msg, NOTIFY_GENERIC, time )
		surface.PlaySound( "ambient/water/drip" .. math.random( 1, 4 ) .. ".wav" )
	end )
end

evolve:registerPlugin( PLUGIN )