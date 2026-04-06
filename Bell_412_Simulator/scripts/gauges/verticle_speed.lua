--Bell 412EP Vertical speed indicator--
-------------------------------------
--     Load and display images     --
-------------------------------------
img_add_fullscreen("bg.png")
img_add_fullscreen("VSI_Compose_Rose.png")
img_needle = img_add_fullscreen("VSI_Needle.png")

---------------
-- Functions --
---------------

function new_vsi(vsi)
    
    vsi = var_cap(vsi, -4000, 4000)  -- Changed the range to -4000 to 4000    
    if vsi > 3500 and vsi <= 4000 then
        rotate(img_needle, (12.5 / 500 * (vsi - 500)) + 92.5)      
    elseif vsi > 3000 and vsi <= 3500 then
        rotate(img_needle, (25 / 500 * (vsi - 500)) + 22.5)                     
    elseif vsi > 2000 and vsi <= 3000 then
        rotate(img_needle, (40 / 1000 * (vsi - 1000)) + 68)                        
    elseif vsi > 1000 and vsi <= 2000 then
        rotate(img_needle, (40 / 1000 * (vsi - 1000)) + 68)     
    elseif vsi > 500 and vsi <= 1000 then
        rotate(img_needle, (35 / 500 * (vsi - 500)) + 33)
    elseif vsi >= 0 and vsi <= 500 then
        rotate(img_needle, 33 / 500 * vsi)
-- Negtive Rotation         
    elseif vsi < 0 and vsi >= -500 then
        rotate(img_needle, 33 / 500 * vsi)        
    elseif vsi < -500 and vsi >= -1000 then
        rotate(img_needle, (35 / 500 * (vsi + 500)) - 33)        
    elseif vsi < -1000 and vsi >= -2000 then
        rotate(img_needle, (40 / 1000 * (vsi + 1000)) - 68)        
    elseif vsi < -2000 and vsi >= -3000 then
        rotate(img_needle, (40 / 1000 * (vsi + 1000)) - 68)
    elseif vsi < -3000 and vsi >= -3500 then
        rotate(img_needle, (25 / 500 * (vsi + 500))- 22.5)                 
    elseif vsi < -3500 and vsi >= -4000 then
        rotate(img_needle, (12.5 / 500 * (vsi + 500)) - 92.5)        
               
                     
    end
    
end

-------------------
-- Bus subscribe --
-------------------

fsx_variable_subscribe("VERTICAL SPEED", "Feet per minute", new_vsi)
