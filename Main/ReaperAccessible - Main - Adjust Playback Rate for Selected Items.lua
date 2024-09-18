-- @description Adjust Playback Rate for Selected Items
-- @version 1.4
-- @author Lo-lo for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log


-- Start of undo block
reaper.Undo_BeginBlock()

-- Retrieve the number of selected items in the project
local num_selected_items = reaper.CountSelectedMediaItems(0)

-- Check if there are selected items
if num_selected_items > 0 then
    -- Ask for the playback rate of the first active take of the selected item
    local item = reaper.GetSelectedMediaItem(0, 0)
    local take = reaper.GetActiveTake(item)

    -- Check if there is an active take
    if take then
        local playrate = reaper.GetMediaItemTakeInfo_Value(take, "D_PLAYRATE")
        playrate = tostring(playrate)

        -- Ask the user to input a new playback rate
        local retval, user_input = reaper.GetUserInputs("Playback Rate", 1, "Playback Rate:", playrate)
        
        -- Check if the user confirmed the input
        if retval then
            -- Convert the user input to a number
            local new_playrate = tonumber(user_input)
            
            -- Check if the conversion was successful
            if new_playrate then
                -- Modify the playback rate of all takes of the selected items
                for i = 0, num_selected_items - 1 do
                    local item = reaper.GetSelectedMediaItem(0, i)
                    local take = reaper.GetActiveTake(item)
                    
                    -- Check if there is an active take
                    if take then
                        reaper.SetMediaItemTakeInfo_Value(take, "D_PLAYRATE", new_playrate)
                        reaper.UpdateItemInProject(item)
                    end
                end
            else
                -- Display a message box in case of invalid value
                reaper.ShowMessageBox("Invalid value. Please enter a valid number.", "", 0)
            end
        end
    end
else
    -- Display a message if there are no selected items
    reaper.ShowMessageBox("No selected items", "", 0)
end

-- End of undo block with specified message
reaper.Undo_EndBlock("Adjust Playback Rate", -1)
