pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--project rudy
--by nick jackson, ryan saul, anne strickland and david tran
--game title
function _init()
 show_ggj_logo(34,4,10)
 title_screen()
end

function show_ggj_logo(ggjy,ggjw,ggjs)
 ggjw=90+ggjw*30*ggjs
 for i=20-ggjw,110,ggjs do cls(1) clip(i,ggjy,ggjw,62) draw_ggj_logo(ggjy) flip() if (btnp()>0) then break end end cls()
end
function draw_ggj_logo(ggjy)
 logo="00000000000000777770000000000000000aaaaa000cc77c7ccccc000000000000aaaaaaaa777cccccccccc0000000000aaa000aaaa77777cccccccc00000000aaa000007aaa7777ccccccccc0000000aa00000777aaa777cccccccc77000000aa000007777aaa7ccccccccc77000000aa0000c77777aaacccccc777ccc00000aaa000c777777aaacccc77777c7000000aaa00cc7777ccaaaccc77777770000000aaaacc777ccccaaacc7777777aaa00000aaacc77ccccccaaacc777777aaaa0000000cc77cccccccaaacc7777700aaa000000cc77ccccccccaaac77777000aa0000000c77cccccccccaaa77770000aa0000000c77ccccccccccaaa777000aaa00000000cc7ccccccccc7aaaa000aaa0000000000cccccccccc777aaaaaaaa000000000000cccccccccc7770aaaaa00000000000000ccccccccccc000000000000000000000000ccccc"
 for i=1,#logo do if (sub(logo,i,i)!="0") pset(48+((i-1)%32),ggjy+16+flr((i-1)/32),tonum("0x"..sub(logo,i,i))) end
 for i=-1,1 do for j=-1,1 do print("game born at",40+i,ggjy+1+j,0) print("global game jam",34+i,ggjy+47+j,0) end end print("game born at",40,ggjy+1,13) print("global game jam",34,ggjy+47,7) print("www.globalgamejam.org",22,ggjy+57,13)
end

function title_screen()
 _update=title_update
 _draw=title_draw
 cursor=1
 max_players=4
end

function title_update()
 if btnp(2) then cursor-=1 end
 if btnp(3) then cursor+=1 end
 cursor=mid(0,cursor,max_players)
 if (btnp(5) or btnp(4)) and cursor==0 then howtoplay()
 elseif (btnp(5) or btnp(4)) then game_loop(cursor) end
end

function title_draw()
 cls()
 spr(192,20,10,4,4)
 spr(196,55,18,7,2)
 menuy=60
 print("how to play",40,menuy,9)
 for i=1,max_players do
  print("players: "..i,40,10*i+menuy,9)
 end
 print("🐱",30,10*cursor+menuy,6)
end

function howtoplay()
 _update=howtoplay_update
 _draw=howtoplay_draw
 pages={"main task:\n\nclean everything in the house\nbefore the timer runs out.\nthe messier the job,\nthe longer it will\ntake to clean up.",
 "single player:\n\nplay as the human, as they\ntry to tidy up their house,\nand keep it clean, so they\ncan relax and enjoy\ntheir weekend.\nthe only problem is,\nthere are some little\ntroublemakers, who think\nthat it's a fun game to\nwatch their human clean\nup after them.",
 "multiplayer:\n\nplayer 1 will play as the\nhuman cleaning the house,\nwhile the secondary player(s)\nwill play as the cats\nmaking the human's house\ntheir own personal\nscratching post.",
 "the human:\n\nrun around the house cleaning\nup after your mischievous\ncats, trying to keep the\nhouse as clean as possible\nbefore the timer runs out.\nmake sure to time those\nactive cleaners, to clean\nup as fast as possible.",
 "active cleaner:\n\ntime the active cleaner\nevent to get the\ntask done faster.\nmisses will clean slower,\nand waste precious\ntime off the clock.",
 "the cats:\n\nrun around causing mischief\nand making messes to keep\nyour human busy, trying to\nkeep the place as messy as\npossible before the timer\nruns out.",
 "active mess:\n\ntime the active mess\nto make more of a mess\nand continue your\nmischievous ways.\nmisses will go slower,\nand waste precious\ntime off the clock."}
 page=1
end

function howtoplay_update()
 if btnp(4) or btnp(5) then page+=1 end
 if page>#pages then title_screen() end
end

function howtoplay_draw()
 cls()
 print("how to play:",20,10,9)
 for i=1,#pages[page] do
  print(pages[page],10,25,9)
 end
end

-->8
--settings
max_seconds=60
clean_win=0.7

max_time=max_seconds*30
-->8
--game loop and objects
function game_loop(ps)
 music(0,0,7)
 timer=1
 players={}
 game_over=false
 for i=1,ps do
  add(players,create_player(i))
 end
 players[1].spr=5

 -- find all destructible tiles - setting all to dirty for now
 -- dests={}
 -- for x=0,16 do
 --  for y=0,16 do
 --   s=mget(x,y)
 --   if fget(s,1) then add(dests,create_destruct(x,y,8,10,1)) end
 --  end
 -- end

 dests={
  create_destruct(4,2,9,7,rndb(1,7)), --book left
  create_destruct(5,2,10,8,rndb(1,7)), --book right
  create_destruct(12,2,67,66,rndb(1,7)), --plant
  create_destruct(5,8,67,66,rndb(1,7)), --plant
  create_destruct(11,8,67,66,8,rndb(1,7)), --plant
  create_destruct(13,10,67,66,8,rndb(1,7)), --plant
  create_destruct(9,5,65,64,rndb(1,7)), --chair
  create_destruct(8,5,65,64,rndb(1,7)), --chair
  create_destruct(2,10,39,25,rndb(1,7)), --tub left
  create_destruct(3,10,40,26,rndb(1,7)), --tub right
  create_destruct(1,13,113,48,rndb(1,7)), --sink
  create_destruct(10,10,45,44,rndb(1,7)), --tv
  create_destruct(10,12,65,64,rndb(1,7)), --chair
 }

 _update=game_update
 _draw=game_draw
end

function create_player(i)
 cs={3,4,7,10,11,12}
 p={x=i*16,y=16,c=cs[i],spr=129,p=i,interacting=nil,anim=1,hflip=false,tick=0,dialog="",fx=1}
 if p.p==1 then p.fx=0 end
 p.set_dialog=function(self)
  options={"meow","🐱","◆purrrr◆","",""}
  if self.p==1 then
   options={"cat nabbit!!!", "◆whistle◆", "ugh...not again...","",""}
  end
  self.dialog=options[rndb(1,#options)]
 end
 p.can_move=true
 p.can_left=function(self)
  if self.p==1 then anims={18,19,20} else anims={133,134} end
  self:move_anim(anims,false,3)
  u=mget(flr((self.x-1)/8),flr(self.y/8))
  l=mget(flr((self.x-1)/8),flr((self.y+7)/8))
  return (not fget(u,0) and not fget(l,0))
 end
 p.can_right=function(self)
  if self.p==1 then anims={18,19,20} else anims={133,134} end
  self:move_anim(anims,true,3)
  u=mget(flr((self.x+8)/8),flr(self.y/8))
  l=mget(flr((self.x+8)/8),flr((self.y+7)/8))
  return (not fget(u,0) and not fget(l,0))
 end
 p.can_up=function(self)
  if self.p==1 then anims={34,35,36} else anims={131,132} end
  self:move_anim(anims,false,3)
  u=mget(flr((self.x)/8),flr((self.y-1)/8))
  l=mget(flr((self.x+7)/8),flr((self.y-1)/8))
  return (not fget(u,0) and not fget(l,0))
 end
 p.can_down=function(self)
  if self.p==1 then anims={5,21,37} else anims={129,130} end
  self:move_anim(anims,false,3)
  u=mget(flr((self.x)/8),flr((self.y+8)/8))
  l=mget(flr((self.x+7)/8),flr((self.y+8)/8))
  return (not fget(u,0) and not fget(l,0))
 end
 p.move_anim=function(self,anims,hflip,rate)
  self.tick+=1
  if self.tick>rate then
   self.tick=0
   self.anim+=1
   if self.anim>#anims then self.anim=1 end
   self.spr=anims[self.anim]
   self.hflip=hflip
  end
 end
 p.interact=function(self)
  x=flr((self.x+4)/8)
  y=flr((self.y+4)/8)
  tile=mget(x,y)
  d=dest_lookup(x,y)
  if not self.interacting and d then
   if d then
    if not d.active then
     d:areload()
     self.interacting=d
     self.can_move=false
     self:set_dialog()
     sfx(1,3)
    end
   end
  end
 end
 p.finish_reload=function(self)
  if self.p==1 then
   self.interacting:heal()
  else
   self.interacting:hurt()
  end
  self.can_move=true
  self.dialog=""
  sfx(-2,3)
 end
 return p
end

function create_destruct(x,y,bad_s,clean_s,h)
 local d={x=x,y=y,health=h,bad_s=bad_s,clean_s=clean_s,active=false}
 d.active_bar=0
 d.active_reload=function()
  for i=2,100,6 do
   d.active_bar=i
   d.active_bar=mid(0,d.active_bar,100)
   yield()
  end
 end
 d.areload=function(self)
  self.active=true
  self.c_active=cocreate(self.active_reload)
 end
 d.finish_reload=function(self,i)
  self.active=false
  self.c_active="dead"
  if self.active_bar>70 and self.active_bar<90 then
   self.health=8
   sfx(6,2)
  elseif self.active_bar<70 then
   self.health+=flr(self.active_bar/20)
   sfx(7,2)
  else
   self.health+=4
   sfx(7,2)
  end
 end
 d.hurt=function(self)
  self.active=false
  self.c_active="dead"
  if self.active_bar>70 and self.active_bar<90 then
   self.health=1
   sfx(6,2)
  elseif self.active_bar<70 then
   self.health-=flr(self.active_bar/20)
   sfx(7,2)
  else
   self.health-=4
   sfx(7,2)
  end
  self.health=mid(1,self.health,8)
 end
 d.heal=function(self)
  self.active=false
  self.c_active="dead"
  if self.active_bar>70 and self.active_bar<90 then
   self.health=8
   sfx(6)
  elseif self.active_bar<70 then
   self.health+=flr(self.active_bar/20)
   sfx(7)
  else
   self.health+=4
   sfx(7)
  end
  self.health=mid(1,self.health,8)
 end
 d.c_active="dead"
 return d
end
-->8
--updates
function game_update()
 timer+=1
 if timer>max_time then game_over=true end
 if not game_over then
  update_players()
  update_dests()
 else
  for i=1,5 do
   if btn(i) then title_screen() end
  end

 end
end

function update_players()
 for i=1,#players do
  if players[i].interacting then
   if i==1 then anims={166,167,168,169,170} else anims={133,134} end
   players[i]:move_anim(anims,false,2)
   if btnp(4,i-1) then players[i]:finish_reload() end
   if not players[i].interacting.active then players[i].can_move=true;players[i].interacting=nil end
  elseif players[i].can_move then
   if btn(0,i-1) and btn(2,i-1) and players[i]:can_left() and players[i]:can_up() then players[i].x-=1;players[i].y-=1  --left up
   elseif btn(1,i-1) and btn(2,i-1) and players[i]:can_right() and players[i]:can_up() then players[i].x+=1;players[i].y-=1  --right up
   elseif btn(0,i-1) and btn(3,i-1) and players[i]:can_left() and players[i]:can_down() then players[i].x-=1;players[i].y+=1  -- left down
   elseif btn(1,i-1) and btn(3,i-1) and players[i]:can_right() and players[i]:can_down() then players[i].x+=1;players[i].y+=1  -- right down
   elseif btn(0,i-1) and players[i]:can_left() then players[i].x-=1.5  --left
   elseif btn(1,i-1) and players[i]:can_right() then players[i].x+=1.5  --right
   elseif btn(2,i-1) and players[i]:can_up() then players[i].y-=1.5  --up
   elseif btn(3,i-1) and players[i]:can_down() then players[i].y+=1.5 end --down
   if btnp(4,i-1) then players[i]:interact() end
  end
 end
end

function update_dests()
 for i=1,#dests do
  d=dests[i]
  if d.c_active!="dead" then
   coresume(d.c_active)
  end
 end
end

function dest_lookup(x,y)
 for k,d in pairs(dests) do
  if d.x==x and d.y==y then return d end
 end
end
-->8
--draws
function game_draw()
 cls()

 map(0,0,0,0,20,20)

 cs={8,10,11,11}

 rectfill(0,0,127,7,0)
 print("time:",1,1,7)
 if not game_over then
  rectfill(20,1,20+100-ceil(timer/max_time*100),6,cs[ceil((max_time-timer)/(max_time/3))])
 end

 thealth=0.0
 max_health=#dests*8
 for i=1,#dests do
  d=dests[i]
  thealth+=d.health
  if d.health<8 then
   for i=1,d.health do
    pset(d.x*8+i-1,(d.y*8)+9,cs[ceil(d.health/3)])
    pset(d.x*8+i-1,(d.y*8)+10,cs[ceil(d.health/3)])
   end
   spr(d.bad_s,d.x*8,d.y*8)
  else
   spr(d.clean_s,d.x*8,d.y*8)
  end
  if d.active then
   if d.active_bar==100 then
    d.active=false;d:finish_reload()
   else
    rectfill(d.x*8-2,d.y*8+11,d.x*8+9,d.y*8+15,5)
    for i=1,d.active_bar do
     pset(d.x*8+(i/10)-1,(d.y*8)+12,7)
     pset(d.x*8+(i/10)-1,(d.y*8)+13,7)
     pset(d.x*8+(i/10)-1,(d.y*8)+14,7)
    end
    rectfill(d.x*8+7,d.y*8+11,d.x*8+7,d.y*8+15,7)
   end
  end
 end

 phealth=thealth/max_health
 if phealth>clean_win then ccs=11 else ccs=8 end
 rectfill(0,118,127,127,0)
 print("clean:",1,120,7)
 rectfill(30,120,30+ceil(phealth*95),125,ccs)

 for i=1,#players do
  p=players[i]
  pal(9,p.c)
  spr(p.spr,p.x,p.y,1,1,p.hflip)
  pal()
  print(p.dialog,p.x-5,p.y-5,15)
 end

 gox=30
 goy=38
 if game_over then
  rectfill(gox-2,goy-2,gox+72,goy+24,0)
  print("game over!",gox+20,goy,7)
  print("house is "..ceil(phealth*100).."% clean",gox,goy+6,7)
  if phealth > clean_win then winner="humans" else winner="cats" end
  print(winner.." win!",gox+20,goy+12,7)
  print("🐱press any button",gox,goy+18,7)
 end
 --debug
 -- print(h,100,90,11)
 -- print(mx,100,90,11)
 -- print(my,110,90,11)
 -- print("d:"..#dests,100,90,11)
 -- print(stat(0),10,110,11)
 -- print(stat(1),50,110,11)
 -- print(stat(2),100,110,11)
 print(stat(16),60,110,11)
 print(stat(17),70,110,11)
 print(stat(18),80,110,11)
 print(stat(19),90,110,11)

end
-->8
--Utils
function rndb(low,high)
 return flr(rnd(high-low+1)+low)
end
__gfx__
000000004f4f4f4f000d7000000770007c7c7c7c00cccc000000000076666666667677774dddd66ddd66d66d0000000000007770000000000000dd7000000000
000000004f4f4f440077d70000777700c7c7c7c70caaaac0000900096555555555555556dd55dd5dd555d556000000000006667000000000000666d000000000
007007004f444f4f07d67d70076677707c7c7c7c0caaaac0000999996544445555444457d5d44d5d554dd45d0000000000000070000000000000007000000000
000770004f4f4f4fdd7d7d7776777777c7c7c7c70cdaadc0099909096544444444444456d5d44d44444dd45d0000000000000070000000000000007000000000
00077000444f4f4fd777767d777776777c7c7c7c0088880099999599666666666666666666d6666666dd6d66000000000000007000000000000000d000000000
007007004f4f4f4f07d766d007776670c7c7c7c70a8888a0099959506555555555555556ddd5555555d55dd6000000000000007000000000000000d000000000
000000004f4f444f007dd7d0007777007c7c7c7c0055550009009090654444444444445665dd44444d444dd60000000000000070000000000000007000000000
000000004f4f4f4f0007d00000077000c7c7c7c700500500090090906666666666666666666d66666666666d0000000000000070000000000000007000000000
0000000033333333000000000000000000ccccc00000000000000000000000000000000007666666666777700000000000000070000000000000007000000000
000000003333333300ccccc000ccccc000aadcc000cccc0000900090000000000000000065555555555555576666666666666666ddd6dd66d66ddd6600000000
000333003333333300aadcc000aadcc000aaacc00caaa9c0009999900000000000000000756666666777775667777777777777766d77ddd7777dddd600000000
003bbb303333333300aaacc000aaacc000aaacc00caaaac00090909000000000000000006566666776667757067777777777776006d7d77d77dd77d000000000
03b000b03333333300aaacc000aaacc0000888000adaadc00099599000000000000000006566666776666756067777777777666006d7dd777dd76dd000000000
0b00000033333333000888000008880000088a0000888a000005950000000000000000006566666666677757067777777766666006d77d7777666d6000000000
00000000777777770008a8000008a8000005550000555500000999000000000000000000655555555555555700677666666666600067dd6ddd66666000000000
00000000666666660006050000050600000055000060050000090e00000000000000000006767777776666600006666666666600000d66666d6ddd0000000000
000000007777777700cccc0000cccc0000cccc00000000000000000006666666666666d000000000000000000000000d00000000000ddd000000000000000000
00088000777777770cccccc00cccccc00cccccc000cccc0009000900d5d775d55d555dd60000000000000000000000d4030e9c8000deed0d0000000000000000
00888800777777770cccccc00cccccc00cccccc00c9aaac0099999006d771d6666d7765d000000000000000000000d4003be9c8000bb09d90000000000000000
88888888777777770cccccc00cccccc00cccccc00caaaac0090909006d67766dd677175d00000000000000000006d40003be9c80033dcc0d0000000000000000
00dddd00777777770088880000888800008888000cdaada00995990065d6677dd6d7d75600000000000000000666500022222222d22d22220000000000000000
0088880077777777008888a00a8888000a8888a000a8880000595000d56671776d67d65600000000000000000065000044155144dd15514d0000000000000000
00888800dddddddd00555500005555000055550000555500009990006d5d57d5dd555d5600000000000000000605000044444444444dd4d40000000000000000
000000006666666600d0050000500d00005005000050060000e090000dd6666d6666d660000000000000000000000000444444444d444dd40000000000000000
57777775000000000000000000000003000000073000000070000000000000000000000033333333777777770000000000090009000000000000000000000000
76666667000000000000d00000000003000000073000000070000000009000900900090000000000000000000009000900099999000900090000000000000000
7676676700000000000dd00000000003000000073000000070000000009999900999990000000000000000000009999909990909000999990000000000000000
7665d66700000000d0dddd0000000003000000073000000070000000009999900999990000000000000000000999090999999599099909090000000000000000
76605667666666676d666dd7000000030000000730000000700000000099a990099a990000000000000000009999959909995950999995990000000000000000
7676676705666770056d677000000003000000073000000070000000000a99000099a00000000000000000000999595009909009099959500000000000000000
76666667000000000000000000000003000000073000000070000000000999000099900000000000000000000900909090900e0e090090900000000000000000
5777777500000000000000000000000300000007300000007000000000090e0000e0900000000000000000000900909000000000090090900000000000000000
0044440000dd440000e2e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00f44f0000fd4f000beee30000505000000000000000000000000700700007700000007000000000000000000000000000000000000000000000000000000000
00f44f0000f4df00b00300b0050d0500000000000000700000707000000000000000000700000000000000000000000000000000000000000000000000000000
00f44f0000d4dfd00003000000050000000700000007000000070000000700000007000000000000000000000000000000000000000000000000000000000000
045555400d5555d011111111d1d11d1d000000000070000000707000000000000000000000000000000000000000000000000000000000000000000000000000
04444440044d4d400666767006d67d70000000000000000007000000770000007000000000000000000000000000000000000000000000000000000000000000
045005400d500d40011111100d1d11d0000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000000000
045005400d5005d00066660000ddd600000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000
44444444222222221111111105fffff005ddddd036666663cc5115ccdc5115cd0000000000000000000000000000000000000000000000000000000000000000
44444444222222221111111105f667f00df6d7d036777763cc1771cccd1dd1cd0000000000000000000000000000000000000000000000000000000000000000
44444444222222221111111105f667f00dfdd7d036777763c577775cc5dddd5c0000000000000000000000000000000000000000000000000000000000000000
44444444222222221111111105f667f005fd67f036777763c177771cc1dddd1c0000000000000000000000000000000000000000000000000000000000000000
44444444222222221111111105f667f00df667f03666666351666615516d6d150000000000000000000000000000000000000000000000000000000000000000
44444444222222221111111105f667f005dd6dd033333333133333311d3d33d10000000000000000000000000000000000000000000000000000000000000000
44444444222222221111111105f667f005f6ddf07777777777777777d77d77d70000000000000000000000000000000000000000000000000000000000000000
44444444222222221111111105fffff00ddffdf06666666666666666d666666d0000000000000000000000000000000000000000000000000000000000000000
01101111cc77cc7777bbb77711133311122122121111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
0110111177cc77cc77bbb77711133311222211122111111200000000000000000000000000000000000000000000000000000000000000000000000000000000
0110111177cc77ccbb777bbb33311133222212212211112200000000000000000000000000000000000000000000000000000000000000000000000000000000
00001111cc77cc77bb777bbb33311133122122222221122200000000000000000000000000000000000000000000000000000000000000000000000000000000
01101111cc77cc77bb777bbb33311133211122222211112200000000000000000000000000000000000000000000000000000000000000000000000000000000
0110000077cc77cc77bbb77733311133212212212111111200000000000000000000000000000000000000000000000000000000000000000000000000000000
0110111177cc77cc77bbb77711133311122221121111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
01101111cc77cc7777bbb77711133311122221122111111200000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000a000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a000a00a000a00a000a0000a000a00a000a00aaaaa000a000a000000000000000000000000000000000000000000000000000000000000000000000000000
000aaaaa00aaaaa00aaaaa0000aaaaa00aaaaa00a1a1a990aaaaa000000000000000000000000000000000000000000000000000000000000000000000000000
099a0a0a00a1a1a00a1a1a0000aaaaa00aaaaa00aa5aa999a1a1a990000000000000000000000000000000000000000000000000000000000000000000000000
999aa5aa00aa5aa00aa5aa0000a999a00a999a0005a59990aa5aa999000000000000000000000000000000000000000000000000000000000000000000000000
09995a500005a500005a50000009a900009a90009009099005a59990000000000000000000000000000000000000000000000000000000000000000000000000
09009090000999000099900000099a0000a99000e0e0090909090090000000000000000000000000000000000000000000000000000000000000000000000000
0900909000090e0000e0900000090e0000e090000000000009090090000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000009000900000000000000000000000000000000000000000000000000000000000000000000000000000000
00090009009000900900090000900090090009000009999900090009000000000000000000000000000000000000000000000000000000000000000000000000
00099999009999900999990000999990099999000aa9090900099999000000000000000000000000000000000000000000000000000000000000000000000000
0aa9090900909090090909000099999009999900aaa995990aa90909000000000000000000000000000000000000000000000000000000000000000000000000
aaa995990099599009959900009aaa9009aaa9000aaa5950aaa99599000000000000000000000000000000000000000000000000000000000000000000000000
0aaa59500005950000595000000a9a0000a9a0000aa0a00a0aaa5950000000000000000000000000000000000000000000000000000000000000000000000000
0a00a0a0000aaa0000aaa000000aa900009aa000a0a00e0e0a00a0a0000000000000000000000000000000000000000000000000000000000000000000000000
0a00a0a0000a0e0000e0a000000a0e0000e0a000000000000a00a0a0000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000cccc0000cccc0000cccc0000cccc0000cccc000000000000000000000000000000000000000000
0000000000cccc0000cccc0000cccc0000cccc0000cccc000cccccc00cccccc00cccccc00cccccc00cccccc00000000000000000000000000000000000000000
000000000caaa9c00caaa9c00caaa9c00caaa9c00caaa9c00cccccc00cccccc00cccccc00cccccc00cccccc00000000000000000000000000000000000000000
000000000caaaac00caaaac00caaaac00caaaac00caaaac00cccccc00cccccc00cccccc00cccccc00cccccc00000000000000000000000000000000000000000
000000000adaadc00adaadc00adaadc00adaadc00adaadc000888800008888a00088880000888800008888000000000000000000000000000000000000000000
0000000000888a0000889800008888000088880000888a000a8888000a8888000a8888a00a8888000a8888000000000000000000000000000000000000000000
0000000000555500005555000055a50000555a000055550000555500005555000055550000555500005555000000000000000000000000000000000000000000
00000000006005000060050000600500006005000060050000500d0000500d0000500d0000500d0000500d000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ccccc000ccccc000ccccc000ccccc000ccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aadcc000aadcc000aadcc000aadcc000aadcc000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aaacc000aaacc000aaacc000aaacc000aaacc000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aaacc000aaacc000aaacc000aaacc000aaacc000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000088800008888000a888800009888000008880000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000a8a8000a08a8000008a8000008a80000a8a80000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000506000005060000050600000506000005060000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000099000000000000000000000909000ddddd7000dd7000ddddd70000000000000000000000000000000000000000000000000000000000000000000000000
000999990000000000000000000999900d77777000d77d70ddddddd7000000000000000000000000000000000000000000000000000000000000000000000000
00999999000000000000000009999999d70000000d7000d7000d7000000000000000000000000000000000000000000000000000000000000000000000000000
09999999990000000000000099999999d70000000d7000d7000d7000000000000000000000000000000000000000000000000000000000000000000000000000
09999999990000000000009999999999d70000000d7000d7000d7000000000000000000000000000000000000000000000000000000000000000000000000000
09999999999999999999909999999999d70000000dddddd7000d7000000000000000000000000000000000000000000000000000000000000000000000000000
099999999999999999999999999999990d7777700d7000d7000d7000000000000000000000000000000000000000000000000000000000000000000000000000
0999999999999999999999999999999900ddddd70d7000d7000d7000000000000000000000000000000000000000000000000000000000000000000000000000
999999999999999999999999999999990d7000d7000dd70000dddd7000dddd700ddddd700ddddd7000ddd7000000000000000000000000000000000000000000
999999999999999999999999999999990d7000d700d77d700d7777d70d7777d7000d7000ddddddd700ddd7000000000000000000000000000000000000000000
999999999999999999999999999999990dd700d70d7000d70d7000d70d7000d7000d7000000d700000ddd7000000000000000000000000000000000000000000
999999999999999999999999999999990d7d70d70d7000d70ddddd000ddddd00000d7000000d700000ddd7000000000000000000000000000000000000000000
999999999999999999999999999999990d70d7d70d7000d70d7777d70d7777d7000d7000000d700000ddd7000000000000000000000000000000000000000000
999999999999999999999999999999990d700dd70dddddd70d7000d70d7000d7000d7000000d7000000d70000000000000000000000000000000000000000000
999999999990999999999099999999990d7000d70d7000d70d7000d70d7000d7000d7000000d7000000000000000000000000000000000000000000000000000
999999999900999999990099999999990d7000070d7000d70ddddd700ddddd700ddddd70000d7000000d70000000000000000000000000000000000000000000
99999999990099999999009999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999eeee99999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
999999999999999ee999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999999999999999999999999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d99999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d99999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dd00999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000999999999999999999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000099999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000009999999999999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000999999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000002020000000000000000010000000000000002020000000000000100000000000202000000000000000200000101010100000101010101000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001020000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0011111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3352525252525252525252525252656565360000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3352525252525252525252525252656565360000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3352525252525252525252525252525252350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3352525252525252525252525252525252350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3352525252525252525252525252525252350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3352525252525252525252525252525252350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3352525252525252525252525252525252350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3421212121217011111111111111115252350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3461616161617052525252525252525252350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3461616161617052525252525252525252350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3461616161617052525252525252525252350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3461616161615252525252525252525252350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3461616161615252525252525252525252350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003a3a3a3a3a3939393939393939393939000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001001918610196101a6101c6101e6101f610206102161022610236102561027610286102c6102d6102e610306103161030610356103b6103f610246101d6101561000000000000000000000000000000000000
0004000a1e614256102c620336203863532600236141c610196101861018605000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000162402634026340263403634036440362403620036200361003620026100262002610036150361502615016150161501600016000000000000000000000000000000000000000000000000000000000
000200280c73407705330000900007000010001e0000e000270002a000300003200004000130000f00011000090000c00017000020000874004610030001d0001100000000000000000004000020002100419005
00110820326102f6102b6102761023610216102161020610206102061020610206102061020610206101f6102061027610206102961020610206101f6101f610266101f6101f6101f61029610286102061020610
00010000101400d6400d6001b00014000000000000010700126001460015600166000000000000000000000011730000001b65010700000000000000000000000000000000000000000000000000000000000000
000300001204011010110501201012050120101305014010160501701017050180101a0501b0101e0501f0502103024020270202b04628746307462874622746277461c746217462e7461f74626746297372e730
0002000027324223201c33014310113300e3400b34009340083400835005150051500315004100051200515004120031200311002110021200212002120021200211001100011000405004050010500520004200
000100002375016750167501d75025750287001570013700117000f7000e7000d7000d7000b7300a7400000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000c7500c7000c7500c750137501374013730137201575015740157301572013750137400c7300c7200e7500e7000e7500e750157501574015730157201275012740127301272013750137500e7500e750
0110000028000290001e1141e1101e1101e1101f1101f1101a1101a1101a1101a1101c1111c1121c1121c11500100001002111421110231102311026110261102111021110211102111023111231122311223115
0110000000000000001e1141e1101e1101e1101f1101f1101a1101a1101a1101a1101c1101c112211102111021100211002311023110261102611021110211102311123110231102311223112231122311223115
00100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0500c0501705015050
011000001305013040130301302010050100401003010020120401204012030120200e0400e040100401004012030120301e0311e0301f0301f03021030210301e0301e0301e0301e0301f0311f0321f0321f035
011000001305013040130301302010050100401003010020120401204012030120200e0400e0401e0401e04000000000001f0301f03021030210301e0301e0301f0311f030210302303026030240302303021030
011000001f0301f0251f0201f0201f0251f000210302102500000000001f0301f03500000000001e0301e0301e0351e0001e0301e03518000000001f0301f0351800000000230302303023035000001c0201c011
011000001703017025170201702017025000001703017025000000000017030170350000000000150301503015035150001503015035000000000015030150350000000000150301503015035150001302013011
0010000010730107111071010710107101071010730107111071010710107301071110710107100e7300e7110e7100e7100e7300e7110e7100e7100e7300e7110e7100e7100e7300e7110e7100e7100c7300c711
001000000c7100c7100c7100c7100c7100c7210e7200e7200e7310e7300e7300e7300e7410e7400e7400e740157501574015730157201a7501a7400e7300e7200e7200e720127311373015730137301275110750
001000001301013010130101301013010130211502015020150311503015030150301504115040150421504200000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001c0101c0101c0101c0101c0101c0211e0201e0201e0311e0301e0301e0301e0411e0401e0421e04200000000000000000000000000000028000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000021000230001a0001800000000000002604524000320250000021035000000000000000230350000000000000001e0301e0311e0321e032
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f00001300013000130001300013000130001300013000120001200012000120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 09444344
00 094a4344
00 090a4344
00 090b0c44
00 090a0d44
00 090b0e4d
00 11100f44
02 12131415
00 41424344
00 42424344
