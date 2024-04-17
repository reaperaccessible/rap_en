-- @Description Speak current division grid
-- @version 1.0
-- @author Ludovic SANSONE for Reaper Accessible


local dict = {
    {1.0, 4, "4 measures"},
    {2.0, 3, "3 measures"},
    {3.0, 2, "2 measures"},    
    {4.0, 1, "One measure"},
    {5.0, 1/2, "1/2"},
    {6.0, 1/4, "1/4"},
    {7.0, 1/8, "1/8"},
    {8.0, 1/16, "1/16"},
    {9.0, 1/32, "1/32"},
    {10.0, 1/64, "1/64"},
    {11.0, 1/128, "1/128"},
    {12.0, 2/3, "2/3"},
    {13.0, 1/3, "1/3"},
    {14.0, 1/6, "1/6"},
    {15.0, 1/12, "1/12"},
    {16.0, 1/24, "1/24"},
    {17.0, 1/48, "1/48"},
    {18.0, 1/5, "1/5"},
    {19.0, 1/7, "1/7"},
    {20.0, 1/9, "1/9"},
    {21.0, 1/10, "1/10"},
    {22.0, 1/18, "1/18"}        
}

function getDivision(projectGrid, d)
    for i = 1, 22 do
        if projectGrid == d[i][2] then
            return d[i][3]
        end
    end
    return "invalide"
end

local ret, grid = reaper.GetSetProjectGrid(0, 0)
local msg = getDivision(grid, dict)

reaper.osara_outputMessage("Grille définie " .. msg)
