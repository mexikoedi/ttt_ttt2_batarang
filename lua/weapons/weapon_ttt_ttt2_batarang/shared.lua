if engine.ActiveGamemode() ~= "terrortown" then return end

if SERVER then
    AddCSLuaFile("shared.lua")
    SWEP.HoldType = "melee"
end

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_ROLE
SWEP.Slot = 6
SWEP.SlotPos = 2
SWEP.AmmoEnt = nil
SWEP.Icon = "vgui/entities/weapon_batarang"

if SERVER then
    resource.AddFile("materials/batarang/deathicon.vmt")
    resource.AddFile("materials/models/rottweiler/batarang.vmt")
    resource.AddFile("materials/vgui/entities/weapon_batarang.vmt")
end

SWEP.CanBuy = {ROLE_DETECTIVE}

SWEP.InLoadoutFor = nil
SWEP.LimitedStock = true

SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "Batarang",
    desc = "Throw Batarangs at your enemies like Batman."
}

SWEP.AllowDrop = false
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.AutoSpawnable = false

if CLIENT then
    SWEP.ViewModelFOV = 86
    SWEP.IconLetter = "x"
    killicon.Add("batarang", "batarang/deathicon", Color(180, 0, 0, 255))
    killicon.AddAlias("weapon_ttt_ttt2_batarang", "batarang")
    killicon.AddAlias("ent_ttt_ttt2_batarang", "batarang")
end

SWEP.PrintName = "Batarang"
SWEP.Author = "mexikoedi"
SWEP.Contact = "Steam"
SWEP.Instructions = "Left click throws a batarang."
SWEP.Purpose = "Throw batarangs."
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.AdminSpawnable = false
SWEP.UseHands = true
SWEP.ViewModel = "models/rottweiler/v_batarang.mdl"
SWEP.WorldModel = "models/rottweiler/w_batarang.mdl"
SWEP.Primary.Delay = 0.9
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Damage = 500
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 3
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

if CLIENT then
    function SWEP:GetViewModelPosition(pos, ang)
        pos = pos + ang:Forward() * 4

        return pos, ang
    end
end

function SWEP:Think()
end

function SWEP:Initialize()
    util.PrecacheSound("weapons/batarang/throw1.wav")
    util.PrecacheSound("weapons/batarang/throw2.wav")
    util.PrecacheSound("weapons/batarang/throw3.wav")
    util.PrecacheSound("weapons/batarang/throw4.wav")
end

function SWEP:PrimaryAttack()
    local dmg = DamageInfo()
    dmg:SetAttacker(self:GetOwner())
    dmg:SetInflictor(self)
    self:EmitSound("weapons/batarang/throw" .. tostring(math.random(1, 4)) .. ".wav")
    self:ShootBullet(500, 1, 0.01)
    self:TakePrimaryAmmo(1)
    self:GetOwner():ViewPunch(Angle(-1, 0, 0))
    self:SetNextPrimaryFire(CurTime() + 0.8)
    self:SetNextSecondaryFire(CurTime() + 0.8)
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

    if SERVER then
        local batarang = ents.Create("ent_ttt_ttt2_batarang")
        batarang:SetAngles(self:GetOwner():EyeAngles())
        batarang:SetPos(self:GetOwner():GetShootPos())
        batarang:SetOwner(self:GetOwner())
        batarang:SetPhysicsAttacker(self:GetOwner())
        batarang:Spawn()
        batarang:Activate()
        local phys = batarang:GetPhysicsObject()
        phys:SetVelocity(self:GetOwner():GetAimVector() * 7000)
        phys:AddAngleVelocity(Vector(0, 0, 90))

        if self:Clip1() == 0 then
            self:Remove()
        end
    end
end