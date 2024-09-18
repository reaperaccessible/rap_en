-- @description Select all automation items of all tracks
-- @version 1.3
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log


function main()
  local total_items = 0
  local track_count = reaper.CountTracks(0)

  for i = 0, track_count - 1 do
    local track = reaper.GetTrack(0, i)
    local env_count = reaper.CountTrackEnvelopes(track)
    
    for j = 0, env_count - 1 do
      local env = reaper.GetTrackEnvelope(track, j)
      local ai_count = reaper.CountAutomationItems(env)
      
      for k = 0, ai_count - 1 do
        reaper.GetSetAutomationItemInfo(env, k, "D_UISEL", 1, true)
        total_items = total_items + 1
      end
    end
  end

  if total_items > 0 then
    reaper.osara_outputMessage(total_items .. " automation items selected across all tracks.")
  else
    reaper.osara_outputMessage("No automation items found on any track.")
  end
end

reaper.PreventUIRefresh(1)
main()
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)