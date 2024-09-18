-- @description Select next grid division from grid menu
-- @version 1.7
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log


reaper.Undo_BeginBlock()

local ret, grid = reaper.GetSetProjectGrid(0, 0)

local dict = {
    {4, "4 measures"},
    {3, "3 measures"},
    {2, "2 measures"},
    {1, "1 measure"},
    {1/2, "Half note, 1/2"},
    {1/4, "Quarter note, 1/4"},
    {1/8, "Eighth note, 1/8"},
    {1/16, "Sixteenth note, 1/16"},
    {1/32, "Thirty-second note, 1/32"},
    {1/64, "Sixty-fourth note, 1/64"},
    {1/128, "Hundred twenty-eighth note, 1/128"},
    {2/3, "Whole note triplet, 2/3"},
    {1/3, "Half note triplet, 1/3"},
    {1/6, "Quarter note triplet, 1/16"},
    {1/12, "Eighth note triplet, 1/12"},
    {1/24, "Sixteenth note triplet, 1/24"},
    {1/48, "Thirty-second note triplet, 1/48"},
    {1/5, "Quintuplet of quarter notes, 1/5"},
    {1/7, "Septuplet of quarter notes, 1/7"},
    {1/9, "Ninelet, 1/9"},
    {1/10, "Quintuplet of eighth notes, 1/10"},
    {1/18, "Eighteenth-note, 1/18"}
}

function getNextDivision(g, d)
    for i = 1, 22 do
        if g == d[i][1] then
            if i == 22 then
                return d[1][1], d[1][2]
            end
            return d[i + 1][1], d[i + 1][2]
        end
    end
    return 0, "invalid"
end

local division, msg = getNextDivision(grid, dict)
if division > 0 then
    reaper.SetProjectGrid(0, division)
    reaper.SetMIDIEditorGrid(0, division)
    reaper.osara_outputMessage(msg .. " is set as grid division value")
end

  reaper.Undo_EndBlock("Cannot undo this action", 0) 
