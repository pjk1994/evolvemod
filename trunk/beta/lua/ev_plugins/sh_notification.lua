/*-------------------------------------------------------------------------------------------------------------------------
	Display a notification at the top
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Notice"
PLUGIN.Description = "Pops up a notification for everyone at the top of the screen."
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
			umsg.Start( "EV_NotificationTop" )
				umsg.Short( CurTime( ) + time )
				umsg.String( msg )
			umsg.End( )
			evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has posted a notice." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

if ( CLIENT ) then
	PLUGIN.TimeOut = 0
	PLUGIN.Message = ""
	PLUGIN.FadeEnd = 0
	PLUGIN.FadeTime = 2.0
	PLUGIN.Icon = surface.GetTextureID( "gui/silkicons/exclamation" )
	
	function PLUGIN:GetAlphaMultiplier( )
		if ( CurTime( ) > self.TimeOut + self.FadeTime ) then
			return 0.0
		else
			if ( CurTime( ) < self.TimeOut ) then
				return 1.0 - math.Clamp( ( self.FadeEnd - CurTime( ) ) * ( 1 / self.FadeTime ), 0.0, 1.0 )
			else
				return 1.0 - math.Clamp( ( CurTime( ) - self.TimeOut ) * ( 1 / self.FadeTime ), 0.0, 1.0 )
			end
		end
	end

	function PLUGIN:HUDPaint( )
		surface.SetDrawColor( 255, 255, 204, 200 * self:GetAlphaMultiplier( ) )
		surface.DrawRect( 10, 10, ScrW( ) - 20, 28 )
		surface.SetDrawColor( 136, 136, 136, 200 * self:GetAlphaMultiplier( ) )
		surface.DrawOutlinedRect( 10, 10, ScrW( ) - 20, 28 )
		
		surface.SetTexture( self.Icon )
		surface.SetDrawColor( 255, 255, 255, 255 * self:GetAlphaMultiplier( ) )
		surface.DrawTexturedRect( 16, 16, 16, 16 )
		
		draw.SimpleText( self.Message, "ScoreboardText", 40, 16, Color( 136, 136, 136, 255 * self:GetAlphaMultiplier( ) ), TEXT_ALIGN_LEFT )
	end

	usermessage.Hook( "EV_NotificationTop", function( um )
		PLUGIN.TimeOut = um:ReadShort( )
		PLUGIN.Message = um:ReadString( )
		PLUGIN.FadeEnd = CurTime( ) + PLUGIN.FadeTime
	end )
end

evolve:registerPlugin( PLUGIN )