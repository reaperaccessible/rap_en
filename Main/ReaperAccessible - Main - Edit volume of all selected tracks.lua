-- @description Edit volume of all selected tracks
-- @version 1.4
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
-- # 2024-09-18 - Adding log
-- # 2025-02-13 - Adding several features


-- Count the number of selected tracks
local CountSelTrack = reaper.CountSelectedTracks(0)

-- Check if any tracks are selected
if CountSelTrack == 0 then
    reaper.osara_outputMessage("No track is selected")
    return
end

-- Prompt for volume input
local retval, preset = reaper.GetUserInputs("Enter volume for selected tracks", 1, "", "")

-- Check if the volume is valid
if not tonumber(preset) then
    reaper.osara_outputMessage("Invalid input value")
    return
end

-- If the user confirmed the volume
if retval then
    -- Ask if empty tracks should be included with a Yes/No dialog
    local includeEmpty = reaper.MB("Do you want to include tracks without items?", "Include empty tracks", 4)
    
    -- 6 = Yes button, 7 = No button
    includeEmpty = (includeEmpty == 6)
    
    -- Tables to store modified, unmodified, and unchanged track numbers
    local modifiedTracks = {}
    local unmodifiedTracks = {}
    local unchangedTracks = {}  -- New table for tracks whose volume remains the same
    
    -- Calculate the new volume once
    local newVolume = 10^(tonumber(preset) / 20)
    
    -- Iterate through selected tracks
    for i = 1, CountSelTrack do
        local SelTrack = reaper.GetSelectedTrack(0, i - 1)
        
        -- Get the track number and convert to integer
        local trackNumber = math.floor(reaper.GetMediaTrackInfo_Value(SelTrack, "IP_TRACKNUMBER"))
        
        -- Count the number of items on the track
        local itemCount = reaper.CountTrackMediaItems(SelTrack)
        
        -- Get the current track volume
        local currentVolume = reaper.GetMediaTrackInfo_Value(SelTrack, "D_VOL")
        
        -- Check if the track should be processed
        if includeEmpty or itemCount > 0 then
            -- Check if the volume is different
            if math.abs(currentVolume - newVolume) > 0.000001 then  -- Small margin of error for decimal comparisons
                -- Apply the new volume
                reaper.SetMediaTrackInfo_Value(SelTrack, "D_VOL", newVolume)
                -- Add the track number to the modified tracks table
                table.insert(modifiedTracks, tostring(trackNumber))
            else
                -- The volume remains unchanged
                table.insert(unchangedTracks, tostring(trackNumber))
            end
        else
            -- Track not processed (no items and "No" option selected)
            table.insert(unmodifiedTracks, tostring(trackNumber))
        end
    end
    
    -- Prepare the final message
    local message = ""
    
    -- Message for modified tracks
    if #modifiedTracks > 0 then
        if #modifiedTracks == 1 then
            message = "Volume changed for track " .. modifiedTracks[1]
        else
            message = "Volume changed for tracks " .. table.concat(modifiedTracks, ", ")
        end
    end
    
    -- Add message for unchanged tracks (same volume)
    if #unchangedTracks > 0 then
        if message ~= "" then message = message .. ". " end
        if #unchangedTracks == 1 then
            message = message .. "Track " .. unchangedTracks[1] .. " was already set to this volume"
        else
            message = message .. "Tracks " .. table.concat(unchangedTracks, ", ") .. " were already set to this volume"
        end
    end
    
    -- Add message for unmodified tracks (no items)
    if #unmodifiedTracks > 0 then
        if message ~= "" then message = message .. ". " end
        if #unmodifiedTracks == 1 then
            message = message .. "Track " .. unmodifiedTracks[1] .. " was not modified as it was already set to this volume"
        else
            message = message .. "Tracks " .. table.concat(unmodifiedTracks, ", ") .. " were not modified as they were already set to this volume"
        end
    end
    
    -- If no message was created
    if message == "" then
        message = "No track was modified"
    end
    
    -- Announce the message
    reaper.osara_outputMessage(message)
    
    -- Register the action in the undo history
    reaper.Undo_OnStateChangeEx("Set volume for selected track(s)", -1, -1)
end
