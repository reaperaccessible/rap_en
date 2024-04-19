-- @description Note length set to half of current value
-- @version 1.1
-- @author Ludovic SANSONE for Reaper Accessible
-- @provides [main=midi_editor] .


reaper.Undo_BeginBlock()

local commandId = 40774
reaper.MIDIEditor_LastFocused_OnCommand(commandId, 0)
reaper.osara_outputMessage("Note length set to half of current value")


  reaper.Undo_EndBlock("Note length set to half of current value", 0) 
