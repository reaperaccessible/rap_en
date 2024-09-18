-- @description Set length note to 1/2T
-- @version 1.2
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=midi_editor] .
-- @changelog
--   # 2024-09-18 - Adding log


reaper.Undo_BeginBlock()

local commandId = 41634
reaper.MIDIEditor_LastFocused_OnCommand(commandId, 0)
reaper.osara_outputMessage("Note length set to 1/2T")

  reaper.Undo_EndBlock("Set note length to 1/2T", 0) 
