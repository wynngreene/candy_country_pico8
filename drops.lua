-- drops.lua
drops={}
commod=0

function init_drops()
 drops={}
 commod=0
end

function add_drop(x,y,amt)
 add(drops,{x=x,y=y,w=3,h=3,vy=-1.2,t=0,amt=amt})
end

function update_drops()
 for d in all(drops) do
  d.t+=1
  d.vy+=0.2
  d.y+=d.vy

  -- temp floor stop (same row as test spawns)
  local floor_y=15*8-4
  if d.y>floor_y then
   d.y=floor_y
   d.vy*=-0.35
   if abs(d.vy)<0.2 then d.vy=0 end
  end

  if aabb(player,d) then
   commod+=d.amt
   del(drops,d)
  elseif d.t>600 then
   del(drops,d)
  end
 end
end

function draw_drops()
 for d in all(drops) do
  rectfill(d.x,d.y,d.x+d.w,d.y+d.h,9)
  if debug then rect(d.x,d.y,d.x+d.w,d.y+d.h,11) end
 end
end
