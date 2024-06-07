-- @description Select item from its number
-- @version 1.1
-- @author Lo-lo for ReaperAccessible. 
-- @provides [main=main] .


-- OSARA: Ignore the next OSARA message
reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_OSARA_MUTENEXTMESSAGE"), 0, 0)

-- Select the next item
reaper.Main_OnCommand(40416, 0)

-- OSARA: Ignore the next OSARA message
reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_OSARA_MUTENEXTMESSAGE"), 0, 0)

-- Select the previous item
reaper.Main_OnCommand(40417, 0)

-- Function to count items in the active track
local function CountItemsInTrack(track)
    return reaper.CountTrackMediaItems(track)
end

-- Main function
local function Main()
    -- Get the active track
    local track = reaper.GetSelectedTrack(0, 0)
    
    -- Check if a track is selected
    if not track then
        reaper.osara_outputMessage("No track selected.\n")
        return
    end
    
    -- Get the number of items in the track
    local itemCount = CountItemsInTrack(track)
    
    -- Check if there are items in the track
    if itemCount == 0 then
        reaper.osara_outputMessage("No items on this track.\n")
        return
    end
    
    -- Ask the user to input an item number
    local userOK, userInput = reaper.GetUserInputs("Select an item", 1, "Item number (1-" .. itemCount .. "):", "")
    
    -- Check if the user canceled
    if not userOK then
        return
    end
    
    -- Check if the user input is empty
    if userInput == "" then
        reaper.osara_outputMessage("No number entered.\n")
        return
    end
    
    -- Convert user input to a number
    local searchNumber = tonumber(userInput)
    
    -- Check if the user input is a valid number
    if not searchNumber or searchNumber < 1 or searchNumber > itemCount then
        reaper.osara_outputMessage("Invalid item number.\n")
        return
    end
    
    -- Get the item corresponding to the entered number
    local item = reaper.GetTrackMediaItem(track, searchNumber - 1) -- Subtract 1 because item indices start from 0
    
    -- Check if the item is valid
    if item then
        -- Get the position of the item
        local itemPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        
        -- Set the edit cursor to the beginning of the item
        reaper.SetEditCurPos(itemPos, true, false)
        
        -- Set the play cursor to the position of the item if the project is playing
        if reaper.GetPlayState() & 1 == 1 then
            reaper.SetEditCurPos(itemPos, true, true)
        end    
        
        -- Deselect all items
        reaper.SelectAllMediaItems(0, false)
        
        -- Select the found item
        reaper.SetMediaItemSelected(item, true)
    end
    
    -- Iterate through the items in the track to find the selected item
    for i = 0, itemCount - 1 do
        local currentItem = reaper.GetTrackMediaItem(track, i)
        if reaper.IsMediaItemSelected(currentItem) then
            local take = reaper.GetActiveTake(currentItem)
            local takeName = take and reaper.GetTakeName(take) or ""
            reaper.osara_outputMessage(string.format("Selected item: %d - %s\n", i + 1, takeName))
            break
        end
    end
end

-- Execute the main function
Main()
