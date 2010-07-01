/*-------------------------------------------------------------------------------------------------------------------------
	Display player names above heads
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Player Names"
PLUGIN.Description = "Displays player names above heads."
PLUGIN.Author = "Overv"
PLUGIN.Privileges = { "Player names" }

if ( SERVER ) then
	resource.AddFile( "materials/gui/silkicons/comments.vtf" )
	resource.AddFile( "materials/gui/silkicons/comments.vmt" )
	resource.AddFile( "materials/gui/silkicons/user_add.vtf" )
	resource.AddFile( "materials/gui/silkicons/user_add.vmt" )
	resource.AddFile( "materials/gui/silkicons/shield_add.vtf" )
	resource.AddFile( "materials/gui/silkicons/shield_add.vmt" )
	resource.AddFile( "materials/gui/silkicons/key.vtf" )
	resource.AddFile( "materials/gui/silkicons/key.vmt" )
	
	concommand.Add( "EV_SetChatState", function( ply, cmd, args )
		if ( tonumber( args[1] ) ) then
			ply:SetNWBool( "EV_Chatting", tonumber( args[1] ) > 0 )
		end
	end )
else
	PLUGIN.iconUser = surface.GetTextureID( "gui/silkicons/user" )
	PLUGIN.iconChat = surface.GetTextureID( "gui/silkicons/comments" )

	function PLUGIN:HUDPaint()
		if ( !evolve.installed or !LocalPlayer():EV_HasPrivilege( "Player names" ) ) then return end
		
		for _, pl in ipairs( player.GetAll() ) do
			if ( pl != LocalPlayer() ) then
				local td = {}
				td.start = LocalPlayer():GetShootPos()
				td.endpos = pl:GetShootPos()
				local trace = util.TraceLine( td )
				
				if ( !trace.HitWorld ) then				
					surface.SetFont( "ScoreboardText" )
					local w = surface.GetTextSize( pl:Nick() ) + 8 + 20
					local h = 24
					
					local drawPos = pl:GetShootPos():ToScreen()
					local distance = LocalPlayer():GetShootPos():Distance( pl:GetShootPos() )
					drawPos.x = drawPos.x - w / 2
					drawPos.y = drawPos.y - h - 12
					
					local alpha = 128
					if ( distance > 512 ) then
						alpha = 128 - math.Clamp( ( distance - 512 ) / ( 2048 - 512 ) * 128, 0, 128 )
					end
					
					surface.SetDrawColor( 0, 0, 0, alpha )
					surface.DrawRect( drawPos.x, drawPos.y, w, h )
					
					if ( pl:GetNWBool( "EV_Chatting", false ) ) then
						surface.SetTexture( self.iconChat )
					else
						if ( evolve.ranks[ pl:EV_GetRank() ] ) then
							surface.SetTexture( evolve.ranks[ pl:EV_GetRank() ].IconTexture )
						else
							surface.SetTexture( self.iconUser )
						end
					end
					
					surface.SetDrawColor( 255, 255, 255, math.Clamp( alpha * 2, 0, 255 ) )
					surface.DrawTexturedRect( drawPos.x + 4, drawPos.y + 4, 16, 16 )
					
					local col = evolve.ranks[ pl:EV_GetRank() ].Color or team.GetColor( pl:Team() )
					col.a = math.Clamp( alpha * 2, 0, 255 )
					draw.DrawText( pl:Nick(), "ScoreboardText", drawPos.x + 24, drawPos.y + 4, col, 0 )
				end
			end
		end
	end

	function PLUGIN:StartChat()
		self.ChatboxOpen = true
		RunConsoleCommand( "EV_SetChatState", 1 )
	end
	
	function PLUGIN:FinishChat()
		if ( self.ChatboxOpen ) then
			RunConsoleCommand( "EV_SetChatState", 0 )
			self.ChatboxOpen = false
		end
	end
end

evolve:RegisterPlugin( PLUGIN )