-- ui.lua
debug=true

function init_ui() end
function update_ui() end

function draw_ui()
 camera(0,0)

 -- hud
 print("hp:"..player.hp,2,2,0)
 print("saved:"..saved,2,10,0)
 print("commod:"..commod,2,18,0)
 print("❌ atk  🅾️ act",2,120,0)

 -- debug overlay (toggle with UP)
 draw_debug()

 camera(camx,0)
end

function draw_debug()
 if not debug then return end

 local x0=78
 local y0=2

 rectfill(x0-2,y0-2,127,62,0)
 print("debug:on (up toggles)", x0, y0, 7); y0+=8

 print("state:"..state, x0, y0, 7); y0+=8
 print("px:"..flr(player.x).." py:"..flr(player.y), x0, y0, 7); y0+=8
 print("vx:"..fmt1(player.vx).." vy:"..fmt1(player.vy), x0, y0, 7); y0+=8
 print("ground:"..tostr(player.on_ground), x0, y0, 7); y0+=8
 print("poachers:"..#poachers, x0, y0, 7); y0+=8
 print("drops:"..#drops, x0, y0, 7)
end

function draw_title()
 cls(1)
 print("candy forest",38,46,7)
 print("protector vs poachers",18,58,6)
 print("press ❌/🅾️",40,80,7)
 print("tip: UP toggles debug", 26, 96, 5)
end

function draw_win()
 cls(1)
 print("forest safe!",44,50,7)
 print("saved:"..saved,48,66,7)
 print("commod:"..commod,44,74,7)
 print("press ❌/🅾️",40,96,7)
 print("up toggles debug", 34, 110, 5)
end

function check_win()
 local all_freed=true
 for c in all(cages) do
  if not c.freed then all_freed=false end
 end

 local any_alive=false
 for e in all(poachers) do
  if e.alive then any_alive=true end
 end

 if all_freed and (not any_alive) then state="win" end
end
