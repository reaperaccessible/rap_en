-- @Description Set length note to 1/128
-- @version 1.0
-- @author Ludovic SANSONE for Reaper Accessible


reaper.Undo_BeginBlock()

local commandId = 41618
reaper.MIDIEditor_LastFocused_OnCommand(commandId, 0)
reaper.osara_outputMessage("Note length set to 1/128")

  reaper.Undo_EndBlock("Set note length to 1/128", 0) 
