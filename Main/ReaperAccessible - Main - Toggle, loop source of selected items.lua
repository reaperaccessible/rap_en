-- @description Toggle loop source of selected items
-- @version 1.2
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log


reaper.Undo_BeginBlock()

-- On récupère le ou les objet sélectionnés
local it = reaper.GetSelectedMediaItem(0, 0)


local sourceState
if it then
-- On récupère l'état du bouclage de la source
    sourceState = reaper.GetMediaItemInfo_Value(it, 'B_LOOPSRC')
else
    return
end

-- On appelle l'action de Reaper basculant entre les 2 états
reaper.Main_OnCommand(40636, 0)

-- On énonce l'état courant
if sourceState == 1 then
    reaper.osara_outputMessage("Loop source deactivated")
else
    reaper.osara_outputMessage("Loop source activated")
end

reaper.Undo_EndBlock("Loop source of selected items", 0) 
