-- @description Display RS5K menu
-- @version 1.4
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log


gfx.init()

local selection = gfx.showmenu(
    "Export each selected items to RS5K instances (Drum mode)\
    |Export each selected items to RS5K instances (Loop mode)\
    |Export each selected items to RS5K instances, on selected track (Round robin mode)\
    |Export each selected items to RS5K instances, (Keyboard mode).lua\
    |Export selected item to RS5K instance, with same sample on all notes\
    |Export selected item to RS5K instance, as chromatic source")

local dict = {
    {1.0, "_RS2e7a43e760f963457c56e401372bf5df76417c5d"},
    {2.0, "_RSac525e086c13874622f871f9440ff7f1d25ecbc7"},
    {3.0, "_RSec54c6d01fd2b48967b8ea526c30e33f5ea758ab"},
    {4.0, "_RSb1f7c9026afb6670c6eea3cab0377770541e3ee2"},
    {5.0, "_RS8154fa3af83eda5b5a99958a0f75fa3a0c7c7d7b"},
    {6.0, "_RSd7b9d5f894af73cfe10afeb9945221bbd238fe42"},
}

function getCoommandID(sel, d)
    for i = 1, #d do
        if sel == d[i][1] then
            return d[i][2]
        end
    end
    return ""
end

local commandID = getCoommandID(selection, dict)

if commandID == "" then
    return
else
    local reaperCommandID = reaper.NamedCommandLookup(commandID)
    reaper.Main_OnCommand(reaperCommandID, 0)
    return
end

gfx.quit()  
