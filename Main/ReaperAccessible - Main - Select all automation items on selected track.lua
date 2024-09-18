-- @description Select all automation items on selected track
-- @version 1.3
-- @author Lee Julien for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log


function main()
  local track = reaper.GetSelectedTrack(0, 0)
  if not track then
    reaper.osara_outputMessage("No track is selected.")
    return
  end

  local selected_env, selected_ai_index = nil, nil
  local env_count = reaper.CountTrackEnvelopes(track)

  -- Search for a selected automation item
  for i = 0, env_count - 1 do
    local env = reaper.GetTrackEnvelope(track, i)
    local ai_count = reaper.CountAutomationItems(env)
    for j = 0, ai_count - 1 do
      local is_selected = reaper.GetSetAutomationItemInfo(env, j, "D_UISEL", 0, false)
      if is_selected == 1 then
        selected_env = env
        selected_ai_index = j
        break
      end
    end
    if selected_env then break end
  end

  if not selected_env then
    reaper.osara_outputMessage("No automation item is selected.")
    return
  end

  -- Get the selected envelope type
  local retval, env_name = reaper.GetEnvelopeName(selected_env)

  local total_items = 0

  -- Select automation items of the same envelope type
  for i = 0, env_count - 1 do
    local env = reaper.GetTrackEnvelope(track, i)
    local retval, current_env_name = reaper.GetEnvelopeName(env)
    
    if current_env_name == env_name then
      local ai_count = reaper.CountAutomationItems(env)
      for j = 0, ai_count - 1 do
        reaper.GetSetAutomationItemInfo(env, j, "D_UISEL", 1, true)
        total_items = total_items + 1
      end
    end
  end

  reaper.osara_outputMessage(total_items .. " automation items selected for " .. env_name .. " envelope.")
end

reaper.PreventUIRefresh(1)
main()
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)