/*-------------------------------------------------------------------------------------------------------------------------
	Explode a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Explode"
PLUGIN.Description = "Explode a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "explode"
PLUGIN.Usage = "[players]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local victims = evolve:FindPlayer( args, ply )
		if ( #victims > 0 and !victims[1]:IsValid() ) then victims = { } end
		
		for _, victim in pairs( victims ) do
			local explosive = ents.Create( "env_explosion" )
			explosive:SetPos( victim:GetPos() )
			explosive:SetOwner( victim )
			explosive:Spawn()
			explosive:SetKeyValue( "iMagnitude", "1" )
			explosive:Fire( "Explode", 0, 0 )
			explosive:EmitSound( "ambient/explosions/explode_4.wav", 500, 500 )
			
			victim:SetVelocity( Vector( 0, 0, 400 ) )
			victim:Kill()
		end
		
		if ( #victims > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has exploded ", evolve.colors.red, evolve:CreatePlayerList( victims ), evolve.colors.white, "." )
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "explode", unpack( players ) )
	else
		return "Explode", evolve.category.punishment
	end
end

evolve:RegisterPlugin( PLUGIN )