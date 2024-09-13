-- @description Disable Closed Microphones for DrumAccess
-- @version 1.2
-- @author Lee JULIEN for Reaper Accessible
-- @provides [main=main] .


-- Obtenez le nombre de pistes sélectionnées
local numSelectedTracks = reaper.CountSelectedTracks(0)

if numSelectedTracks == 0 then
    return reaper.osara_outputMessage("This track is not the DrumAccess folder track. Select the DrumAccess folder track and trigger this script again.")
end

-- Liste des mots-clés à rechercher dans les noms des paramètres
local keywords = {
    "In Volume",
    "In1 Volume",
    "In2 Volume",
    "In3 Volume",
    "Out Volume",
    "Out1 Volume",
    "Out2 Volume",
    "Sub Volume",
    "Top Volume",
    "Top1 Volume",
    "Top2 Volume",
    "Bottom Volume",
    "Bottom1 Volume",
    "Bottom2 Volume",
    "Buzz Volume",
    "Close Volume",
    "Electro Volume",
    "Direct Volume"
}

local keywordDetected = false

-- Parcourir toutes les pistes sélectionnées
for i = 0, numSelectedTracks - 1 do
    local track = reaper.GetSelectedTrack(0, i)
    local fx = reaper.TrackFX_GetInstrument(track)

    -- Parcourir tous les paramètres du plugin sur la piste
    local numParams = reaper.TrackFX_GetNumParams(track, fx)
    for j = 0, numParams - 1 do
        local _, paramDisplayName = reaper.TrackFX_GetParamName(track, fx, j, "")

        -- Vérifiez si le nom du paramètre contient l'un des mots-clés
        for _, keyword in ipairs(keywords) do
            if string.find(paramDisplayName, keyword) then
                reaper.TrackFX_SetParam(track, fx, j, 0.0)
                keywordDetected = true
                break
            end
        end
    end
end

if not keywordDetected then
    reaper.osara_outputMessage("No parameters are displayed, the selected track does not contain DrumAccess FX, or this kit piece does not offer Close microphone. Please select the DrumAccess folder track, trigger the script ReaperAccessible - DrumAccess - Make drum kit parameters available, select a track that contains a DrumAccess FX, and triggering this action again.")
else
    reaper.defer(function()
        reaper.osara_outputMessage("Closed microphones are disabled.")
    end)
end
