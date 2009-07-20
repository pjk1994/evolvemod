/*-------------------------------------------------------------------------------------------------------------------------
	Ghost a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Ghost"
PLUGIN.Description = "Ghost a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "ghost"
PLUGIN.Usage = "[players] [1/0]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( evolve:filterNumber( args ), ply )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local enabled = true
		if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
		
		for _, pl in pairs( pls ) do
			if ( enabled ) then
				pl:SetRenderMode( RENDERMODE_NONE )
				pl:SetColor( 255, 255, 255, 0 )
				pl:SetCollisionGroup( COLLISION_GROUP_WEAPON )
				
				for _, w in pairs( pl:GetWeapons( ) ) do
					w:SetRenderMode( RENDERMODE_NONE )
					w:SetColor( 255, 255, 255, 0 )
				end
			else
				pl:SetRenderMode( RENDERMODE_NORMAL )
				pl:SetColor( 255, 255, 255, 255 )
				pl:SetCollisionGroup( COLLISION_GROUP_PLAYER )
				
				for _, w in pairs( pl:GetWeapons( ) ) do
					w:SetRenderMode( RENDERMODE_NORMAL )
					w:SetColor( 255, 255, 255, 255 )
				end
			end
			
			pl.EV_Ghosted = enabled
		end
		
		if ( #pls > 0 ) then
			if ( enabled ) then
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has ghosted ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			else
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has unghosted ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			end
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:PlayerSpawn( ply )
	if ( ply.EV_Ghosted ) then
		ply:SetRenderMode( RENDERMODE_NONE )
		ply:SetColor( 255, 255, 255, 0 )
		ply:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
		for _, w in pairs( ply:GetWeapons( ) ) do
			w:SetRenderMode( RENDERMODE_NONE )
			w:SetColor( 255, 255, 255, 0 )
		end
	end
end

function PLUGIN:PlayerCanPickupWeapon( ply, wep )
	if ( ply.EV_Ghosted ) then
		wep:SetRenderMode( RENDERMODE_NONE )
		wep:SetColor( 255, 255, 255, 0 )
	end
end

evolve:registerPlugin( PLUGIN )