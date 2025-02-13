if engine.ActiveGamemode() ~= "terrortown" then return end
if SERVER then
    AddCSLuaFile()
    resource.AddFile("materials/models/rottweiler/batarang.vmt")
    resource.AddFile("materials/vgui/entities/weapon_batarang.vmt")
end

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_ROLE
SWEP.Slot = 6
SWEP.SlotPos = 2
SWEP.AmmoEnt = nil
SWEP.Icon = "vgui/entities/weapon_batarang"
SWEP.HoldType = "melee"
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
SWEP.ViewModelFOV = 86
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Damage = GetConVar("ttt_batarang_damage"):GetInt()
SWEP.Primary.ClipSize = GetConVar("ttt_batarang_clipSize"):GetInt()
SWEP.Primary.DefaultClip = GetConVar("ttt_batarang_ammo"):GetInt()
SWEP.Primary.Automatic = GetConVar("ttt_batarang_automaticFire"):GetBool()
SWEP.Primary.RPS = GetConVar("ttt_batarang_rps"):GetFloat()
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
    if CLIENT then return end
    self.Primary.Damage = GetConVar("ttt_batarang_damage"):GetInt()
    self.Primary.ClipSize = GetConVar("ttt_batarang_clipSize"):GetInt()
    self.Primary.DefaultClip = GetConVar("ttt_batarang_ammo"):GetInt()
    self.Primary.Automatic = GetConVar("ttt_batarang_automaticFire"):GetBool()
    self.Primary.RPS = GetConVar("ttt_batarang_rps"):GetFloat()
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 1 / self.Primary.RPS)
    if not self:CanPrimaryAttack() then return end
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    if SERVER then owner:LagCompensation(true) end
    local dmg = DamageInfo()
    dmg:SetAttacker(owner)
    dmg:SetInflictor(self)
    if GetConVar("ttt_batarang_primary_sound"):GetBool() then self:EmitSound("weapons/batarang/throw" .. tostring(math.random(1, 4)) .. ".wav") end
    local dm = GetConVar("ttt_batarang_damage"):GetInt()
    self:ShootBullet(dm, 1, 0)
    self:TakePrimaryAmmo(1)
    owner:ViewPunch(Angle(-1, 0, 0))
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    if SERVER then
        local batarang = ents.Create("ent_ttt_ttt2_batarang")
        batarang:SetAngles(owner:EyeAngles())
        batarang:SetPos(owner:GetShootPos())
        batarang:SetOwner(owner)
        batarang:SetPhysicsAttacker(owner)
        batarang:Spawn()
        batarang:Activate()
        local phys = batarang:GetPhysicsObject()
        phys:SetVelocity(owner:GetAimVector() * 7000)
        phys:AddAngleVelocity(Vector(0, 0, 90))
        if self:Clip1() == 0 then self:Remove() end
        owner:LagCompensation(false)
    end
end