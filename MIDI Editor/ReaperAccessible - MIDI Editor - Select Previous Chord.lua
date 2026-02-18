-- @description Select Previous Chord
-- @version 1.1
-- @author Lee JULIEN pour ReaperAccessible augmented by Chessel
-- @provides [main=midi_editor] .
-- @changelog
--   #2026-02-17 - New script
--   #2026-02-18 - Bug fix


local tolerance = 15 

function Announce(message)
    reaper.osara_outputMessage(message)
end

local editor = reaper.MIDIEditor_GetActive()
if not editor then return end
local take = reaper.MIDIEditor_GetTake(editor)
if not take or not reaper.TakeIsMIDI(take) then return end

-- Get current cursor position in PPQ
local cursor_time = reaper.GetCursorPosition()
local currentPos = reaper.MIDI_GetPPQPosFromProjTime(take, cursor_time)
local _, noteCount = reaper.MIDI_CountEvts(take)
local starts = {}
local groups = {}

-- 1. Analyze positions (searching backwards)
for i = 0, noteCount - 1 do
    local _, _, _, s = reaper.MIDI_GetNote(take, i)
    -- Look for notes BEFORE the cursor (with a small 5 PPQ safety margin)
    if s < currentPos - 5 then
        local key = math.floor(s / tolerance + 0.5) * tolerance
        if not groups[key] then
            groups[key] = 0
            table.insert(starts, key)
        end
        groups[key] = groups[key] + 1
    end
end

-- Sort descending to find the closest chord while moving backwards
table.sort(starts, function(a,b) return a > b end)

local targetStart = nil
for _, s in ipairs(starts) do
    if groups[s] >= 2 then
        targetStart = s
        break
    end
end

if not targetStart then
    Announce("No previous chord found")
    return
end

-- 2. Update Selection
reaper.MIDI_DisableSort(take) -- Disable sorting to prevent index errors during loop

for i = 0, noteCount - 1 do
    -- Retrieve all note data to preserve integrity
    local _, selected, muted, startppq, endppq, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
    
    -- If note start is within target chord tolerance
    if math.abs(startppq - targetStart) <= tolerance then
        -- Force selection to TRUE, keep everything else identical
        reaper.MIDI_SetNote(take, i, true, muted, startppq, endppq, chan, pitch, vel, false)
    else
        -- Otherwise deselect
        reaper.MIDI_SetNote(take, i, false, muted, startppq, endppq, chan, pitch, vel, false)
    end
end

-- 3. Finalization
reaper.MIDI_Sort(take) -- Re-enable sorting and clean up MIDI data
reaper.SetEditCurPos(reaper.MIDI_GetProjTimeFromPPQPos(take, targetStart), true, false)
reaper.UpdateArrange()

Announce("Chord with " .. groups[targetStart] .. " notes selected")