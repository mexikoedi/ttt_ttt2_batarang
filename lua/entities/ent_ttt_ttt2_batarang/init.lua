if engine.ActiveGamemode() ~= "terrortown" then return end
AddCSLuaFile()
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
    self:SetModel("models/rottweiler/batarang_thrown.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self.Armed = true
    util.PrecacheSound("physics/metal/sawblade_stick3.wav")
    util.PrecacheSound("physics/metal/sawblade_stick2.wav")
    util.PrecacheSound("physics/metal/sawblade_stick1.wav")
    util.PrecacheSound("weapons/batarang/hit1.wav")
    util.PrecacheSound("weapons/batarang/hit2.wav")
    util.PrecacheSound("weapons/batarang/hit3.wav")
    if GetConVar("ttt_batarang_hit_sound"):GetBool() then
        self.Hit = {Sound("physics/metal/sawblade_stick1.wav"), Sound("physics/metal/sawblade_stick2.wav"), Sound("physics/metal/sawblade_stick3.wav")}
        self.FleshHit = {Sound("weapons/batarang/hit1.wav"), Sound("weapons/batarang/hit2.wav"), Sound("weapons/batarang/hit3.wav")}
    end

    self:GetPhysicsObject():SetMass(2)
end

function ENT:Think()
    self.lifetime = self.lifetime or CurTime() + 10
    if CurTime() > self.lifetime then self:Remove() end
end

function ENT:Disable()
    self.PhysicsCollide = function() end
    self.lifetime = CurTime() + 15
end

function ENT:PhysicsCollide(data)
    local hitEnt = data.HitEntity
    if not IsValid(self) or self.HasHit or not self.Armed then return end
    if not IsValid(hitEnt) or not hitEnt:IsPlayer() or not hitEnt:IsTerror() then
        self.Armed = false
        self:Disable()
        return
    end

    self.HasHit = true
    self.Armed = false
    local dmg = DamageInfo()
    local attacker = self:GetOwner()
    local inflictor = ents.Create("weapon_ttt_ttt2_batarang")
    if not IsValid(attacker) then attacker = self end
    dmg:SetAttacker(attacker)
    dmg:SetInflictor(inflictor)
    dmg:SetDamage(GetConVar("ttt_batarang_damage"):GetInt())
    dmg:SetDamageType(DMG_GENERIC)
    hitEnt:TakeDamageInfo(dmg)
    local effectdata = EffectData()
    effectdata:SetStart(data.HitPos)
    effectdata:SetOrigin(data.HitPos)
    effectdata:SetScale(1)
    util.Effect("BloodImpact", effectdata)
    self:Disable()
end