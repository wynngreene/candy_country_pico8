-- poacher.lua
poachers={}

function init_poachers()
 poachers={}
 add(poachers, make_poacher(80, 15*8-8))
end

function make_poacher(x,y)
 return {x=x,y=y,w=7,h=7,dir=1,v=0.6,hp=3,alive=true,stun=0}
end

function update_poachers()
 local p=player
 for e in all(poachers) do
  if e.alive then
   if e.stun>0 then
    e.stun-=1
   else
    local nx=e.x + e.v*e.dir
    local aheadx=(e.dir==1) and (nx+e.w+1) or (nx-1)
    if solid_at(aheadx,e.y) or solid_at(aheadx,e.y+e.h) then
     e.dir=-e.dir
    else
     e.x=nx
    end
   end

   if p.inv<=0 and aabb(p,e) then
    p.hp-=1
    p.inv=30
    p.vx=-e.dir*2.0
    p.vy=-1.5
    if p.hp<=0 then _init() return end
   end
  end
 end
end

function draw_poachers()
 for e in all(poachers) do
  if e.alive then
   rectfill(e.x,e.y,e.x+e.w,e.y+e.h,2)
   pset(e.x+3,e.y+1,8)
  end
 end
end

function try_hit_poachers()
 local hb=attack_box()
 for e in all(poachers) do
  if e.alive and aabb(hb,e) then
   e.hp-=1
   e.stun=10
   e.x+=player.face*6
   if e.hp<=0 then
    e.alive=false
    add_drop(e.x+3,e.y,1)
   end
  end
 end
end
