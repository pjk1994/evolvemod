/*-------------------------------------------------------------------------------------------------------------------------
	Makes clients try to reconnect after a server crash
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Crash Reconnect"
PLUGIN.Description = "Makes clients try to reconnect after a server crash."
PLUGIN.Author = "Overv"
PLUGIN.NextPing = CurTime()
PLUGIN.LastPing = CurTime() + 5

if ( SERVER ) then
	function PLUGIN:Think()
		if ( CurTime() > self.NextPing ) then
			for _, v in pairs( player.GetAll() ) do
				v:ConCommand( "EV_Ping" )
			end
			
			self.NextPing = CurTime() + 2
		end
	end
elseif ( CLIENT ) then
	concommand.Add( "EV_Ping", function()
		PLUGIN.LastPing = CurTime()
	end )
	
	function PLUGIN:InitPostEntity()
		surface.CreateFont( "Tahoma", 40, 400, true, false, "HeadFont" )
		surface.CreateFont( "Tahoma", 20, 400, true, false, "SmallFont" )
		
		self.ReconnectTime = CurTime() + 30
	end
	
	function PLUGIN:HUDPaint()
		if ( CurTime() > self.LastPing + 5 and evolve.installed ) then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawRect( 0, 0, ScrW(), ScrH() )
			
			draw.SimpleText( "Oops, it seems the server has crashed!", "HeadFont", ScrW() / 2, ScrH() / 2, Color( 127, 127, 127, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Reconnecting in " .. math.Round( self.ReconnectTime - CurTime() ) .. " seconds...", "SmallFont", ScrW() / 2, ScrH() / 2 + 25, Color( 127, 127, 127, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			if ( CurTime() > self.ReconnectTime ) then
				RunConsoleCommand( "retry" )
			end
		else
			self.ReconnectTime = CurTime() + 30
		end
	end
end

evolve:registerPlugin( PLUGIN )