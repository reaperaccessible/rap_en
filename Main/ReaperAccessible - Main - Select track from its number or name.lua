-- @Description Select track from its number or name
-- @version 1.2
-- @author Ludovic SANSONE for Reaper Accessible
-- @provides [main=main] .


-- Function to announce the window opening message
function announceOpeningMessage()
    reaper.osara_outputMessage("Track Search: Enter a name or track number and press Enter.")
end

-- Call the function to announce the window opening message
announceOpeningMessage()

-- Function to select a track based on its number
function selectTrackFromNumber(trackNumber)
    local trackIndex = tonumber(trackNumber) - 1
    if trackIndex and trackIndex >= 0 and trackIndex < reaper.CountTracks(0) then
        local track = reaper.GetTrack(0, trackIndex)
        reaper.SetOnlyTrackSelected(track)
        reaper.osara_outputMessage("Track #" .. trackNumber .. " selected.")
    else
        reaper.osara_outputMessage("Invalid track number.")
    end
end

-- Function to select a track based on its name (case-insensitive)
function selectTrackFromName(trackName)
    local track = ""
    local currentTrack = reaper.GetSelectedTrack(0, 0)

    -- Loop for the search from the currently selected track to the end
    for i = reaper.GetMediaTrackInfo_Value(currentTrack, "IP_TRACKNUMBER") - 1, reaper.CountTracks() - 1 do
        track = reaper.GetTrack(0, i)
        local _, name = reaper.GetTrackName(track)

        -- Case-insensitive comparison
        if string.lower(name) == string.lower(trackName) then
            reaper.SetOnlyTrackSelected(track)
            reaper.osara_outputMessage("Track '" .. trackName .. "' selected.")
            return
        end
    end

    -- Loop for the search from the beginning to the currently selected track
    for i = 0, reaper.GetMediaTrackInfo_Value(currentTrack, "IP_TRACKNUMBER") - 1 do
        track = reaper.GetTrack(0, i)
        local _, name = reaper.GetTrackName(track)

        -- Case-insensitive comparison
        if string.lower(name) == string.lower(trackName) then
            reaper.SetOnlyTrackSelected(track)
            reaper.osara_outputMessage("Track '" .. trackName .. "' selected.")
            return
        end
    end

    reaper.osara_outputMessage("No track found with the name '" .. trackName .. "'.")
end

-- Show the user input dialog, then get the user's input
local retval, reval_csv = reaper.GetUserInputs("Track Search", 1, 'number', '')

-- Check if the user input is empty or contains only spaces
if not retval or reval_csv:match("^%s*$") then
    reaper.osara_outputMessage("Operation canceled by the user or invalid input.")
else
    if not tonumber(reval_csv) then
        selectTrackFromName(reval_csv)
    else
        selectTrackFromNumber(reval_csv)
    end
end

-- Update the view
reaper.UpdateArrange()
