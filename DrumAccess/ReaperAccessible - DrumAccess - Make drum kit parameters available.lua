-- @description Make all drum kit parameters available for DrumAccess
-- @version 1.5
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Code improvement
--   # 2025-04-08 - Adaptation of the code so that it is compatible with Drumaccess V2


-- Fonction pour ouvrir la fenêtre FX d'une piste
local function openFXWindow(track)
    -- récupérer le nom de l'fx 0
    retval, fx_name = reaper.TrackFX_GetFXName(track, 0, "")
    -- vérifier la présence d'une redirrection de cymbale
    if fx_name:find("DrumAccess Cymbal Mapper") then
      fxptr=1
    else
      fxptr=0
    end
    reaper.TrackFX_Show(track, fxptr, 3)
end

-- Fonction pour énoncer un message via OSARA
local function osaraOutputMessage(message)
    reaper.osara_outputMessage(message)
end

-- Fonction pour afficher la boîte de message et énoncer le message
local function showMessageAndSpeak(message)
    reaper.MB(message, "Message", 0)
    reaper.defer(function()
        osaraOutputMessage("Message " .. message)
    end)
end

local function main()
    reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN"), 0)
    
    local selectedTrack = reaper.GetSelectedTrack(0, 0)
    if not selectedTrack then
        return reaper.MB("You must select the DrumAccess folder track.", "Erreur", 0)
    end
    
    local folderTrack = reaper.GetMediaTrackInfo_Value(selectedTrack, "P_PARTRACK")
    if folderTrack == 0 then
        local depth = reaper.GetMediaTrackInfo_Value(selectedTrack, "I_FOLDERDEPTH")
        if depth ~= 1 then
            return reaper.MB("The selected track is not a DrumAccess folder track.", "Erreur", 0)
        end
    end
    
    local numTracks = reaper.CountTracks(0)
    
    for i = 0, numTracks - 1 do
        openFXWindow(reaper.GetTrack(0, i))
    end
    
    local message = "All kit parameters are now available. Press Space to close this window."
    
    -- Utiliser un timer pour retarder l'affichage de la boîte de message et l'énoncé
    reaper.defer(function()
        local start_time = reaper.time_precise()
        local function wait()
            if reaper.time_precise() - start_time >= 1 then  -- 1 second delay
                showMessageAndSpeak(message)
                reaper.Main_OnCommand(reaper.NamedCommandLookup("_S&M_WNCLS3"), 0)
            else
                reaper.defer(wait)
            end
        end
        wait()
    end)
end

main()