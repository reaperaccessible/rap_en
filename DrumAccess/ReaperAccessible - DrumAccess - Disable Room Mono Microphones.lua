-- @description Disable Room Mono Microphones for DrumAccess
-- @version 1.3
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Code improvement


-- Obtenez le nombre de pistes sélectionnées
local numSelectedTracks = reaper.CountSelectedTracks(0)

if numSelectedTracks == 0 then
    return reaper.osara_outputMessage("This track is not the DrumAccess folder track. Select the DrumAccess folder track and trigger this script again.")
end

local keywordDetected = false
local keyword = "Room Mono Volume"

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
        reaper.osara_outputMessage("Room Mono microphone are disabled.")
    end)
else
    reaper.osara_outputMessage("No parameters are displayed, the selected track does not contain DrumAccess FX, or this kit piece does not offer Room Mono microphone. Please select the DrumAccess folder track, trigger the script ReaperAccessible - DrumAccess - Make drum kit parameters available, select a track that contains a DrumAccess FX, and triggering this action again.")
end
