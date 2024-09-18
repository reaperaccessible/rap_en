-- @description Speak name of selected track
-- @version 1.1
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=midi_editor] .


local trackNumber = reaper.CountTracks(0)
local track = reaper.GetSelectedTrack2(0, 0, 1)


local trackNum = reaper.GetMediaTrackInfo_Value(track, 'IP_TRACKNUMBER')




if trackNumber > 0 then
    local b, trackName = reaper.GetTrackName(track)
    reaper.osara_outputMessage(trackName)
else
    reaper.osara_outputMessage("No tracks in your project")
end
