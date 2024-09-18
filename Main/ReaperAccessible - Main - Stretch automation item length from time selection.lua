-- @description Stretch automation item length from time selection
-- @version 1.1
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log


local function Main()
  -- Get the time selection
  local tstart, tend = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
  if tstart == tend then
    reaper.ShowMessageBox("No active time selection", "Error", 0)
    return
  end

  local time_selection_length = tend - tstart
  local items_adjusted = 0
  local items_outside = 0
  local total_selected = 0

  -- Get the selected track
  local track = reaper.GetSelectedTrack(0, 0)
  if not track then
    reaper.ShowMessageBox("No track selected", "Error", 0)
    return
  end

  -- Count total selected automation items and those outside time selection
  for j = 0, reaper.CountTrackEnvelopes(track) - 1 do
    local env = reaper.GetTrackEnvelope(track, j)
    for i = 0, reaper.CountAutomationItems(env) - 1 do
      local selected = reaper.GetSetAutomationItemInfo(env, i, 'D_UISEL', 0, false) == 1
      if selected then
        total_selected = total_selected + 1
        local startTime = reaper.GetSetAutomationItemInfo(env, i, 'D_POSITION', 0, false)
        local length = reaper.GetSetAutomationItemInfo(env, i, 'D_LENGTH', 0, false)
        if startTime >= tend or startTime + length <= tstart then
          items_outside = items_outside + 1
        end
      end
    end
  end

  local adjust_all = false
  if items_outside > 0 then
    local user_choice = reaper.ShowMessageBox(
      string.format("%d out of %d selected automation item are outside the time selection. Do you want to adjust them as well?", 
      items_outside, total_selected),
      "Adjust all items?", 4)
    adjust_all = (user_choice == 6)  -- 6 is the return value for "Yes"
  end

  reaper.Undo_BeginBlock()

  -- Adjust automation items
  for j = 0, reaper.CountTrackEnvelopes(track) - 1 do
    local env = reaper.GetTrackEnvelope(track, j)
    for i = 0, reaper.CountAutomationItems(env) - 1 do
      local selected = reaper.GetSetAutomationItemInfo(env, i, 'D_UISEL', 0, false) == 1
      if selected then
        local startTime = reaper.GetSetAutomationItemInfo(env, i, 'D_POSITION', 0, false)
        local length = reaper.GetSetAutomationItemInfo(env, i, 'D_LENGTH', 0, false)
        
        if adjust_all or (startTime < tend and startTime + length > tstart) then
          items_adjusted = items_adjusted + 1
          -- Adjust the automation item to the time selection
          reaper.GetSetAutomationItemInfo(env, i, 'D_POSITION', tstart, true)
          reaper.GetSetAutomationItemInfo(env, i, 'D_LENGTH', time_selection_length, true)
          
          -- Adjust the start offset
          local offset = startTime - tstart
          local currentOffset = reaper.GetSetAutomationItemInfo(env, i, 'D_STARTOFFS', 0, false)
          reaper.GetSetAutomationItemInfo(env, i, 'D_STARTOFFS', currentOffset + offset, true)
        end
      end
    end
  end

  reaper.Undo_EndBlock('Adjust automation items to time selection', -1)
  reaper.UpdateArrange()

  -- Confirmation message
  local message
  if items_adjusted == total_selected then
    message = string.format("%d automation item adjusted to time selection.", items_adjusted)
  else
    message = string.format("%d out of %d automation item adjusted to time selection.", items_adjusted, total_selected)
  end
  reaper.osara_outputMessage(message)
end

if not pcall(Main) then
  reaper.ShowMessageBox("An error occurred while executing the script.", "Error", 0)
end