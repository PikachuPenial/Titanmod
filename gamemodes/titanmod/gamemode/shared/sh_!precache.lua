local modelsDone
local soundsDone = {}

local function CacheModel(mdl)
    if SERVER then
        if util.IsValidModel(tostring(mdl)) then end
    end
end

local function GrabModelFiles(dir)
    if !modelsDone then
        local files, directories = file.Find(dir .. "*", "THIRDPARTY")
        for _, fdir in pairs(directories) do
            if fdir != ".svn" then
                GrabModelFiles(dir .. fdir .. "/")
            end
        end

        for k, v in pairs(files) do
            local fname = string.lower(dir .. v)
            local ismodel = -1
            ismodel = (string.find(fname, ".mdl"))
            if ismodel and ismodel >= 0 then timer.Simple(k * 0.01, function() CacheModel(fname) end) end
        end
    end
end

local function CacheAllModels()
    if !modelsDone then
        GrabModelFiles("models/")
        modelsDone = true
    end
end

local function CacheSound(str, cmdl)
    local ex = string.GetExtensionFromFilename(str)

    if ex == "ogg" or ex == "wav" or ex == "mp3" then
        if SERVER then
            str = string.Replace(str, "sound\\", "")
            str = string.Replace(str, "sound/", "" )
            if IsValid(cmdl) then cmdl:EmitSound(str, 0, 100, 0.001, CHAN_WEAPON) end
        else
            if IsValid(LocalPlayer()) then
                -- LocalPlayer():EmitSound(str, 75, 100, 0.001, CHAN_WEAPON)
            end
        end
    end
end

local function GrabSoundFiles(dir, cmdl)
    if !soundsDone[dir] then
        local files, directories = file.Find(dir .. "*", "THIRDPARTY")
        for _, fdir in pairs(directories) do
            if fdir != ".svn" then
                GrabSoundFiles(dir .. fdir .. "/")
            end
        end

        for k, v in pairs(files) do
            local fname = string.lower(dir .. v)
            local issound = false
            issound = (string.find(fname, ".wav") or string.find(fname, ".mp3") or string.find(fname, ".ogg"))
            if issound >= 0 then
                timer.Simple(k * 0.01, function()
                    CacheSound(fname, cmdl)
                end)
            end
        end

        soundsDone[dir] = true
    end
end

local function CacheManualSounds()
    -- if game.SinglePlayer() and CLIENT then return end
    local cmdl
    if SERVER then cmdl = ents.Create("prop_dynamic") end

    GrabSoundFiles("sound/", cmdl)

    if SERVER then timer.Simple(5, function() cmdl:Remove() end) end
end

concommand.Add("tm_precache", function() CacheAllModels() CacheManualSounds() end)
timer.Simple(1, function()
    if SERVER then CacheAllModels() end
    CacheManualSounds()
end)