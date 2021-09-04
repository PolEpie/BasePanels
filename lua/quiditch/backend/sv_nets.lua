util.AddNetworkString("Quiditch:GetHousesInfo")
util.AddNetworkString("Quiditch:GetTeamsInfo")
util.AddNetworkString("Quiditch:ApplyTeam")
util.AddNetworkString("Quiditch:Notification")

net.Receive("Quiditch:GetHousesInfo", function(_, ply)
    if not ply:Alive() then return end
    if ply.LastQuiditchNet ~= nil and ply.LastQuiditchNet > os.time() then return end

    net.Start("Quiditch:GetHousesInfo")
    net.WriteTable(Quiditch.Houses)
    net.Send(ply)

    ply.LastQuiditchNet = os.time() + 1
end )

net.Receive("Quiditch:GetTeamsInfo", function(_, ply)
    if not ply:Alive() then return end
    if ply.LastQuiditchNet ~= nil and ply.LastQuiditchNet > os.time() then return end

    net.Start("Quiditch:GetTeamsInfo")
    net.WriteTable(Quiditch.Teams)
    net.Send(ply)

    ply.LastQuiditchNet = os.time() + 1
end )

net.Receive("Quiditch:ApplyTeam", function(_, ply)
    if not ply:Alive() then return end
    if ply.LastQuiditchNet ~= nil and ply.LastQuiditchNet > os.time() then return end

    local teamName = net.ReadString()

    if Quiditch.Houses[teamName] then

        if Quiditch.Houses[teamName]["request"] ~= nil and Quiditch.Houses[teamName]["request"][ply:SteamID64()] ~= nil then
            Quiditch.Notif(Quiditch.Lang.ApplyAlreadyDoneNotification, 0, ply)
        else
            Quiditch.Notif(Quiditch.Lang.ApplyNotification, 0, ply)

            Quiditch.AddRequestToTeam(teamName, ply, true)
        end

    elseif Quiditch.Teams[teamName] then

        if Quiditch.Teams[teamName]["request"] ~= nil and Quiditch.Teams[teamName]["request"][ply:SteamID64()] ~= nil then
            Quiditch.Notif(Quiditch.Lang.ApplyAlreadyDoneNotification, 0, ply)
        else
            Quiditch.Notif(Quiditch.Lang.ApplyNotification, 0, ply)

            Quiditch.AddRequestToTeam(teamName, ply, false)
        end
    end

    ply.LastQuiditchNet = os.time() + 1
end )