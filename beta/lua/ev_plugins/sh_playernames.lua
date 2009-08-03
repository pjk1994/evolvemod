/*-------------------------------------------------------------------------------------------------------------------------
	Display player names above heads
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Player Names"
PLUGIN.Description = "Displays player names above heads."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil

if ( SERVER ) then
	resource.AddFile( "materials/gui/silkicons/comment.vtf" )
	resource.AddFile( "materials/gui/silkicons/comment.vmt" )
	
	concommand.Add( "EV_SetChatState", function( ply, cmd, args )
		if ( tonumber( args[1] ) ) then
			ply:SetNWBool( "EV_Chatting", tonumber( args[1] ) > 0 )
		end
	end )
else
	PLUGIN.iconUser = surface.GetTextureID( "gui/silkicons/user" )
	PLUGIN.iconChat = surface.GetTextureID( "gui/silkicons/comment" )

	function PLUGIN:HUDPaint( )
		for _, pl in pairs( player.GetAll( ) ) do
			if ( pl != LocalPlayer( ) ) then
				local td = { }
				td.start = LocalPlayer( ):GetShootPos( )
				td.endpos = pl:GetShootPos( )
				local trace = util.TraceLine( td )
				
				if ( !trace.HitWorld ) then
					surface.SetFont( "ScoreboardText" )
					local w = surface.GetTextSize( pl:Nick() ) + 8 + 20
					local h = 24
					
					local drawPos = pl:GetBonePosition( pl:LookupBone( "ValveBiped.Bip01_Head1" ) ):ToScreen( )
					local distance = LocalPlayer( ):GetShootPos( ):Distance( pl:GetShootPos( ) )
					drawPos.y = drawPos.y - 50
					drawPos.y = drawPos.y + 100 * distance / 4096
					drawPos.x = drawPos.x - w / 2
					drawPos.y = drawPos.y - h / 2
					
					local alpha = 128
					if ( distance > 512 ) then
						alpha = 128 - math.Clamp( ( distance - 512 ) / ( 2048 - 512 ) * 128, 0, 128 )
					end
					
					surface.SetDrawColor( 0, 0, 0, alpha )
					surface.DrawRect( drawPos.x, drawPos.y, w, h )
					
					surface.SetDrawColor( 255, 255, 255, alpha )
					if ( pl:GetNWBool( "EV_Chatting", false ) ) then surface.SetTexture( self.iconChat ) else surface.SetTexture( self.iconUser ) end
					surface.DrawTexturedRect( drawPos.x + 4, drawPos.y + 4, 16, 16 )
					
					local teamColor = team.GetColor( pl:Team( ) )
					draw.DrawText( pl:Nick( ), "ScoreboardText", drawPos.x + 24, drawPos.y + 4, Color( teamColor.r, teamColor.g, teamColor.b, alpha ), 0 )
				end
				
			end
		end
	end

	function PLUGIN:StartChat( )
		RunConsoleCommand( "EV_SetChatState", 1 )
	end
	function PLUGIN:FinishChat( )
		RunConsoleCommand( "EV_SetChatState", 0 )
	end
end

evolve:registerPlugin( PLUGIN )