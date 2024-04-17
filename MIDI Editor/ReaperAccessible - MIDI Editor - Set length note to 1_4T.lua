-- @Description Set length note to 1/4T
-- @version 1.0
-- @author Ludovic SANSONE for Reaper Accessible


reaper.Undo_BeginBlock()

local commandId = 41631
reaper.MIDIEditor_LastFocused_OnCommand(commandId, 0)
reaper.osara_outputMessage("Note length set to 1/4T")

  reaper.Undo_EndBlock("Set note length to 1/4T", 0) 
