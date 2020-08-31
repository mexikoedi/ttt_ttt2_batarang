if engine.ActiveGamemode( ) != "terrortown" then return end
if ( SERVER ) then
    AddCSLuaFile( "shared.lua" )
    SWEP.HoldType = "melee"
end

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_ROLE
SWEP.Slot = 6
SWEP.SlotPos = 2
SWEP.AmmoEnt = nil
SWEP.Icon = "vgui/entities/weapon_batarang"

if SERVER then
    resource.AddFile( "materials/batarang/deathicon.vmt" )
    resource.AddFile( "materials/models/rottweiler/batarang.vmt" )
    resource.AddFile( "materials/vgui/entities/weapon_batarang.vmt" )
end

SWEP.CanBuy = { ROLE_DETECTIVE }

SWEP.InLoadoutFor = nil
SWEP.LimitedStock = true

SWEP.EquipMenuData = {
    type = "Weapon" ,
    desc = "You are Batman now."
}

SWEP.AllowDrop = false
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.AutoSpawnable = false

if ( CLIENT ) then
    SWEP.PrintName = "Batarang"
    SWEP.Author = "mexikoedi"
    SWEP.ViewModelFOV = 86
    SWEP.IconLetter = "x"
    killicon.Add( "batarang" , "batarang/deathicon" , Color( 180 , 0 , 0 , 255 ) )
    killicon.AddAlias( "weapon_batarang" , "batarang" )
    killicon.AddAlias( "ent_batarang" , "batarang" )
end

//----------General Swep Info---------------
SWEP.Author = "mexikoedi"
SWEP.Contact = "n/a"
SWEP.Purpose = "Throw batarangs."
SWEP.Instructions = "Left click throws a batarang."
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true
//---------------------------------------------
//----------Models---------------------------
SWEP.ViewModel = "models/rottweiler/v_batarang.mdl"
SWEP.WorldModel = "models/rottweiler/w_batarang.mdl"
//---------------------------------------------
//-----------Primary Fire Attributes----------------------------------------
SWEP.Primary.Delay = 0.9 //In seconds
SWEP.Primary.Recoil = 0.5 //Gun Kick
SWEP.Primary.Damage = 200 //Damage per Bullet
SWEP.Primary.NumShots = 1 //Number of shots per one fire
SWEP.Primary.Cone = 0 //Bullet Spread
SWEP.Primary.ClipSize = 3 //Use "-1 if there are no clips"
SWEP.Primary.DefaultClip = 3 //Number of shots in next clip
SWEP.Primary.Automatic = true //Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo = "none" //Ammo Type

//-----------End Primary Fire Attributes------------------------------------
// function SWEP:Reload() --To do when reloading
// end 
if ( CLIENT ) then
    function SWEP:GetViewModelPosition( pos , ang )
        pos = pos + ang:Forward( ) * 4

        return pos , ang
    end
end

// Called every frame
function SWEP:Think( )
end

function SWEP:Initialize( )
    //util.PrecacheSound("physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav")
    util.PrecacheSound( "weapons/batarang/throw1.wav" )
    util.PrecacheSound( "weapons/batarang/throw2.wav" )
    util.PrecacheSound( "weapons/batarang/throw3.wav" )
    util.PrecacheSound( "weapons/batarang/throw4.wav" )
end

function SWEP:PrimaryAttack( )
    self:EmitSound( "weapons/batarang/throw" .. tostring( math.random( 1 , 4 ) ) .. ".wav" )
    self:ShootBullet( 200 , 1 , 0.01 )
    self:TakePrimaryAmmo( 1 )
    self:GetOwner( ):ViewPunch( Angle( -1 , 0 , 0 ) )
    self:SetNextPrimaryFire( CurTime( ) + 0.8 )
    self:SetNextSecondaryFire( CurTime( ) + 0.8 )
    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

    if SERVER then
        local batarang = ents.Create( "ent_batarang" )
        batarang:SetAngles( self:GetOwner( ):EyeAngles( ) ) // Angle(0,90,0))
        batarang:SetPos( self:GetOwner( ):GetShootPos( ) )
        batarang:SetOwner( self:GetOwner( ) )
        batarang:SetPhysicsAttacker( self:GetOwner( ) )
        batarang:Spawn( )
        batarang:Activate( )
        local phys = batarang:GetPhysicsObject( )
        phys:SetVelocity( self:GetOwner( ):GetAimVector( ) * 7000 )
        phys:AddAngleVelocity( Vector( 0 , 0 , 90 ) )

        if self:Clip1( ) == 0 then
            self:Remove( )
        end
    end
end
