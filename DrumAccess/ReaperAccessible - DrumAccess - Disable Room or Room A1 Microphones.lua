-- @description Disable Room or Room A1 Microphones for DrumAccess
-- @version 1.7
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Code improvement


-- Obtenez le nombre de pistes sélectionnées
local numSelectedTracks = reaper.CountSelectedTracks(0)

if numSelectedTracks == 0 then
    return reaper.osara_outputMessage("This track is not a DrumAccess folder track. Select the DrumAccess folder track and run this script.")
end

local keywordDetected = false
local keyword = { "Room Volume", "Room Mono Volume" }

-- Parcourir toutes les pistes sélectionnées
for i = 0, numSelectedTracks - 1 do
    local track = reaper.GetSelectedTrack(0, i)
    local fx = reaper.TrackFX_GetInstrument(track)

    -- Parcourir tous les paramètres du plugin sur la piste
    local numParams = reaper.TrackFX_GetNumParams(track, fx)
    for j = 0, numParams - 1 do
        local _, paramDisplayName = reaper.TrackFX_GetParamName(track, fx, j, "")

        -- Vérifiez si le nom du paramètre contient le mot-clé
        if string.find(paramDisplayName, keyword) then
            reaper.TrackFX_SetParam(track, fx, j, 0.0)
            keywordDetected = true
        end
    end
end

if keywordDetected then
    reaper.defer(function()
        reaper.osara_outputMessage("The Room or Room A1 microphone is disabled.")
    end)
else
    reaper.osara_outputMessage("No parameters are available. The selected track does not contain a DrumAccess FX, or this kit piece does not offer a Room or Room A1 microphone. Please select the DrumAccess folder track, run the script ReaperAccessible - DrumAccess - Make Drum Kit parameters Available, select a track containing a DrumAccess FX, and run this script again.")
end
