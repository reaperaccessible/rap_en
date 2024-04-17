-- @Description Open selected track folder
-- @version 1.0
-- @author Ludovic SANSONE for Reaper Accessible


-- Fonction vérifiant si la piste  placée en paramètre est bien un dossier
function IsTrackFolder(track)
    local trackDepth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")

    if trackDepth == 1 then
        return true
    else
        return false
    end
end

if reaper.CountTracks() < 1 then
    reaper.osara_outputMessage("No tracks in project")
    return
end

-- On récupère la piste sélectionnée
local tr = reaper.GetSelectedTrack2(0, 0, 1)

-- On récupère son status : S'agit-il d'un dossier ou non
local status = IsTrackFolder(tr)

-- On récupère son nom pour pouvoir le faire énoncer par Osara
local b, name = reaper.GetTrackName(tr)

-- S'il s'agit d'un dossier, on exécute le code
if status then
    if reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERCOMPACT") ~= 0 then
        reaper.SetMediaTrackInfo_Value(tr, "I_FOLDERCOMPACT", 0)
        reaper.osara_outputMessage("Folder "..name.." opened")
    else
        reaper.osara_outputMessage(name.." is already open")
    end
else
    reaper.osara_outputMessage(name.." is not a folder")
end
