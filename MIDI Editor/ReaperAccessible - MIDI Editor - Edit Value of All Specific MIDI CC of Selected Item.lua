-- @description Edit Value of All Specific MIDI CC of Selected Item
-- @version 1.0
-- @author Lee JULIEN pour ReaperAccessible augmented by Chessel
-- @provides [main=midi_editor] .
-- @changelog
--   #2026-02-18 - Nouveau script


function Main()
    local midi_editor = reaper.MIDIEditor_GetActive()
    local take = reaper.MIDIEditor_GetTake(midi_editor)
    
    if not take then 
        reaper.ShowMessageBox("Error: No MIDI editor open.", "Action Interrupted", 0)
        return 
    end

    -- 1. Input Window
    local retval, retvals_csv = reaper.GetUserInputs("Modify All CCs", 2, "MIDI CC Number (0-127):,New Value (0-127):", "")
    if not retval then return end 

    local cc_input, val_input = retvals_csv:match("([^,]*),([^,]*)")
    local cc_target = tonumber(cc_input)
    local val_target = tonumber(val_input)

    -- 2. Validation
    if not cc_target or cc_target < 0 or cc_target > 127 then
        reaper.ShowMessageBox("Protocol Error: CC must be 0-127.", "Error", 0)
        return
    end

    if not val_target or val_target < 0 or val_target > 127 then
        reaper.ShowMessageBox("Value Error: Value must be 0-127.", "Error", 0)
        return
    end

    -- 3. MIDI Processing
    reaper.Undo_BeginBlock()
    local _, _, cccount, _ = reaper.MIDI_CountEvts(take)
    local changes_made = 0

    for i = 0, cccount - 1 do
        local _, _, _, _, _, _, msg2, _ = reaper.MIDI_GetCC(take, i)
        if msg2 == cc_target then
            reaper.MIDI_SetCC(take, i, nil, nil, nil, nil, nil, nil, val_target, false)
            changes_made = changes_made + 1
        end
    end

    reaper.Undo_EndBlock("Modify CC " .. cc_target, -1)
    reaper.UpdateArrange()

    -- 4. Result Message
    local result_msg = ""
    if changes_made > 0 then
        result_msg = "Success! CC " .. cc_target .. " set to " .. val_target .. " (" .. changes_made .. " events)."
    else
        result_msg = "No events found for CC " .. cc_target
    end
    
    reaper.ShowMessageBox(result_msg, "Result", 0)

    -- 5. FORCING FOCUS (Improved method)
    -- We use a defer loop to ensure focus is applied AFTER the message box is fully gone
    local function RestoreFocus()
        if midi_editor then
            reaper.BR_Win32_SetFocus(midi_editor) -- SWS/Breeder method
            reaper.SN_FocusMIDIEditor()           -- SWS method
        end
    end
    
    reaper.defer(RestoreFocus)
end

Main()