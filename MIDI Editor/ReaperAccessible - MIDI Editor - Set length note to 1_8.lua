-- @description Set length note to 1/8
-- @version 1.3
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=midi_editor] .
-- @changelog
--   # 2024-09-18 - Adding log


reaper.Undo_BeginBlock()

local commandId = 41629
reaper.MIDIEditor_LastFocused_OnCommand(commandId, 0)
reaper.osara_outputMessage("Note length set to 1/8")

  reaper.Undo_EndBlock("Set note length to 1/8", 0) 
