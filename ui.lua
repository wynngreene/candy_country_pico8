-- ui.lua
function init_ui() end
function update_ui() end

function draw_ui()
 camera(0,0)
 print("hp:"..player.hp,2,2,0)
 print("saved:"..saved,2,10,0)
 print("commod:"..commod,2,18,0)
 print("❌ atk  🅾️ act",2,120,0)
 camera(camx,0)
end

function draw_title()
 cls(1)
 print("candy forest",38,46,7)
 print("protector vs poachers",18,58,6)
 print("press ❌/🅾️",40,80,7)
end

function draw_win()
 cls(1)
 print("forest safe!",44,50,7)
 print("saved:"..saved,48,66,7)
 print("commod:"..commod,44,74,7)
 print("press ❌/🅾️",40,96,7)
end

function check_win()
 local all_freed=true
 for c in all(cages) do if not c.freed then all_freed=false end end
 local any_alive=false
 for e in all(poachers) do if e.alive then any_alive=true end end
 if all_freed and (not any_alive) then state="win" end
end

debug=true

function draw_debug()
 if not debug then return end

 camera(0,0)

 print("x:"..player.x,90,2,7)
 print("y:"..player.y,90,10,7)
 print("vx:"..player.vx,90,18,7)
 print("vy:"..player.vy,90,26,7)

 print("state:"..state,90,34,7)
 print("poachers:"..#poachers,90,42,7)
 print("drops:"..#drops,90,50,7)

 camera(camx,0)
end

function draw_ui()
 camera(0,0)

 print("hp:"..player.hp,2,2,0)
 print("saved:"..saved,2,10,0)
 print("commod:"..commod,2,18,0)

 draw_debug()

 camera(camx,0)
end
