-- @description Set item selection start point to delete, ripple all tracks
-- @version 1.2
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log


-- Sélection temporelle: Définir le point de début
reaper.Main_OnCommand(40625, 0)

-- Transport: Lecture
reaper.Main_OnCommand(1007, 0)

reaper.osara_outputMessage("Point de début ripple toute les pistes définie")
