-- utils.lua
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

function clamp(v,a,b)
 if v<a then return a end
 if v>b then return b end
 return v
end

-- format number to 1 decimal without heavy string ops
function fmt1(n)
 return flr(n*10)/10
end
