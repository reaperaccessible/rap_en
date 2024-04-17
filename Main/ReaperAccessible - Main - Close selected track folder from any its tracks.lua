-- @Description Close selected track folder from any its tracks
-- @version 1.0
-- @author Ludovic SANSONE for Reaper Accessible


reaper.Undo_BeginBlock()

-- Fonction vérifiant si la piste  placée en paramètre est bien un dossier
function IsTrackFolder(track)
    local trackDepth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")

    if trackDepth == 1 then
        return true
    else
        return false
    end
end

-- Fonction vérifiant si la piste sélectionnée se trouve bien à l'intérieur d'un dossier
function isInTrackFolder(track)
    local trackLevel = reaper.GetTrackDepth(track)
    if trackLevel > 0 then
        return true
    else
        return false
    end
end

-- Fonction sélectionnant le dossier de pistes courant
function selectCurrentTrackFolder(track)
    local trackDepth = reaper.GetTrackDepth(track)
    local folderDepth = trackDepth - 1
    local trackNumber = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
    
    if trackDepth <= 0 then
        reaper.osara_outputMessage("This track is not in a folder")
        return
    else
        for i = trackNumber, 1, -1 do
           newTrack = reaper.GetTrack(0, i - 1)
           newDepth = reaper.GetTrackDepth(newTrack)
           if newDepth == folderDepth then
               reaper.SetOnlyTrackSelected(newTrack)
               return newTrack
           end
        end
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

-- S'il s'agit d'un dossier, ou d'une piste enfant d'un dossier, on exécute le code
if status then
    if reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERCOMPACT") ~= 2 then
        reaper.SetMediaTrackInfo_Value(tr, "I_FOLDERCOMPACT", 2)
        local b, name = reaper.GetTrackName(tr)
        reaper.osara_outputMessage("Folder "..name.." closed")
    else
        local b, name = reaper.GetTrackName(tr)
        reaper.osara_outputMessage(name.." is already closed")
        return
    end
elseif reaper.GetTrackDepth(tr) > 0 then
    tr = selectCurrentTrackFolder(tr)
    local b, name = reaper.GetTrackName(tr)
    if reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERCOMPACT") ~= 2 then
        reaper.SetMediaTrackInfo_Value(tr, "I_FOLDERCOMPACT", 2)
        reaper.osara_outputMessage("Folder "..name.." closed")
    else
        local b, name = reaper.GetTrackName(tr)
        reaper.osara_outputMessage(name.." is already closed")
        return
    end
else
    local b, name = reaper.GetTrackName(tr)
    reaper.osara_outputMessage(name.." is not a folder")
end

reaper.Undo_EndBlock("Closing folder", 0) 
