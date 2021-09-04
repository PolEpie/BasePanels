--[[
    Database Setup
]]

require("mysqloo")

Quiditch.DB = mysqloo.connect("51.89.128.245", "u33715_2O8346HaHl", "n2hOmZTN56bt2BCR", "s33715_test", 3306)

function Quiditch.DB:onConnected()

    print("[QUIDITCH] Database has connected!")

    --[[
       Select charset for accent
    ]]

    local q = self:prepare([[SET NAMES 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';]])
    function q:onSuccess(data)
        print("[QUIDITCH] Database Charset successfully set !")
    end

    function q:onError(err, sql)
        print("[QUIDITCH] Query errored!")
        print("[QUIDITCH] Query:", sql)
        print("[QUIDITCH] Error:", err)
        print("[QUIDITCH] " .. debug.traceback())
    end

    q:start()

    --[[
        Create teams table and add row for each default houses
     ]]

    local q2 = self:prepare([[create table if not exists `quiditch-teams`
    (
        name varchar(120) not null primary key,
        is_house tinyint default 0 null,
        constraint `quiditch-houses_name_uindex`
            unique (name)
    );]])

    function q2:onSuccess(data)
        print("[QUIDITCH] Table `quiditch-teams` created !")

        for _, v in ipairs(Quiditch.Config.Houses) do

            local q = Quiditch.DB:prepare([[INSERT INTO `quiditch-teams` (name, is_house)
            SELECT "]] .. v.Name .. [[", 1
            WHERE NOT EXISTS (SELECT * FROM `quiditch-teams` where name = "]] .. v.Name .. [[")]])

            function q:onSuccess(data)
                print("[QUIDITCH] Row " .. v.Name .. " added successfully!")
            end

            function q:onError(err, sql)
                print("[QUIDITCH] Query errored!")
                print("[QUIDITCH] Query:", sql)
                print("[QUIDITCH] Error:", err)
                print("[QUIDITCH] " .. debug.traceback())
            end

            q:start()
        end
    end

    function q2:onError(err, sql)
        print("[QUIDITCH] Query errored!")
        print("[QUIDITCH] Query:", sql)
        print("[QUIDITCH] Error:", err)
        print("[QUIDITCH] " .. debug.traceback())
    end

    q2:start()

    --[[
        Table of players
      ]]

    local q3 = self:prepare([[create table if not exists `quiditch-players`
    (
        team varchar(120) not null,
        uid varchar(64) null,
        name varchar(120) null,
        job varchar(50) null
    );
    ]])

    function q3:onSuccess(data)
        print("[QUIDITCH] Table `quiditch-players` created !")
    end

    function q3:onError(err, sql)
        print("[QUIDITCH] Query errored!")
        print("[QUIDITCH] Query:", sql)
        print("[QUIDITCH] Error:", err)
        print("[QUIDITCH] " .. debug.traceback())
    end

    q3:start()

    --[[
        Table of requests
      ]]

    local q4 = self:prepare([[create table if not exists `quiditch-request`
    (
        name varchar(120) null,
        uid varchar(64) null,
        team varchar(120) null
    );
    ]])

    function q4:onSuccess(data)
        print("[QUIDITCH] Table `quiditch-request` created !")
    end

    function q4:onError(err, sql)
        print("[QUIDITCH] Query errored!")
        print("[QUIDITCH] Query:", sql)
        print("[QUIDITCH] Error:", err)
        print("[QUIDITCH] " .. debug.traceback())
    end

    q4:start()

    timer.Simple(10, function()
        Quiditch.Houses = {}
        Quiditch.Teams = {}
        local q = Quiditch.DB:prepare("select * from `quiditch-teams`;")

        function q:onSuccess(data)
            for _, v in ipairs(data) do
                if v.is_house then
                    Quiditch.Houses[v.name] = {  }
                else
                    Quiditch.Teams[v.name] = {  }
                end
            end

            local q2 = Quiditch.DB:prepare("select * from `quiditch-players`;")

            function q2:onSuccess(data)
                for _, v in ipairs(data) do
                    if Quiditch.Houses[v.team] then
                        if v.job then
                            Quiditch.Houses[v.team][v.job .. "_uid"] = v.uid
                            Quiditch.Houses[v.team][v.job .. "_name"] = v.name
                        else
                            Quiditch.Houses[v.team]["noteam"] = Quiditch.Houses[v.team]["noteam"] or {}

                            Quiditch.Houses[v.team]["noteam"][#Quiditch.Houses[v.team]["noteam"] + 1] = {
                                ["name"] = v.name,
                                ["uid"] = v.uid
                            }
                        end
                    elseif Quiditch.Teams[v.team] then
                        if v.job then
                            Quiditch.Teams[v.team][v.job .. "_uid"] = v.uid
                            Quiditch.Teams[v.team][v.job .. "_name"] = v.name
                        else
                            Quiditch.Teams[v.team]["noteam"] = Quiditch.Teams[v.team]["noteam"] or {}

                            Quiditch.Teams[v.team]["noteam"][#Quiditch.Teams[v.team]["noteam"] + 1] = {
                                ["name"] = v.name,
                                ["uid"] = v.uid
                            }
                        end
                    end
                end
            end

            function q2:onError(err, sql)
                print("[QUIDITCH] Query errored!")
                print("[QUIDITCH] Query:", sql)
                print("[QUIDITCH] Error:", err)
                print("[QUIDITCH] " .. debug.traceback())
            end

            q2:start()

            --[[
                Collect requests to teams
             ]]

            local q3 = Quiditch.DB:prepare("select * from `quiditch-request`;")

            function q3:onSuccess(data)
                for _, v in ipairs(data) do
                    if Quiditch.Houses[v.team] then
                        Quiditch.Houses[v.team]["request"] = Quiditch.Houses[v.team]["request"] or {}

                        Quiditch.Houses[v.team]["request"][v.uid] = v.name
                    elseif Quiditch.Teams[v.team] then
                        Quiditch.Teams[v.team]["request"] = Quiditch.Teams[v.team]["request"] or {}

                        Quiditch.Teams[v.team]["request"][v.uid] = v.name
                    end
                end
            end

            function q3:onError(err, sql)
                print("[QUIDITCH] Query errored!")
                print("[QUIDITCH] Query:", sql)
                print("[QUIDITCH] Error:", err)
                print("[QUIDITCH] " .. debug.traceback())
            end

            q3:start()
        end

        function q:onError(err, sql)
            print("[QUIDITCH] Query errored!")
            print("[QUIDITCH] Query:", sql)
            print("[QUIDITCH] Error:", err)
            print("[QUIDITCH] " .. debug.traceback())
        end

        q:start()
    end)
end

function Quiditch.DB:onConnectionFailed(err)

    print("[QUIDITCH] Error Database Connexion")
    print(err)

end

Quiditch.DB:connect()





--[[
    Database functions
]]




function Quiditch.AddRequestToTeam(teamName, ply, is_house)

    if is_house then
        Quiditch.Houses[teamName]["request"] = Quiditch.Houses[teamName]["request"] or {}

        Quiditch.Houses[teamName]["request"][ply:SteamID64()] = ply:Name()
    else
        Quiditch.Teams[teamName]["request"] = Quiditch.Teams[teamName]["request"] or {}

        Quiditch.Teams[teamName]["request"][ply:SteamID64()] = ply:Name()
    end

    local q = Quiditch.DB:prepare("insert into `quiditch-request` (name, uid, team) values (?,?,?);")

    function q:onError(err, sql)
        print("[QUIDITCH] Query errored!")
        print("[QUIDITCH] Query:", sql)
        print("[QUIDITCH] Error:", err)
        print("[QUIDITCH] " .. debug.traceback())
    end

    q:setString(1,ply:Name())
    q:setString(2,ply:SteamID64())
    q:setString(3, teamName)
    q:start()

end