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

SWEP.AllowDrop = true
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
SWEP.WorldModel = "models/rottweiler/batarang_thrown.mdl"
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

    function SWEP:DrawWorldModel()
        if not IsValid(self) then return end
        local owner = self:GetOwner()
        if not IsValid(owner) then
            self:DrawModel()
            return
        end

        local rightHandBone = owner:LookupBone("ValveBiped.Bip01_R_Hand")
        if not rightHandBone then return end
        local rightHandPos, rightHandAngle = owner:GetBonePosition(rightHandBone)
        if not rightHandPos or not rightHandAngle then return end
        rightHandPos = rightHandPos + rightHandAngle:Forward() * 8 + rightHandAngle:Right() * 1.5 + rightHandAngle:Up() * -4
        rightHandAngle:RotateAroundAxis(rightHandAngle:Right(), 180)
        if not IsValid(self.HeldWorldModel) then
            self.HeldWorldModel = ClientsideModel("models/rottweiler/w_batarang.mdl", RENDERGROUP_OPAQUE)
            self.HeldWorldModel:SetNoDraw(true)
        end

        render.Model({
            model = "models/rottweiler/w_batarang.mdl",
            pos = rightHandPos,
            angle = rightHandAngle
        }, self.HeldWorldModel)
    end

    function SWEP:OnRemove()
        if IsValid(self.HeldWorldModel) then
            self.HeldWorldModel:Remove()
            self.HeldWorldModel = nil
        end
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
    if GetConVar("ttt_batarang_primary_sound"):GetBool() then self:EmitSound("weapons/batarang/throw" .. tostring(math.random(1, 4)) .. ".wav") end
    owner:ViewPunch(Angle(-1, 0, 0))
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self:TakePrimaryAmmo(1)
    if SERVER then
        local batarang = ents.Create("ent_ttt_ttt2_batarang")
        batarang:SetAngles(owner:EyeAngles())
        batarang:SetPos(owner:GetShootPos())
        batarang:SetOwner(owner)
        batarang:SetPhysicsAttacker(owner)
        batarang:Spawn()
        batarang:Activate()
        local phys = batarang:GetPhysicsObject()
        phys:SetVelocity(owner:GetAimVector() * 100000)
        phys:AddAngleVelocity(Vector(0, 0, 90))
        if self:Clip1() == 0 then self:Remove() end
        owner:LagCompensation(false)
    end
end