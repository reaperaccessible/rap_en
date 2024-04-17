-- @Description Speak edit cursor position and transport state
-- @version 1.0
-- @author Ludovic SANSONE for Reaper Accessible
-- @provides [main=mediaexplorer] .


local commandID = reaper.NamedCommandLookup("_OSARA_CURSORPOS")
reaper.Main_OnCommand(commandID, 0)
