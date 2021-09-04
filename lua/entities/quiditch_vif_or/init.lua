AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

local vect1 = Vector( 632.950928, -899.154480, -79.968750)
local vect2 = Vector( -1.063074, -185.469589, 358.144897)


function ENT:Initialize()
    self:SetModel("models/props_junk/gascan001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if (IsValid(phys)) then
        phys:Wake()
    end
end

function ENT:Think()

    local systime = CurTime()

    if not self.NextPos or self.NextPos:DistToSqr(self:GetPos()) < 1000 then
        self.NextPos = GenerateRandomVector(vect1, vect2)
        self.End = systime + math.Rand(0.2, 0.7)
    end

    local phys = self:GetPhysicsObject()
    if (IsValid(phys)) then
        phys:SetVelocity( (self.NextPos - self:GetPos()) * 5)
    end
end