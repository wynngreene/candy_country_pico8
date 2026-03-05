-- main.lua
state="title"

function _init()
 init_world()
 init_player()
 init_poachers()
 init_cages()
 init_drops()
 init_ui()
 state="title"
end

function _update()
 -- debug toggle (UP)
 if btnp(2) then
  debug=not debug
 end

 if state=="title" then
  if btnp(4) or btnp(5) then state="play" end

 elseif state=="play" then
  update_world()
  update_player()
  update_poachers()
  update_cages()
  update_drops()
  update_ui()
  check_win()

 elseif state=="win" then
  if btnp(4) or btnp(5) then _init() end
 end
end

function _draw()
 if state=="title" then
  draw_title()
 elseif state=="play" then
  draw_world()
  draw_cages()
  draw_poachers()
  draw_drops()
  draw_player()
  draw_ui()
 elseif state=="win" then
  draw_win()
 end
end
