tail=0
new=0

img_add_fullscreen("com_nav_radio.png")

com1txt = txt_add("---.--", "size:48px; color: firebrick; halign: center;", 35, 24, 200, 60)
com2txt = txt_add("---.--", "size:48px; color: firebrick; halign: center;", 35, 86, 200, 60)
nav1txt = txt_add("---.--", "size:48px; color: firebrick; halign: center;", 260, 24, 200, 60)
nav2txt = txt_add("---.--", "size:48px; color: firebrick; halign: center;", 260, 86, 200, 60)
      

        

                          
local multi_knob = user_prop_add_boolean("Multi-Knob", true, "If it should have a major and minor knob.")
local knob_push_button = user_prop_add_boolean("Push Button Knob", true, "Does the knob also have a push button")
local button_text = user_prop_add_string("Knob Description", "", "Description shown under the knob.")
local center_knob_text = user_prop_add_string("Knob Text", "PUSH", "Text in center of knob, if its a push button knob.")
local major_ccw = user_prop_add_string("Major Knob CCW Command", "", "The command you want to assign to the major knob, turning counter clock-wise.")
local major_cw = user_prop_add_string("Major Knob CW Command", "", "The command you want to assign to the major knob, turning clock-wise.")
local minor_ccw = user_prop_add_string("Minor Knob CCW Command", "", "The command you want to assign to the minor knob, turning counter clock-wise.")
local minor_cw = user_prop_add_string("Minor Knob CW Command", "", "The command you want to assign to the minor knob, turning clock-wise.")
local minor_pressed_cmd = user_prop_add_string("Button Press Command", "", "Command to run when you push the minor knob.")


function major_callback(direction)
    if direction == 1 then -- clockwise
        xpl_command(user_prop_get(major_cw))
        
        new=new+1
        
            
     else 
        xpl_command(user_prop_get(major_ccw))
        new=new-1    
    end



    new=new
    print (new)
     txt_set(com1txt, string.format("%.04s", new*1) )
end




function minor_callback(direction)
    if direction == 1 then -- clockwise
        print("ok")
    else
       print("ok")
    end
end






function knob_pressed_callback()
    
    button_held_timer_id_1 = timer_start(500, 0, knob_held_callback)
    txt_set(com2txt, string.format("%.04s", "ON") )
    
    print("ON")
end
function knob_held_callback()
   
     timer_stop(button_held_timer_id_1) --should already be stopped, but just in case.
     emer= false 
     txt_set(com2txt, string.format("%.04s", "ON") )
     print("On")
end

function knob_released_callback()
    
     timer_stop(button_held_timer_id_1) --should already be stopped, but just in case.
     if emer==false  then emer= true and
     txt_set(com2txt, string.format("%.04s", "OFF") )
     print("off")
     else 
     emer=false
     txt_set(com2txt, string.format("%.04s", "ON") )
     print ("on")
     end
     print (emer)
end
emer=emer
print (emer)
new_elv=0
new_alr=0
new_col=0
new_rd=0
rd=0
Thr=0
NG=0
function callback(type, index, value)
    if value == true then value = "true"
    elseif value == false then value = "false" end
         print("Type = " .. type .. ", Index = " .. index .. ", Value = " .. value)
            if  index==1 then
            new_elv= value
            --print("elv"..new_elv)
        elseif index==0 then
            new_alr=value
            --print("alr"..new_alr)
    elseif index==5 then
            new_col=value
            print("col"..new_col)
    elseif index==2 then
            new_rd=value
            print("rd"..new_rd)          
            end
rd()
end
 
               
function call_back(thr,ng,as)
    Thr=thr
    NG=ng
    AS=as
    -- print ("thr"..Thr)
   -- print ("ng"..NG) 
end
    
function rd()
if emer==false then 
    new_rd = new/100
    print ("emer on")
    else
    new_rd=new_rd 
    print ("emer off")       
end 
new_rd=new_rd
print ("new_rd"..new_rd)             
    if NG>60 then
    print ("NG"..NG)
    R=new_rd+(Thr/130)-(AS/150)
    print ("RD"..R)
    fsx_variable_write("RUDDER POSITION", "position", R)
    else 
    print("ng low")
    R=new_rd-(AS/110)
    fsx_variable_write("RUDDER POSITION", "position", R)
    end
end


    list = game_controller_list()
for k, v in pairs(list) do
    print(v)
    --if v == "vJoy Device" then game_controller_add(v, callback)
  if v == "vJoy Device" then game_controller_add(v, callback)
   elseif v == "Logitech Extreme 3D" then game_controller_add(v, callback) end
    end
    --end
    --end
fsx_variable_subscribe("GENERAL ENG THROTTLE LEVER POSITION:1", "percent","TURB ENG N1:1", "Percent","AIRSPEED INDICATED", "knots", call_back)


dial_major = dial_add("efis_knob.png", 180, 30, 135, 135, major_callback)
dial_minor = dial_add("alt_knob.png", 201, 52, 90, 90, 1, minor_callback)
dial_button = button_add("knob-button.png", "knob-button.png", 217, 67, 60, 60, knob_pressed_callback, knob_released_callback)
--dial_button = button_add("knob-button.png", "knob-button.png", 217, 67, 60, 60, knob_released_callback)
--dial_button = button_add("knob-button.png", "knob-button.png", 217, 67, 60, 60, knob_held_callback) 
txt_add(user_prop_get(button_text), "font:inconsolata_bold.ttf; size:18; color: red; halign:center;", 10, 170, 150, 20)
center_txt = txt_add(user_prop_get(center_knob_text), "font:inconsolata_bold.ttf; size:30; color: firebrick; halign:center;", 171, 80, 150, 30)

visible(center_txt, user_prop_get(knob_push_button))
visible(dial_button, user_prop_get(knob_push_button))
visible(dial_minor, user_prop_get(multi_knob))
opacity(dial_button, 100.0)