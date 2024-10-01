-- @description Select all MIDI CC events specified by user of selected items
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=midi_editor] .
-- @changelog
--   # 2024-09-24 - New script


-- Fonction pour énoncer un message via OSARA
function speak(message)
  reaper.osara_outputMessage(message)
end

-- Fonction pour vérifier si un item est MIDI
function isMIDITake(take)
  return take and reaper.TakeIsMIDI(take)
end

-- Fonction pour obtenir le numéro CC de l'utilisateur
function getCCNumber()
  local retval, userInput = reaper.GetUserInputs("Sélection CC MIDI", 1, "Entrez le numéro CC (1-127):", "")
  if not retval then return nil end
  
  local ccNumber = tonumber(userInput)
  if not ccNumber or ccNumber < 1 or ccNumber > 127 or math.floor(ccNumber) ~= ccNumber then
    speak("Please enter a valid number between 1 and 127.")
    return nil
  end
  
  return ccNumber
end

-- Fonction pour sélectionner les CC dans un take
function selectCC(take, ccNumber)
  local _, ccCount = reaper.MIDI_CountEvts(take)
  local selectedCount = 0
  
  reaper.MIDI_DisableSort(take)
  
  -- Désélectionner tous les événements
  reaper.MIDI_SelectAll(take, false)
  
  for i = 0, ccCount - 1 do
    local _, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(take, i)
    if chanmsg == 176 and msg2 == ccNumber then -- 176 est le statut pour les CC
      reaper.MIDI_SetCC(take, i, true, nil, nil, nil, nil, nil, nil, false)
      selectedCount = selectedCount + 1
    end
  end
  
  reaper.MIDI_Sort(take)
  
  return selectedCount
end

-- Fonction principale
function main()
  local ccNumber = getCCNumber()
  if not ccNumber then return end
  
  local itemCount = reaper.CountSelectedMediaItems(0)
  if itemCount == 0 then
    speak("No item is selected")
    return
  end
  
  local totalSelectedCC = 0
  local midiItemCount = 0
  
  for i = 0, itemCount - 1 do
    local item = reaper.GetSelectedMediaItem(0, i)
    local take = reaper.GetActiveTake(item)
    
    if isMIDITake(take) then
      midiItemCount = midiItemCount + 1
      totalSelectedCC = totalSelectedCC + selectCC(take, ccNumber)
    end
  end
  
  if midiItemCount == 0 then
    speak("No MIDI item selected")
  elseif totalSelectedCC == 0 then
    speak("No MIDI CC events matching this number were found.")
  else
    speak(string.format("%d selected MIDI CC events", totalSelectedCC))
  end
  
  reaper.UpdateArrange()
end

-- Lancer le script
reaper.defer(main)