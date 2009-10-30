/*-------------------------------------------------------------------------------------------------------------------------
	Logs tab
-------------------------------------------------------------------------------------------------------------------------*/

local TAB = {}
TAB.Title = "Logs"
TAB.Description = "Browse through the server logs."
TAB.Author = "Overv"

function TAB:Initialize()
	self.Container = vgui.Create( "DPanel", evolve.menuContainer )
	self.Container:SetSize( evolve.menuw - 10, evolve.menuh )
	self.Container.Paint = function() end
	evolve.menuContainer:AddSheet( self.Title, self.Container, "gui/silkicons/magnifier", false, false, self.Description )
	
	self.LogChoice = vgui.Create( "DMultiChoice", self.Container )
	self.LogChoice:SetSize( self.Container:GetWide(), 20 )
	self.LogChoice:SetEditable( false )
	self.LogChoice:AddChoice( "All recent events" )
	self.LogChoice:AddChoice( "Join/Leave events" )
	self.LogChoice:AddChoice( "Server events" )
	self.LogChoice:AddChoice( "Evolve events" )
	self.LogChoice:AddChoice( "Sandbox events" )
	self.LogChoice:AddChoice( "Graph overview" )
	self.LogChoice:ChooseOptionID( 1 )
	
	self.LogContainer = vgui.Create( "DPanelList", self.Container )
	self.LogContainer:SetPos( 0, 25 )
	self.LogContainer:SetSize( self.Container:GetWide(), self.Container:GetTall() - 58 )
	self.LogContainer:SetPadding( 5 )
	self.LogContainer:SetSpacing( 5 )
	self.LogContainer:EnableVerticalScrollbar( true )
	
	self.Items = {}
	for i = 1, 50 do
		self.Items[i] = vgui.Create( "LogItem" )
		self.Items[i]:SetIcon( surface.GetTextureID( "gui/silkicons/user" ) )
		self.Items[i]:SetText( "garry :D ( 238.143.71.23 | STEAM_0:1:11956651 ) joined the game." )
		self.LogContainer:AddItem( self.Items[i] )
	end
end

function TAB:Update()
	
end

evolve:RegisterMenuTab( TAB )