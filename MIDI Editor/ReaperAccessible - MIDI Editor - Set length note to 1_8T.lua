-- @Description Set length note to 1/8T
-- @version 1.0
-- @author Ludovic SANSONE for Reaper Accessible


reaper.Undo_BeginBlock()

local commandId = 41628
reaper.MIDIEditor_LastFocused_OnCommand(commandId, 0)
reaper.osara_outputMessage("Note length set to 1 / 8T")

  reaper.Undo_EndBlock("Set note length to 1/8T", 0) 
