-- @description Speak edit cursor position and transport state
-- @version 1.2
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=mediaexplorer] .
-- @changelog
--   # 2024-09-18 - Adding log


local commandID = reaper.NamedCommandLookup("_OSARA_CURSORPOS")
reaper.Main_OnCommand(commandID, 0)
