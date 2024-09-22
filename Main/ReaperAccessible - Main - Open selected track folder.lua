-- @description Open selected track folder
-- @version 1.4
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log
--   # 2024-09-22 - Translation of messages into English


-- Begin undo block
reaper.Undo_BeginBlock()

-- Function to check if a track is a folder track
function IsTrackFolder(track)
    local trackDepth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
    if trackDepth == 1 then
        return true
    else
        return false
    end
end

-- Check if there are tracks in the project
local numTracks = reaper.CountTracks()
if numTracks < 1 then
    reaper.osara_outputMessage("No tracks in your project")
    return
end

-- Get the first selected track
local selectedTrack = reaper.GetSelectedTrack(0, 0)

-- Check if no track is selected
if selectedTrack == nil then
    reaper.osara_outputMessage("No track selected")
    return
end

-- Check if the selected track is a folder
local isFolder = IsTrackFolder(selectedTrack)

-- Get the name of the selected track
local success, trackName = reaper.GetTrackName(selectedTrack)

-- If the track is a folder, check if it's compact (closed) or not
if isFolder then
    if reaper.GetMediaTrackInfo_Value(selectedTrack, "I_FOLDERCOMPACT") ~= 0 then
        reaper.SetMediaTrackInfo_Value(selectedTrack, "I_FOLDERCOMPACT", 0)
        reaper.osara_outputMessage("Folder "..trackName.." opened")
    else
        reaper.osara_outputMessage(trackName.." is already open")
    end
else
    reaper.osara_outputMessage(trackName.." is not a folder")
end

-- End undo block with the specified message
reaper.Undo_EndBlock("Opening the folder", -1)