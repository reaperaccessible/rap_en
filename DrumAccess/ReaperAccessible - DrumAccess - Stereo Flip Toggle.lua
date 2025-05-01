-- @description Stereo Flip Toggle
-- @version 1.1
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-04-24 - New script


for key in pairs(reaper) do _G[key] = reaper[key] end 
function VF_CheckReaperVrs(rvrs, showmsg) 
  local vrs_num = GetAppVersion()
  vrs_num = tonumber(vrs_num:match('[%d%.]+'))
  if rvrs > vrs_num then 
    if showmsg then 
      reaper.MB('Update REAPER to newer version '..'('..rvrs..' or newer)', '', 0) 
    end
    return
  else
    return true
  end
end

function main() 
  -- Check the number of selected tracks
  local trackCount = CountSelectedTracks(0)
  -- If no track is selected, display an error message and stop
  if trackCount == 0 then 
    reaper.MB("No track is selected", "Error", 0)
    reaper.osara_outputMessage("No track selected.")
    return
  end
  
  -- Arrays to store the names of modified tracks
  local invertedTracks = {}
  local normalTracks = {}
  
  -- Loop through all selected tracks
  for i = 0, trackCount - 1 do
    local tr = GetSelectedTrack(0, i)  -- get each selected track
    -- Get the track name
    local _, trackName = GetTrackName(tr)
    
    -- Modify the pan mode on the selected track (now applies to all tracks including folders)
    SetMediaTrackInfo_Value(tr, 'I_PANMODE', 5) 
    
    -- Get the current track width
    local D_WIDTH = GetMediaTrackInfo_Value(tr, 'D_WIDTH')
    
    -- Modify the width of the selected track and record its state
    if D_WIDTH > 0 then 
      SetMediaTrackInfo_Value(tr, 'D_WIDTH', -1)
      table.insert(invertedTracks, trackName)
    else 
      SetMediaTrackInfo_Value(tr, 'D_WIDTH', 1)
      table.insert(normalTracks, trackName)
    end
  end
  
  -- Prepare and announce the summary message
  local message = ""
  
  -- Add tracks with inverted stereo
  if #invertedTracks > 0 then
    message = message .. #invertedTracks .. " tracks with inverted stereo: " 
    message = message .. table.concat(invertedTracks, ", ") .. ". "
  end
  
  -- Add tracks with normal stereo
  if #normalTracks > 0 then
    message = message .. #normalTracks .. " tracks with normal stereo: " 
    message = message .. table.concat(normalTracks, ", ") .. "."
  end
  
  -- Announce the summary message
  if message ~= "" then
    reaper.osara_outputMessage(message)
  else
    reaper.osara_outputMessage("No modifications made.")
  end
end

if VF_CheckReaperVrs(5.975, true) then 
  main() 
end