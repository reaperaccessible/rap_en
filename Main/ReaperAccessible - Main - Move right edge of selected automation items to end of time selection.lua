-- @description Move right edge of selected automation items to end of time selection
-- @version 1.3
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log


-- Define constants
local UNDO_STATE_TRACKCFG = 1
-- Get the script name from the full path
local script_name = ({reaper.get_action_context()})[2]:match("([^/\\_]+).lua$")

local function Main()
  -- Get the time selection
  local tstart, tend = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
  if tstart == tend then
    reaper.ShowMessageBox("No active time selection", "Error", 0)
    return
  end

  local bucket = {}
  local items_moved = 0

  -- Iterate through all tracks in the project
  for i = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, i)
    
    -- Iterate through all envelopes of the track
    for j = 0, reaper.CountTrackEnvelopes(track) - 1 do
      local env = reaper.GetTrackEnvelope(track, j)
      
      -- Iterate through all automation items of the envelope
      for k = 0, reaper.CountAutomationItems(env) - 1 do
        local selected = reaper.GetSetAutomationItemInfo(env, k, 'D_UISEL', 0, false) == 1
        if selected then
          local startTime = reaper.GetSetAutomationItemInfo(env, k, 'D_POSITION', 0, false)
          local length = reaper.GetSetAutomationItemInfo(env, k, 'D_LENGTH', 0, false)
          items_moved = items_moved + 1
          
          -- Calculate the new position so that the item ends at the end of the selection
          local new_pos = tend - length
          local shift = new_pos - startTime
          
          table.insert(bucket, {env=env, id=k, pos=new_pos, shift=shift})
        end
      end
    end
  end

  if #bucket < 1 then
    reaper.ShowMessageBox("No automation items are selected.", "Error", 0)
    return
  end

  reaper.Undo_BeginBlock()
  for _, ai in ipairs(bucket) do
    -- Move the automation item
    reaper.GetSetAutomationItemInfo(ai.env, ai.id, 'D_POSITION', ai.pos, true)
    
    -- Adjust the start offset of the automation item
    local off = reaper.GetSetAutomationItemInfo(ai.env, ai.id, 'D_STARTOFFS', 0, false)
    reaper.GetSetAutomationItemInfo(ai.env, ai.id, 'D_STARTOFFS', off + ai.shift, true)
  end
  reaper.Undo_EndBlock(script_name, UNDO_STATE_TRACKCFG)
  
  reaper.UpdateArrange()

  -- Confirmation message
  local message
  if items_moved == 1 then
    message = "1 automation item moved to time selection end point"
  else
    message = string.format("%d automation items moved to time selection end point", items_moved)
  end
  reaper.osara_outputMessage(message)
end

if not pcall(Main) then
  reaper.ShowMessageBox("An error occurred while executing script.", "Error", 0)
end