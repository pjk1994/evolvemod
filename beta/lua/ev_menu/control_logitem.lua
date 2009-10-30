/*-------------------------------------------------------------------------------------------------------------------------
	A single log item to be added to the list
-------------------------------------------------------------------------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()
end

function PANEL:SetIcon( im )
	self.Icon = im
end

function PANEL:SetText( txt )
	self.Text = txt
end

function PANEL:SetTime( time )
	self.Time = time
end

function PANEL:PerformLayout()	
	self:SetTall( 20 )	
end

function PANEL:Paint()
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 150 ) )
	
	if ( self.Icon ) then
		surface.SetTexture( self.Icon )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 4, 4, self:GetTall() - 8, self:GetTall() - 8 )
	end
	
	draw.SimpleText( self.Text or "Label", "DefaultSmall", 24, self:GetTall() / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	
	local time
	local secondsAgo = math.floor( SysTime() - ( self.Time or 0 ) )
	if ( secondsAgo < 60 ) then
		time = secondsAgo .. " second(s) ago"
	elseif ( secondsAgo < 3600 ) then
		time = math.floor( secondsAgo / 60 ) .. " minute(s) ago"
	elseif ( secondsAgo < 86400 ) then
		time = math.floor( secondsAgo / 3600 ) .. " hour(s) ago"
	else
		time = math.floor( secondsAgo / 86400 ) .. " day(s) ago"
	end
	
	draw.SimpleText( time, "DefaultSmall", self:GetWide() - 4, self:GetTall() / 2, Color( 255, 255, 255, 128 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	
	return false
end

vgui.Register( "LogItem", PANEL, "DPanel" )