-- @description Toggle open and close all folder tracks
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   1.0 - New script which merges the 2 scripts for open/close all folder tracks


local function IsTrackFolder(track)
  return reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH") == 1
end

local function output(msg)
  if reaper.osara_outputMessage then
    reaper.osara_outputMessage(msg)
  else
    reaper.ShowMessageBox(msg, "Info", 0)
  end
end

-- Safety: empty project
local trackCount = reaper.CountTracks(0)
if trackCount < 1 then
  output("No tracks in your project")
  return
end

-- Step 1: detect current state
local anyNotFullyClosed = false -- true if at least one folder has I_FOLDERCOMPACT ~= 2
for i = 0, trackCount - 1 do
  local tr = reaper.GetTrack(0, i)
  if IsTrackFolder(tr) then
    local compact = reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERCOMPACT")
    if compact ~= 2 then
      anyNotFullyClosed = true
      break
    end
  end
end

-- Step 2: apply action
reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

local changed = 0
if anyNotFullyClosed then
  -- Close all folders
  for i = 0, trackCount - 1 do
    local tr = reaper.GetTrack(0, i)
    if IsTrackFolder(tr) then
      if reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERCOMPACT") ~= 2 then
        reaper.SetMediaTrackInfo_Value(tr, "I_FOLDERCOMPACT", 2)
        changed = changed + 1
      end
    end
  end
  reaper.PreventUIRefresh(-1)
  reaper.Undo_EndBlock("Close all folder tracks (toggle)", 0)
  if changed > 0 then
    output("All folder tracks was closed")
  else
    output("No folder track found")
  end
else
  -- Open all folders (all were closed)
  for i = 0, trackCount - 1 do
    local tr = reaper.GetTrack(0, i)
    if IsTrackFolder(tr) then
      if reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERCOMPACT") ~= 0 then
        reaper.SetMediaTrackInfo_Value(tr, "I_FOLDERCOMPACT", 0)
        changed = changed + 1
      end
    end
  end
  reaper.PreventUIRefresh(-1)
  reaper.Undo_EndBlock("Open all folder tracks (toggle)", 0)
  if changed > 0 then
    output("All folder tracks was opened")
  else
    output("No folder track found")
  end
end
