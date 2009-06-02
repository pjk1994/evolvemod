/*-------------------------------------------------------------------------------------------------------------------------
	Player stats
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Player Stats"
PLUGIN.Description = "Keeps track of player stats"
PLUGIN.Author = "Overv"
Evolve.Stats = {}

// Load statistics
function PLUGIN:LoadStats( )
	if file.Exists( "Evolve/playerstats.txt" ) then
		local str = file.Read( "Evolve/playerstats.txt" )
		Evolve.Stats = glon.decode( str )
	end
end
PLUGIN:LoadStats( )

// Save statistics to a file
function PLUGIN:SaveStats( )
	local str = glon.encode( Evolve.Stats )
	file.Write( "Evolve/playerstats.txt", str )
end

function PLUGIN:FindStats( unid )
	for i, v in pairs( Evolve.Stats ) do
		if v.UniqueID == unid then return i end
	end
end

// Welcome players
function PLUGIN:PlayerSpawn( ply )
	if !ply.EV_PlayerWelcomed then
		ply.EV_PlayerWelcomed = true
		
		// Show statistics when available
		local statid = self:FindStats( ply:UniqueID() )
		
		if statid then
			Evolve:Notify( ply:Nick() .. " last joined as " .. Evolve.Stats[statid].Nick .. " at " .. Evolve.Stats[statid].JoinDate .. "." )
			
			Evolve.Stats[statid].Nick = ply:Nick()
			Evolve.Stats[statid].JoinDate = os.date()
		else
			Evolve:Notify( ply:Nick() .. " has joined for the first time." )
			
			local stats = {}
			stats.UniqueID = ply:UniqueID()
			stats.Nick = ply:Nick()
			stats.JoinDate = os.date()
			stats.UserGroup = "Guest"
			
			table.insert( Evolve.Stats, stats )
		end
		
		self:SaveStats( )
	end
end

Evolve:RegisterPlugin( PLUGIN )