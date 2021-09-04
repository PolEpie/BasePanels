function Quiditch.Notif(msg, type, ply)

    net.Start("Quiditch:Notification")
    net.WriteString(msg)
    net.WriteUInt(type,5)
    net.Send(ply)

end

function GenerateRandomVector(Vector1, Vector2)
    local randX = math.Rand(math.min(Vector1[1], Vector2[1]), math.max(Vector1[1], Vector2[1]))
    local randY = math.Rand(math.min(Vector1[2], Vector2[2]), math.max(Vector1[2], Vector2[2]))
    local randZ = math.Rand(math.min(Vector1[3], Vector2[3]), math.max(Vector1[3], Vector2[3]))

    return Vector(randX, randY, randZ)
end