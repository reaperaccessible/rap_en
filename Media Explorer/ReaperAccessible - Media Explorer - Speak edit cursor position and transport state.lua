-- @description Speak edit cursor position and transport state
-- @version 1.1
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=mediaexplorer] .


local commandID = reaper.NamedCommandLookup("_OSARA_CURSORPOS")
reaper.Main_OnCommand(commandID, 0)
