-- @description Speak timebase of current project
-- @version 1.0
-- @author Lee JULIEN for Reaper Accessible
-- @provides [main=main] .


local function getCommandState(command)
    local commandID = reaper.NamedCommandLookup(command)
    return reaper.GetToggleCommandStateEx(0, commandID)
end

local function getProjectTimebase()
    if getCommandState("_SWS_AWTBASETIME") == 1 then
        return "Project timebase is time"
    elseif getCommandState("_SWS_AWTBASEBEATALL") == 1 then
        return "Project timebase is Beats (position, length, rate)"
    elseif getCommandState("_SWS_AWTBASEBEATPOS") == 1 then
        return "Project timebase is Beats (position only)"
    else
        return "Unknown project timebase"
    end
end

reaper.osara_outputMessage(getProjectTimebase())