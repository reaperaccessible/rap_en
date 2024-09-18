-- @description Select all notes and events in time selection
-- @version 1.1
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=midi_editor] .
-- @changelog
--   # 2024-09-18 - Adding log


reaper.Undo_BeginBlock()

local commandId = 40746
local commandId = 40875
reaper.MIDIEditor_LastFocused_OnCommand(commandId, 0)
reaper.osara_outputMessage("All notes and events in time selection are now selected")

reaper.Undo_EndBlock("Selection of all notes and events in time selection", 0) 
