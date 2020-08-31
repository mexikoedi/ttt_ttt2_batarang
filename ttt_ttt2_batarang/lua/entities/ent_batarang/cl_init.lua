if engine.ActiveGamemode( ) != "terrortown" then return end
include( 'shared.lua' )

function ENT:Initialize( )
end

function ENT:Think( )
end

function ENT:Draw( )
    self:DrawModel( )
end
