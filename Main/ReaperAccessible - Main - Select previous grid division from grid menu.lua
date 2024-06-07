-- @description Select previous grid division from grid menu
-- @version 1.4
-- @author Ludovic SANSONE for Reaper Accessible
-- @provides [main=main] .


reaper.Undo_BeginBlock()

local ret, grid = reaper.GetSetProjectGrid(0, 0)

local dict = {
    {1.0, 4, "4 measures"},
    {2.0, 3, "3 measures"},
    {3.0, 2, "2 measures"},
    {4.0, 1, "1 measure"},
    {5.0, 1/2, "Half note, 1/2"},
    {6.0, 1/4, "Quarter note, 1/4"},
    {7.0, 1/8, "Eighth note, 1/8"},
    {8.0, 1/16, "Sixteenth note, 1/16"},
    {9.0, 1/32, "Thirty-second note, 1/32"},
    {10.0, 1/64, "Sixty-fourth note, 1/64"},
    {11.0, 1/128, "Hundred twenty-eighth note, 1/128"},
    {12.0, 2/3, "Whole note triplet, 2/3"},
    {13.0, 1/3, "Half note triplet, 1/3"},
    {14.0, 1/6, "Quarter note triplet, 1/16"},
    {15.0, 1/12, "Eighth note triplet, 1/12"},
    {16.0, 1/24, "Sixteenth note triplet, 1/24"},
    {17.0, 1/48, "Thirty-second note triplet, 1/48"},
    {18.0, 1/5, "Quintuplet of quarter notes, 1/5"},
    {19.0, 1/7, "Septuplet of quarter notes, 1/7"},
    {20.0, 1/9, "Ninelet, 1/9"},
    {21.0, 1/10, "Quintuplet of eighth notes, 1/10"},
    {22.0, 1/18, "Eighteenth-note, 1/18"}
}

function getNextDivision(g, d)
    for i = 1, 22 do
        if g == d[i][1] then
            if i == 1 then
                return d[22][1], d[22][2]
            end
            return d[i - 1][1], d[i - 1][2]
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
