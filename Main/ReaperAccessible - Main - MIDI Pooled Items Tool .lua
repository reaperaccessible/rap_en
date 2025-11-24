-- @description MIDI Pooled Items Tool 
-- @version 1.0
-- @author Lee JULIEN pour ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2025-11-23 - New script


local function msg(s)
  reaper.ShowMessageBox(s, "MIDI Pooled Items Tool", 0)
end

local function trim(s)
  return s:match("^%s*(.-)%s*$")
end

local function is_midi_source(src)
  if not src then return false end
  local buf = ""
  local t = reaper.GetMediaSourceType(src, buf)
  return t == "MIDI"
end

-- Get the active MIDI take of an item, if any
local function get_active_midi_take(item)
  if not item then return nil end
  local take = reaper.GetActiveTake(item)
  if not take then return nil end
  local src = reaper.GetMediaItemTake_Source(take)
  if is_midi_source(src) then
    return take
  end
  return nil
end

-- Get ALL items on the given track, sorted by position (no MIDI filtering here)
local function get_items_on_track(track)
  local items = {}
  local item_count = reaper.CountTrackMediaItems(track)

  for i = 0, item_count - 1 do
    local item = reaper.GetTrackMediaItem(track, i)
    local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
    table.insert(items, { item = item, pos = pos })
  end

  table.sort(items, function(a, b) return a.pos < b.pos end)
  return items
end

-- Paste as real pooled (ghost) copy at the edit cursor using native actions
local function paste_pooled_item_from_model(track, model_item)
  local model_take = get_active_midi_take(model_item)
  if not model_take then
    msg("The chosen model item does not have an active MIDI take.")
    return
  end

  -- Deselect all items
  reaper.Main_OnCommand(40289, 0) -- Unselect all items

  -- Select only the model item
  reaper.SetMediaItemSelected(model_item, true)
  reaper.UpdateArrange()

  -- Copy item
  reaper.Main_OnCommand(40698, 0) -- Item: Copy items

  -- Paste items/tracks, creating pooled (ghost) MIDI items regardless of prefs
  reaper.Main_OnCommand(41072, 0) -- Item: Paste items/tracks, creating pooled (ghost) MIDI items...

  reaper.UpdateArrange()
end

-- Unpool the given item (use native REAPER action 41613)
local function unpool_item(item)
  -- Just select this item and call the unpool action.
  -- If it's not a MIDI pooled item, REAPER will simply do nothing.
  reaper.Main_OnCommand(40289, 0) -- Unselect all items
  reaper.SetMediaItemSelected(item, true)
  reaper.UpdateArrange()

  -- Item: Remove active take from MIDI pool (make unique)
  reaper.Main_OnCommand(41613, 0)

  reaper.UpdateArrange()
end

-- ===================== MAIN =====================

local retval, retvals_csv = reaper.GetUserInputs(
  "MIDI Pooled Items Tool",
  2,
  "Item number,Action (1=Paste pooled,2=Unpool)",
  ""
)

if not retval then
  return -- User cancelled
end

local item_str, action_str = retvals_csv:match("([^,]*),([^,]*)")
if not item_str or not action_str then
  msg("Invalid input format. Expected: number,action.")
  return
end

item_str   = trim(item_str)
action_str = trim(action_str)

local item_index = tonumber(item_str)
local action     = tonumber(action_str)

if not item_index or item_index < 1 then
  msg("Invalid item number. Must be an integer >= 1.")
  return
end

if action ~= 1 and action ~= 2 then
  msg("Invalid action. Use 1 for Paste pooled, 2 for Unpool.")
  return
end

-- Get the first selected track
local track = reaper.GetSelectedTrack(0, 0)
if not track then
  msg("No track selected.\nSelect a track containing the model items.")
  return
end

-- Get ALL items on this track
local items_on_track = get_items_on_track(track)

if #items_on_track == 0 then
  msg("No items found on the selected track.")
  return
end

if item_index > #items_on_track then
  msg(
    "Item number (" .. item_index .. ") exceeds the number of items on this track (" ..
    #items_on_track .. ")."
  )
  return
end

local target_item = items_on_track[item_index].item

reaper.Undo_BeginBlock()

if action == 1 then
  -- Paste pooled copy at edit cursor
  paste_pooled_item_from_model(track, target_item)
elseif action == 2 then
  -- Unpool this item
  unpool_item(target_item)
end

reaper.Undo_EndBlock("MIDI Pooled Items Tool", -1)
