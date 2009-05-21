/*-------------------------------------------------------------------------------------------------------------------------
	Player stats
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Player Stats"
PLUGIN.Description = "Keeps track of player stats"
PLUGIN.Author = "Overv"
PLUGIN.Stats = {}

// Load statistics
function PLUGIN:LoadStats( )
	if file.Exists( "Evolve/playerstats.txt" ) then
		local str = file.Read( "Evolve/playerstats.txt" )
		self.Stats = glon.decode( str )
	end
end
PLUGIN:LoadStats( )

// Save statistics to a file
function PLUGIN:SaveStats( )
	local str = glon.encode( self.Stats )
	file.Write( "Evolve/playerstats.txt", str )
end

function PLUGIN:FindStats( unid )
	for i, v in pairs( self.Stats ) do
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
			Evolve:Notify( ply:Nick() .. " last joined as " .. self.Stats[statid].Nick .. " at " .. self.Stats[statid].JoinDate .. "." )
			
			self.Stats[statid].Nick = ply:Nick()
			self.Stats[statid].JoinDate = os.date()
		else
			Evolve:Notify( ply:Nick() .. " has joined for the first time." )
			
			local stats = {}
			stats.UniqueID = ply:UniqueID()
			stats.Nick = ply:Nick()
			stats.JoinDate = os.date()
			
			table.insert( self.Stats, stats )
		end
		
		self:SaveStats( )
	end
end

Evolve:RegisterPlugin( PLUGIN )