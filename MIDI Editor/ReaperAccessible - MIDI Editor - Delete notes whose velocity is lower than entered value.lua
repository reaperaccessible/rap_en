-- @description Delete notes whose velocity is lower than entered value
-- @version 1.0
-- @author Ludovic SANSONE for Reaper Accessible
-- @provides [main=midi_editor] .


local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

local take = r.MIDIEditor_GetTake(r.MIDIEditor_GetActive())
if not take then bla() return end

local _, notes = r.MIDI_CountEvts(take)
if notes == 0 then bla() return end


local retval, vel_del = r.GetUserInputs("Note erasure", 1, "Velocity at which the notes will be erased", "")
if retval ~= true then bla() return end

vel_del = tonumber(vel_del)
if not vel_del or vel_del < 1 then bla() return end

r.Undo_BeginBlock() r.PreventUIRefresh(1)

for i = notes-1, 0, -1 do
  local _,_,_,_,_,_,_, vel = r.MIDI_GetNote(take, i)
  if vel < vel_del then r.MIDI_DeleteNote(take, i) end
end
reaper.Main_OnCommand(reaper.NamedCommandLookup("_ece8a6fac39bc343b9db27419a42cea7"), 0)
reaper.osara_outputMessage("Notes deleted")

r.PreventUIRefresh(-1) r.Undo_EndBlock('Removing Notes', -1)
