AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( )
include( "shared.lua" )

function ENT:Initialize( )
    self:SetModel( "models/rottweiler/batarang_thrown.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
    util.PrecacheSound( "physics/metal/sawblade_stick3.wav" )
    util.PrecacheSound( "physics/metal/sawblade_stick2.wav" )
    util.PrecacheSound( "physics/metal/sawblade_stick1.wav" )
    util.PrecacheSound( "weapons/batarang/hit1.wav" )
    util.PrecacheSound( "weapons/batarang/hit2.wav" )
    util.PrecacheSound( "weapons/batarang/hit3.wav" )

    self.Hit = { Sound( "physics/metal/sawblade_stick1.wav" ) , Sound( "physics/metal/sawblade_stick2.wav" ) , Sound( "physics/metal/sawblade_stick3.wav" ) }

    self.FleshHit = { Sound( "weapons/batarang/hit1.wav" ) , Sound( "weapons/batarang/hit2.wav" ) , Sound( "weapons/batarang/hit3.wav" ) }

    self:GetPhysicsObject( ):SetMass( 2 )
end

function ENT:Think( )
    self.lifetime = self.lifetime || CurTime( ) + 20

    if CurTime( ) > self.lifetime then
        self:Remove( )
    end
end

function ENT:Disable( )
    self.PhysicsCollide = function( ) end
    self.lifetime = CurTime( ) + 30
end