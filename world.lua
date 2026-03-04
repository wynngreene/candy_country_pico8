-- world.lua
camx=0

function init_world()
 camx=0
end

function update_world()
 -- camera is set after player update
end

function draw_world()
 cls(12)
 map(0,0,0,0,128,32)
 camera(camx,0)
end

function set_camera_to_player()
 camx=flr(player.x-64)
 if camx<0 then camx=0 end
 camera(camx,0)
end

function solid_at(px,py)
 local tx=flr(px/8)
 local ty=flr(py/8)
 local t=mget(tx,ty)
 return t==1 -- TEMP: treat tile 1 as solid ground
end
