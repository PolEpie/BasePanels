Quiditch = {}

function Quiditch.AddFile(Path, Include)
    if (Include) then
        include("quiditch/" .. Path)
    else
        AddCSLuaFile("quiditch/" .. Path)
    end
end

function Quiditch.Load()



    if (SERVER) then

        --Include server side

        --Search of files and directories in quiditch folder
        local gmfiles, gmdirectorys = file.Find("quiditch/*", "LUA")

        for _, files in ipairs(gmfiles) do

            if string.sub(files, 1, 3) == "cl_" then
                Quiditch.AddFile(files, false)
                print("[QUIDITCH] Include client of : quiditch/" .. files)
            elseif string.sub(files, 1, 3) == "sh_" then
                Quiditch.AddFile(files, true)
                Quiditch.AddFile(files, false)
                print("[QUIDITCH] Include shared of : quiditch/" .. files)
            elseif string.sub(files, 1, 3) == "sv_" then
                Quiditch.AddFile(files, true)
                print("[QUIDITCH] Include server of : quiditch/" .. files)
            end
        end

        --Search of files in directories on quiditch folder

        for _, directory in ipairs(gmdirectorys) do
            gmfiles, _ = file.Find("quiditch/" .. directory .. "/*", "LUA")
            for _, files in ipairs(gmfiles) do
                if string.sub(files, 1, 3) == "cl_" then
                    Quiditch.AddFile(directory .. "/" .. files, false)
                    print("[QUIDITCH] Include client of : quiditch/" .. directory .. "/" .. files)
                elseif string.sub(files, 1, 3) == "sh_" then
                    Quiditch.AddFile(directory .. "/" .. files, true)
                    Quiditch.AddFile(directory .. "/" .. files, false)
                    print("[QUIDITCH] Include shared of : quiditch/" .. directory .. "/" .. files)
                elseif string.sub(files, 1, 3) == "sv_" then
                    Quiditch.AddFile(directory .. "/" .. files, true)
                    print("[QUIDITCH] Include server of : quiditch/" .. directory .. "/" .. files)
                end
            end
        end

        return

    end

    --Include client side

    --Search of files and directories in quiditch folder
    local gmfiles, gmdirectorys = file.Find("quiditch/*", "LUA")

    for _, files in ipairs(gmfiles) do
        if string.sub(files, 1, 3) == "cl_" then
            Quiditch.AddFile(files, false)
            print("[QUIDITCH] Include client of : quiditch/" .. files)
        elseif string.sub(files, 1, 3) == "sh_" then
            Quiditch.AddFile(files, true)
            Quiditch.AddFile(files, false)
            print("[QUIDITCH] Include shared of : quiditch/" .. files)
        end
    end

    --Search of files in directories on quiditch folder
    for _, directory in ipairs(gmdirectorys) do
        gmfiles, _ = file.Find("quiditch/" .. directory .. "/*", "LUA")

        --Boucle pour include les fichiers dans les dossiers de scrips
        for _, files in ipairs(gmfiles) do
            if string.sub(files, 1, 3) == "cl_" then
                Quiditch.AddFile(directory .. "/" .. files, true)
            elseif string.sub(files, 1, 3) == "sh_" then
                Quiditch.AddFile(directory .. "/" .. files, true)
            end
        end
    end
end

Quiditch.Load()