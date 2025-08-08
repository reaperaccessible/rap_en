-- @description Toggle open and close selected folder track
-- @version 1.5
-- @author Lee JULIEN for ReaperAccessible
-- @changelog
--   1.5 - New script which replaces the 2 scripts for the open/close track folder.


local function output(msg)
  if reaper.osara_outputMessage then
    reaper.osara_outputMessage(msg)
  else
    reaper.ShowMessageBox(msg, "Info", 0)
  end
end

local function get_track_name(tr)
  local _, name = reaper.GetTrackName(tr or 0)
  if not name or name == "" then
    local idx = math.floor(reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER"))
    name = "Track " .. tostring(idx)
  end
  return name
end

-- Find the target folder track.
-- If a child track is selected, select its parent folder (wrapped in PreventUIRefresh to suppress OSARA announcements)
local function resolve_folder_target(selectedTrack)
  if not selectedTrack then return nil end

  local folderFlag = reaper.GetMediaTrackInfo_Value(selectedTrack, "I_FOLDERDEPTH")
  if folderFlag == 1 then
    return selectedTrack
  end

  local depth = reaper.GetTrackDepth(selectedTrack)
  if depth > 0 then
    local selIdx1 = math.floor(reaper.GetMediaTrackInfo_Value(selectedTrack, "IP_TRACKNUMBER"))
    for i = selIdx1 - 1, 1, -1 do
      local tr = reaper.GetTrack(0, i - 1)
      if reaper.GetTrackDepth(tr) == depth - 1 then
        -- Select parent silently
        reaper.PreventUIRefresh(1)
        reaper.SetOnlyTrackSelected(tr)
        reaper.PreventUIRefresh(-1)
        return tr
      end
    end
  end

  return nil
end

reaper.Undo_BeginBlock()

if reaper.CountTracks(0) < 1 then
  output("No tracks in your project")
  reaper.Undo_EndBlock("Toggle folder: no track", -1)
  return
end

local selectedTrack = reaper.GetSelectedTrack(0, 0)
if not selectedTrack then
  output("No track selected")
  reaper.Undo_EndBlock("Toggle folder: no selected track", -1)
  return
end

local targetTrack = resolve_folder_target(selectedTrack)
if not targetTrack then
  output("Folder for " .. get_track_name(selectedTrack) .. " not found")
  reaper.Undo_EndBlock("Toggle folder: track not in folder", -1)
  return
end

local tName = get_track_name(targetTrack)
local compact = reaper.GetMediaTrackInfo_Value(targetTrack, "I_FOLDERCOMPACT")

if compact ~= 0 then
  reaper.SetMediaTrackInfo_Value(targetTrack, "I_FOLDERCOMPACT", 0)
  output("Folder " .. tName .. " opened")
else
  reaper.SetMediaTrackInfo_Value(targetTrack, "I_FOLDERCOMPACT", 2)
  output("Folder " .. tName .. " closed")
end

reaper.Undo_EndBlock("Toggle open/close folder", -1)
