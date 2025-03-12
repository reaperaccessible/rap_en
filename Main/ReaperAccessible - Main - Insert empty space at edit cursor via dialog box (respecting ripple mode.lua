-- @description Insert empty space at edit cursor via dialog box (respecting ripple mode
-- @version 1.3
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log
--   # 2025-03-11 - Bug fixed for ripple mode all tracks
--   # 2025-03-11 - Adding a message for not installed Sws


-- USER CONFIG AREA ---------------------
console = true
popup = true -- User input dialog box

vars = {
  value = 1,
  unit = "s",
}

----------------- END OF USER CONFIG AREA

vars_order = {"value", "unit"}
ext_name = "XR_InsertEmptySpacePopup"
input_title = "Insert Empty Space"

separator = "\n"

instructions = {
  "Number greater than 0",
  "Unit: s for Second, ms for millisecond, samples for samples, grid for beats, frames for frames)",
  "separator=" .. separator,
}

undo_text = "Insert Empty Space"

function GetRippleMode()
  if not reaper.SNM_GetIntConfigVar then
    local sws_url = "https://reaperaccessible.fr/archives/S%20W%20S%2064-bit.zip"
    local message = "SWS extension is not installed or enabled. Please copy the displayed link to download it."
    reaper.GetUserInputs("SWS Download", 1, message .. "\n\nYou need to install the SWS extension to use this script. Copy this link and paste it in your browser:", sws_url)
    return nil
  end
  return reaper.SNM_GetIntConfigVar("projripedit", -1)
end

function ConvertValToSeconds(val, unit)
  local val = tonumber(val)
  if not val then return end
  local unit_length
  
  if unit == "grid" or unit == "g" then
    -- Use REAPER function to convert beats to seconds
    local proj = 0 -- Active project
    local qn = val -- Number of beats
    local time = reaper.TimeMap2_QNToTime(proj, qn)
    return time
  elseif unit == "samples" or unit == "smpl" then
    unit_length = reaper.parse_timestr_len("1", 0, 4)
  elseif unit == "ms" then
    unit_length = 1 / 1000
  elseif unit == "frames" or unit == "f" then
    local frameRate = reaper.TimeMap_curFrameRate(0)
    unit_length = 1 / frameRate
  else
    unit_length = 1
  end
  
  return val * unit_length
end

function SaveState()
  for k, v in pairs(vars) do
    reaper.SetExtState(ext_name, k, tostring(v), true)
  end
end

function GetExtState(var, val)
  if reaper.HasExtState(ext_name, var) then
    val = reaper.GetExtState(ext_name, var)
  end
  if type(val) == "boolean" then val = val == "true"
  elseif type(val) == "number" then val = tonumber(val)
  end
  return val
end

function GetValsFromExtState()
  for k, v in pairs(vars) do
    vars[k] = GetExtState(k, vars[k])
  end
end

function ConcatenateVarsVals()
  local vals = {}
  for i, v in ipairs(vars_order) do
    vals[i] = vars[v]
  end
  return table.concat(vals, "\n")
end

function ParseRetvalCSV(retvals_csv)
  local t = {}
  local i = 0
  for line in retvals_csv:gmatch("[^" .. separator .. "]*") do
    i = i + 1
    t[vars_order[i]] = line
  end
  return t
end

function ValidateVals(vars)
  for i, v in ipairs(vars_order) do
    if vars[v] == nil then
      return false
    end
  end
  return true
end

function InsertEmptyItemsOnAllTracks(start_time, end_time)
  -- Count the number of tracks in the project
  local track_count = reaper.CountTracks(0)
  local items_created = 0
  
  -- Loop through all tracks and insert an empty item on each
  for i = 0, track_count - 1 do
    local track = reaper.GetTrack(0, i)
    if track then
      local item = reaper.AddMediaItemToTrack(track)
      if item then
        reaper.SetMediaItemPosition(item, start_time, false)
        reaper.SetMediaItemLength(item, end_time - start_time, false)
        items_created = items_created + 1
      end
    end
  end
  
  return items_created
end

function Main()
  local value = ConvertValToSeconds(vars.value, vars.unit)
  local time_start, time_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
  
  local cur_pos = reaper.GetCursorPosition()
  local end_pos = cur_pos + value
  
  reaper.GetSet_LoopTimeRange(true, false, cur_pos, end_pos, false)
  
  local ripple_mode = GetRippleMode()
  if ripple_mode == nil then return end
  
  local message
  
  if ripple_mode == 1 then
    -- Track ripple mode
    reaper.Main_OnCommand(40142, 0) -- Insert empty space at time selection (moving later items)
    message = string.format("Empty space inserted on active track: %.2f seconds", value)
  elseif ripple_mode == 2 then
    -- All tracks ripple mode - CREATE EMPTY ITEMS ON ALL TRACKS
    
    -- First, create empty space to move later items
    reaper.Main_OnCommand(40200, 0) -- Time selection: Insert empty space at time selection (moving later items)
    
    -- Then, create empty items on all tracks
    local items_created = InsertEmptyItemsOnAllTracks(cur_pos, end_pos)
    
    message = string.format("Empty space and %d empty items created on all tracks: %.2f seconds", items_created, value)
  end
  
  reaper.GetSet_LoopTimeRange(true, false, time_start, time_end, false)
  
  reaper.osara_outputMessage(message)
end

function Init()
  local ripple_mode = GetRippleMode()
  if ripple_mode == nil then return end
  
  if ripple_mode == 0 then
    local message = "Ripple editing is disabled. You must set ripple editing to per-track or all tracks to use this script."
    reaper.ShowMessageBox(message, "Warning", 0)
    reaper.osara_outputMessage(message)
    return
  end

  if popup then
    GetValsFromExtState()
    
    local retval, retvals_csv = reaper.GetUserInputs(input_title, #vars_order, table.concat(instructions, "\n"), ConcatenateVarsVals()) 
    if retval then
      vars = ParseRetvalCSV(retvals_csv)
      if vars.value then
        vars.value = tonumber(vars.value)
      end
    else
      return
    end
  end

  if not popup or ValidateVals(vars) then
    reaper.Undo_BeginBlock()
    Main()
    if popup then
      SaveState()
    end
    reaper.Undo_EndBlock(undo_text, -1)
    reaper.UpdateArrange()
  end
end

if not preset_file_init then
  Init()
end
