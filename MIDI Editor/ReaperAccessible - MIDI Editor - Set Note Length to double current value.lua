-- @Description Set note length to double current value
-- @version 1.0
-- @author Ludovic SANSONE for Reaper Accessible
-- @provides [main=midi_editor] .


reaper.Undo_BeginBlock()

local commandId = 40773
reaper.MIDIEditor_LastFocused_OnCommand(commandId, 0)
reaper.osara_outputMessage("Note length set to double current value")

      reaper.Undo_EndBlock("Note Length to double current value", 0)
