-- @description Displays a menu containing different automation actions
-- @version 1.0
-- @author Ludovic SANSONE for Reaper Accessible

gfx.init()

local selection = gfx.showmenu(
    "Load an automation Item\
    |Save automation item\
    |Toggle Automation item Loop\
    |Split selected automation items at markers\
    |Convert selected envelope points to automation item\
    |Move left edge of selected automation item to start of time selection\
    |Move right edge of selected automation item to end of time selection\
    |Select all automation items of selected track\
    |Select all automation items on all tracks\
    |Set selected envelope points to the value of first selected point\
    |Always create new automation items when writing automation")

local dict = {
    {1.0, "42093"},
    {2.0, "42092"},
    {3.0, "42196"},
    {4.0, "_RS228a4c1fe72b2a649b5deb1a0c8dfac0c57c8750"},
    {5.0, "_RSabf19e90e348b69ffb51c544a98a1cedde6ce877"},
    {6.0, "_RSb75971e5f828aa69bf08446278231df54f4a3ec1"},
    {7.0, "_RS71efd90e17faa972113a464d9a3f067bfb39f785"},
    {8.0, "_RS4f9a1b8a81622baa6698c7b9356afca9f7898a65"},
    {9.0, "_RSb9ac85b4e92a33bcc8106c79a97063f61cd846bc"},
    {10.0, "_BR_SET_ENV_TO_FIRST_SEL_VAL"},
    {11.0, "42212"}
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
