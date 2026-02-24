--==============================
-- candy forest (zelda2 starter)
--==============================

-- world settings
tile_size=8
floor_tile=1      -- the tile id we will use for ground
floor_y_tile=15   -- which map row is the floor (0-index)

-- physics
grav=0.25
jump_v=-3.35
move_a=0.35
max_vx=1.65

--==============================
-- map / solids
--==============================

function is_solid_tile(t)
 return t==floor_tile
end

function solid_at(px,py)
 -- px,py in pixels
 local tx=flr(px/tile_size)
 local ty=flr(py/tile_size)
 local t=mget(tx,ty)
 return is_solid_tile(t)
end

function build_floor()
 -- writes a visible + solid floor into the map
 -- across a wide range so camera scrolling still has ground
 for x=0,127 do
  mset(x,floor_y_tile,floor_tile)
 end
end

--==============================
-- helpers
--==============================

function clamp(v,a,b)
 if v<a then return a end
 if v>b then return b end
 return v
end

function aabb(a,b)
 return not (
  a.x+a.w < b.x or
  b.x+b.w < a.x or
  a.y+a.h < b.y or
  b.y+b.h < a.y
 )
end

function near(a,b,dist)
 local ax=a.x+a.w/2
 local ay=a.y+a.h/2
 local bx=b.x+b.w/2
 local by=b.y+b.h/2
 return abs(ax-bx)<=dist and abs(ay-by)<=dist
end

--==============================
-- entities
--==============================

function make_player()
 return {
  x=24,y=24,w=7,h=7,
  vx=0,vy=0,
  face=1,
  on_ground=false,
  hp=10,
  inv=0,
  atk_t=0
 }
end

function make_poacher(x,y)
 return {
  x=x,y=y,w=7,h=7,
  vx=0.6,dir=1,
  hp=3,
  alive=true,
  stun=0
 }
end

function make_cage(x,y)
 return {
  x=x,y=y,w=7,h=7,
  freed=false
 }
end

function make_drop(x,y,amt)
 return {
  x=x,y=y,w=3,h=3,
  vy=-1.25,
  t=0,
  amt=amt
 }
end

--==============================
-- init
--==============================

function _init()
 build_floor()

 state="play"

 player=make_player()

 -- one poacher + one cage to prove the loop
 poachers={}
 add(poachers, make_poacher(80, floor_y_tile*8-8))

 cages={}
 add(cages, make_cage(48, floor_y_tile*8-8))

 drops={}
 commodity=0

 -- camera
 camx=0
end

--==============================
-- update
--==============================

function _update()
 if state=="play" then
  update_player()
  update_poachers()
  update_cages()
  update_drops()
  check_win()
 end
end

function update_player()
 local p=player

 -- timers
 if p.inv>0 then p.inv-=1 end
 if p.atk_t>0 then p.atk_t-=1 end

 -- input: left/right
 local ax=0
 if btn(0) then ax=-move_a p.face=-1 end
 if btn(1) then ax= move_a p.face= 1 end

 if ax==0 then
  p.vx*=0.80
 else
  p.vx+=ax
 end
 p.vx=clamp(p.vx,-max_vx,max_vx)

 -- ❌ attack (btn 4)
 if btnp(4) and p.atk_t<=0 then
  p.atk_t=8
  try_hit_poachers()
 end

 -- 🅾️ action (btn 5)
 -- if near a cage: free it
 if btnp(5) then
  if try_free_cage() then
   -- freed!
  else
   -- otherwise: jump (zelda2 feel)
   if p.on_ground then
    p.vy=jump_v
    p.on_ground=false
   end
  end
 end

 -- gravity
 p.vy+=grav
 p.vy=clamp(p.vy,-6,3)

 -- move + collide X
 move_collide_x(p)

 -- move + collide Y
 move_collide_y(p)

 -- camera follow
 camx=flr(p.x-64)
 if camx<0 then camx=0 end
 camera(camx,0)
end

function move_collide_x(p)
 local nx=p.x+p.vx

 -- right
 if p.vx>0 then
  local right=nx+p.w
  if solid_at(right,p.y) or solid_at(right,p.y+p.h) then
   p.vx=0
   nx=flr(right/8)*8 - p.w - 1
  end
 end

 -- left
 if p.vx<0 then
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

 -- falling
 if p.vy>0 then
  local bottom=ny+p.h
  if solid_at(p.x,bottom) or solid_at(p.x+p.w,bottom) then
   p.vy=0
   p.on_ground=true
   ny=flr(bottom/8)*8 - p.h - 1
  end
 end

 -- rising
 if p.vy<0 then
  local top=ny
  if solid_at(p.x,top) or solid_at(p.x+p.w,top) then
   p.vy=0
   ny=flr(top/8+1)*8
  end
 end

 p.y=ny
end

--==============================
-- attack / action logic
--==============================

function attack_box()
 local p=player
 local hb={
  x=p.x, y=p.y+2, w=10, h=4
 }
 if p.face==1 then
  hb.x=p.x+p.w
 else
  hb.x=p.x-10
 end
 return hb
end

function try_hit_poachers()
 local hb=attack_box()
 for e in all(poachers) do
  if e.alive and aabb(hb,e) then
   e.hp-=1
   e.stun=10
   -- knockback
   e.x+=player.face*6
   if e.hp<=0 then
    e.alive=false
    -- drop commodity
    add(drops, make_drop(e.x+3,e.y,1))
   end
  end
 end
end

function try_free_cage()
 local p=player
 for c in all(cages) do
  if (not c.freed) and near(p,c,10) then
   c.freed=true
   -- reward: drop commodity + tiny heal
   add(drops, make_drop(c.x+3,c.y,2))
   if p.hp<10 then p.hp+=1 end
   return true
  end
 end
 return false
end

--==============================
-- poachers
--==============================

function update_poachers()
 local p=player
 for e in all(poachers) do
  if e.alive then
   if e.stun>0 then
    e.stun-=1
   else
    -- simple patrol: walk, bounce off edges / solids
    local nx=e.x + e.vx*e.dir
    -- turn if would hit wall
    local aheadx = (e.dir==1) and (nx+e.w+1) or (nx-1)
    if solid_at(aheadx,e.y) or solid_at(aheadx,e.y+e.h) then
     e.dir=-e.dir
    else
     e.x=nx
    end
   end

   -- player contact damage
   if p.inv<=0 and aabb(p,e) then
    p.hp-=1
    p.inv=30
    -- knockback
    p.vx = -e.dir*2.0
    p.vy = -1.5
    if p.hp<=0 then
     -- simple reset for now
     reset_room()
     return
    end
   end
  end
 end
end

function reset_room()
 -- quick restart loop for testers
 player=make_player()
 poachers={}
 add(poachers, make_poacher(80, floor_y_tile*8-8))
 cages={}
 add(cages, make_cage(48, floor_y_tile*8-8))
 drops={}
 commodity=0
 camera(0,0)
end

--==============================
-- cages / drops
--==============================

function update_cages()
 -- nothing needed besides freeing logic
end

function update_drops()
 local p=player
 for d in all(drops) do
  d.t+=1
  -- bounce then settle
  d.vy+=0.20
  d.y+=d.vy
  if d.y > floor_y_tile*8-4 then
   d.y = floor_y_tile*8-4
   d.vy *= -0.35
   if abs(d.vy)<0.2 then d.vy=0 end
  end

  if aabb(p,d) then
   commodity += d.amt
   del(drops,d)
  elseif d.t>600 then
   del(drops,d)
  end
 end
end

function check_win()
 -- win when you free all cages AND defeat all poachers
 local all_freed=true
 for c in all(cages) do
  if not c.freed then all_freed=false end
 end

 local any_alive=false
 for e in all(poachers) do
  if e.alive then any_alive=true end
 end

 if all_freed and (not any_alive) then
  state="win"
 end
end

--==============================
-- draw
--==============================

function _draw()
 cls(12)

 -- draw a big chunk of map so you always see floor
 map(0,0,0,0,128,32)

 if state=="play" then
  draw_cages()
  draw_poachers()
  draw_drops()
  draw_player()
  draw_hud()
  draw_help()
 elseif state=="win" then
  draw_win()
 end
end

function draw_player()
 local p=player

 -- blink if invincible
 if p.inv>0 and (p.inv%6<3) then
  -- skip draw
 else
  rectfill(p.x,p.y,p.x+p.w,p.y+p.h,8)
  -- face marker
  if p.face==1 then
   pset(p.x+p.w, p.y+3, 7)
  else
   pset(p.x, p.y+3, 7)
  end
 end

 -- draw attack hitbox for debug (optional)
 if p.atk_t>0 then
  local hb=attack_box()
  rect(hb.x,hb.y,hb.x+hb.w,hb.y+hb.h,10)
 end
end

function draw_poachers()
 for e in all(poachers) do
  if e.alive then
   rectfill(e.x,e.y,e.x+e.w,e.y+e.h,2)
   -- tiny headband pixel
   pset(e.x+3,e.y+1,8)
  end
 end
end

function draw_cages()
 for c in all(cages) do
  if c.freed then
   -- open cage (faded)
   rect(c.x,c.y,c.x+c.w,c.y+c.h,6)
  else
   -- closed cage
   rect(c.x,c.y,c.x+c.w,c.y+c.h,7)
   line(c.x,c.y+3,c.x+c.w,c.y+3,7)
  end
 end
end

function draw_drops()
 for d in all(drops) do
  rectfill(d.x,d.y,d.x+d.w,d.y+d.h,9)
 end
end

function draw_hud()
 camera(0,0)
 print("hp:"..player.hp, 2,2,0)
 print("commod:"..commodity, 2,10,0)
 camera(camx,0)
end

function draw_help()
 camera(0,0)
 print("❌ attack", 2,118,0)
 print("🅾️ jump / free cage", 56,118,0)
 camera(camx,0)
end

function draw_win()
 camera(0,0)
 cls(1)
 print("candy forest protected!", 18,40,7)
 print("commodities recovered: "..commodity, 16,58,7)
 print("press ❌ to restart", 22,84,7)

 if btnp(4) or btnp(5) then
  _init()
 end
end
