-- @description Toggle bind loop points to time selection
-- @version 1.1
-- @author Ludovic SANSONE for Reaper Accessible
-- @provides [main=main] .


reaper.Undo_BeginBlock()

reaper.Main_OnCommand(40621, 0)

local state = reaper.GetToggleCommandStateEx(0, 40621)

if state == 1 then
    reaper.osara_outputMessage("Loop points linked to time selection")
else
    reaper.osara_outputMessage("Loop points unlinked from time selection")
end

reaper.Undo_EndBlock("Toggle, link loop points and time selection points", 0) 
