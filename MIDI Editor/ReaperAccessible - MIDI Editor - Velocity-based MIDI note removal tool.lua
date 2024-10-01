-- @description Velocity-based MIDI note removal tool
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=midi_editor] .
-- @changelog
--   # 2024-09-24 - New script


local r = reaper

-- Function to do nothing (used for defer)
local function nothing() end

-- Function to end the script
local function endScript()
    r.defer(nothing)
end

-- Function to speak a message
local function speak(message)
    r.osara_outputMessage(message)
end

-- Get active MIDI take
local take = r.MIDIEditor_GetTake(r.MIDIEditor_GetActive())
if not take then
    speak("No active MIDI editor.")
    endScript()
    return
end

-- Count notes in the take
local _, notes = r.MIDI_CountEvts(take)
if notes == 0 then
    speak("No notes in the MIDI take.")
    endScript()
    return
end

-- Ask user for velocity, deletion mode, and note selection
local retval, user_input = r.GetUserInputs("Velocity-based MIDI note removal tool", 3, 
    "Velocity (1-127),Mode (0=below, 1=above),Apply to all notes or selected notes? 0 for all, 1 for selected:",
    "64,0,0")
if not retval then endScript() return end

local vel_threshold, mode, selection_mode = user_input:match("(%d+),(%d+),(%d+)")
vel_threshold = tonumber(vel_threshold)
mode = tonumber(mode)
selection_mode = tonumber(selection_mode)

-- Validate user input
if not vel_threshold or vel_threshold < 1 or vel_threshold > 127 or 
   not mode or (mode ~= 0 and mode ~= 1) or
   not selection_mode or (selection_mode ~= 0 and selection_mode ~= 1) then
    speak("Invalid input. Please enter correct values.")
    endScript()
    return
end

-- Count notes and selected notes
local total_notes = 0
local selected_notes = 0
for i = 0, notes - 1 do
    local _, selected = r.MIDI_GetNote(take, i)
    total_notes = total_notes + 1
    if selected then
        selected_notes = selected_notes + 1
    end
end

-- Check if notes are selected when selection_mode is 1
if selection_mode == 1 and selected_notes == 0 then
    speak("No notes are selected. Please select notes and try again.")
    endScript()
    return
end

-- Start editing operation
r.Undo_BeginBlock()
r.PreventUIRefresh(1)

-- Disable MIDI sorting for better performance
r.MIDI_DisableSort(take)

-- Iterate and delete notes
local deleted_count = 0
for i = notes - 1, 0, -1 do
    local _, selected, _, _, _, _, _, vel = r.MIDI_GetNote(take, i)
    if (selection_mode == 0 or (selection_mode == 1 and selected)) then
        if (mode == 0 and vel < vel_threshold) or (mode == 1 and vel > vel_threshold) then
            r.MIDI_DeleteNote(take, i)
            deleted_count = deleted_count + 1
        end
    end
end

-- Re-enable MIDI sorting
r.MIDI_Sort(take)

-- Update MIDI editor display (using named command)
r.Main_OnCommand(r.NamedCommandLookup("_ece8a6fac39bc343b9db27419a42cea7"), 0)

-- Announce result
if selection_mode == 0 then
    speak(string.format("%d notes deleted out of %d total notes", deleted_count, total_notes))
else
    speak(string.format("%d notes deleted out of %d selected notes", deleted_count, selected_notes))
end

-- End editing operation
r.PreventUIRefresh(-1)
r.Undo_EndBlock('Delete notes based on velocity', -1)