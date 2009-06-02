/*-------------------------------------------------------------------------------------------------------------------------
	Player name boxes
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Player Boxes"
PLUGIN.Description = "Displays boxes with names above players"
PLUGIN.Author = "Overv"

function PLUGIN:HUDPaint( )
	for _, pl in pairs( player.GetAll( ) ) do
		if pl != LocalPlayer( ) then
			
			// First, visibility
			local td = { }
			td.start = LocalPlayer( ):GetShootPos( )
			td.endpos = pl:GetShootPos( )
			local trace = util.TraceLine( td )
			
			if !trace.HitWorld then
			
				// Calculate box size
				surface.SetFont( "ScoreboardText" )
				local w = surface.GetTextSize( pl:Nick() ) + 8
				local h = 24
				
				// Calculate draw position
				local drawPos = pl:GetBonePosition( pl:LookupBone( "ValveBiped.Bip01_Head1" ) ):ToScreen( )
				local distance = LocalPlayer( ):GetShootPos( ):Distance( pl:GetShootPos( ) )
				drawPos.y = drawPos.y - 50
				drawPos.y = drawPos.y + 100 * distance / 4096
				drawPos.x = drawPos.x - w / 2
				drawPos.y = drawPos.y - h / 2
				
				// Calculate opacity
				local alpha = 128
				if distance > 512 then
					alpha = 128 - math.Clamp( ( distance - 512 ) / ( 2048 - 512 ) * 128, 0, 128 )
				end
				
				// Draw it
				surface.SetDrawColor( 0, 0, 0, alpha )
				surface.DrawRect( drawPos.x, drawPos.y, w, h )
				
				local teamColor = team.GetColor( pl:Team() )
				draw.DrawText( pl:Nick(), "ScoreboardText", drawPos.x + 4, drawPos.y + 4, Color( teamColor.r, teamColor.g, teamColor.b, alpha ), 0 )
			end
			
		end
	end
end

Evolve:RegisterPlugin( PLUGIN )