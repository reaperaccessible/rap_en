-- @description Set length note to 1/4
-- @version 1.1
-- @author Ludovic SANSONE for Reaper Accessible
-- @provides [main=midi_editor] .


reaper.Undo_BeginBlock()

local commandId = 41632
reaper.MIDIEditor_LastFocused_OnCommand(commandId, 0)
reaper.osara_outputMessage("Note length set to 1/4")

  reaper.Undo_EndBlock("Set note length to 1/4", 0) 
