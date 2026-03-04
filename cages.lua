-- cages.lua
cages={}
saved=0

function init_cages()
 cages={}
 saved=0
 add(cages,{x=48,y=15*8-8,w=7,h=7,freed=false})
end

function update_cages() end

function draw_cages()
 for c in all(cages) do
  if c.freed then
   rect(c.x,c.y,c.x+c.w,c.y+c.h,6)
  else
   rect(c.x,c.y,c.x+c.w,c.y+c.h,7)
   line(c.x,c.y+3,c.x+c.w,c.y+3,7)
  end
 end
end

function try_free_cage()
 for c in all(cages) do
  if (not c.freed) and near(player,c,10) then
   c.freed=true
   saved+=1
   add_drop(c.x+3,c.y,2)
   if player.hp<10 then player.hp+=1 end
   return true
  end
 end
 return false
end
