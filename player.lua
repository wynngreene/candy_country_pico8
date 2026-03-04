-- player.lua
grav=0.25
jump_v=-3.35
move_a=0.35
max_vx=1.65

function init_player()
 player={x=24,y=24,w=7,h=7,vx=0,vy=0,face=1,on_ground=false,hp=10,inv=0,atk_t=0}
end

function update_player()
 local p=player
 if p.inv>0 then p.inv-=1 end
 if p.atk_t>0 then p.atk_t-=1 end

 local ax=0
 if btn(0) then ax=-move_a p.face=-1 end
 if btn(1) then ax= move_a p.face= 1 end
 if ax==0 then p.vx*=0.80 else p.vx+=ax end
 p.vx=clamp(p.vx,-max_vx,max_vx)

 -- ❌ attack
 if btnp(4) and p.atk_t<=0 then
  p.atk_t=8
  try_hit_poachers()
 end

 -- 🅾️ action: free cage else jump
 if btnp(5) then
  if not try_free_cage() then
   if p.on_ground then
    p.vy=jump_v
    p.on_ground=false
   end
  end
 end

 p.vy+=grav
 p.vy=clamp(p.vy,-6,3)

 move_collide_x(p)
 move_collide_y(p)

 set_camera_to_player()
end

function move_collide_x(p)
 local nx=p.x+p.vx

 if p.vx>0 then
  local right=nx+p.w
  if solid_at(right,p.y) or solid_at(right,p.y+p.h) then
   p.vx=0
   nx=flr(right/8)*8 - p.w - 1
  end
 elseif p.vx<0 then
  local left=nx
  if solid_at(left,p.y) or solid_at(left,p.y+p.h) then
   p.vx=0
   nx=flr(left/8+1)*8
  end
 end

 p.x=nx
end

function move_collide_y(p)
 local ny=p.y+p.vy
 p.on_ground=false

 if p.vy>0 then
  local bottom=ny+p.h
  if solid_at(p.x,bottom) or solid_at(p.x+p.w,bottom) then
   p.vy=0
   p.on_ground=true
   ny=flr(bottom/8)*8 - p.h - 1
  end
 elseif p.vy<0 then
  local top=ny
  if solid_at(p.x,top) or solid_at(p.x+p.w,top) then
   p.vy=0
   ny=flr(top/8+1)*8
  end
 end

 p.y=ny
end

function draw_player()
 local p=player
 if p.inv>0 and (p.inv%6<3) then return end
 rectfill(p.x,p.y,p.x+p.w,p.y+p.h,8)
 if p.atk_t>0 then
  local hb=attack_box()
  rect(hb.x,hb.y,hb.x+hb.w,hb.y+hb.h,10)
 end
end

function attack_box()
 local p=player
 local hb={x=p.x,y=p.y+2,w=10,h=4}
 if p.face==1 then hb.x=p.x+p.w else hb.x=p.x-10 end
 return hb
end
