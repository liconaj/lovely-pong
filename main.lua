local font = love.graphics.newFont("font.ttf", 24)
local midfont = love.graphics.newFont("font.ttf", 30)
local bigfont = love.graphics.newFont("font.ttf", 50)

local sounds = {}
local sound_files = {"go", "pad", "bad", "wall"}
for _, name in ipairs(sound_files) do
   sounds[name] = love.audio.newSource(name .. ".wav", "static")
end

function play_sound(name)
   sounds[name]:play()
end

function init_game()
   speed = 3
   ball = {
      x = 0,
      y = 0,
      vy = 0,
      vx = speed,
      dv = 0.2
   }
   vel = 4
   pad1 = 0
   pad2 = 0
   score1 = 0
   score2 = 0
   game_over = false
   needed_to_win = 5
   winner = 0
end

init_game()
game_over = true
function love.update()

   if game_over then
      if love.keyboard.isDown("space") then
         play_sound("go")
         init_game()
      end
      if love.keyboard.isDown("escape") then
      love.event.quit()
   end
      return
   end
      
   if love.keyboard.isDown("w") then
      pad1 = pad1 - vel
   end
   if love.keyboard.isDown("s") then
      pad1 = pad1 + vel
   end
   if love.keyboard.isDown("up") then
      pad2 = pad2 - vel
   end
   if love.keyboard.isDown("down") then
      pad2 = pad2 + vel
   end
   if love.keyboard.isDown("escape") then
      love.event.quit()
   end

   if pad1 > 160 then
      pad1 = 160
   end
   if pad1 < -160 then
      pad1 = -160
   end
   if pad2 > 160 then
      pad2 = 160
   end
   if pad2 < -160 then
      pad2 = -160
   end

   ball.x = ball.x + ball.vx
   ball.y = ball.y + ball.vy

   if math.abs(ball.y) >= 195 then
      ball.vy = -ball.vy
      play_sound("wall")
   end


   -- paddle 1
   if ball.x < -278 and ball.x > -299 and math.abs(pad1-ball.y) < 47 then
      if speed <= 10 then         
         speed = speed + ball.dv
         vel = vel + 0.1
      end
      ball.x = -278
      ball.vx = speed
      if ball.vy < 0 then
         ball.vy = -math.random(0, 50)/100 * speed + (ball.vy * 0.5)
      else         
         ball.vy = math.random(0, 50)/100 * speed + (ball.vy * 0.5)
      end
      play_sound("pad")
      play_sound("wall")
   end
   if ball.x <= -315 then
      ball.x = 0
      ball.y = 0
      ball.vy = 0
      ball.vx = speed - 1
      score2 = score2 + 1
      play_sound("bad")
      if score2 % 5 == 0 and score2 ~= 0 then
         play_sound("go")
      end
      if score2 == needed_to_win and score2 - score1 >= 2 then
         game_over = true
         winner = 1
      elseif score2 == needed_to_win then
         needed_to_win = needed_to_win + 1
      end
   end

   -- paddle 2
   if ball.x > 278 and ball.x < 299 and math.abs(pad2-ball.y) < 47 then
      if speed <= 10 then
         speed = speed + ball.dv
         vel = vel + 0.1
      end
      ball.x = 278
      ball.vx = -speed
      if ball.vy < 283 then
         ball.vy = -math.random(0, 50)/100 * speed + (ball.vy * 0.5)
      else
         ball.vy = math.random(0, 50)/100 * speed + (ball.vy * 0.5)
      end
      play_sound("pad")
      play_sound("wall")
   end
   if ball.x > 315 then
      ball.x = 0
      ball.y = 0
      ball.vy = 0
      ball.vx = -speed + 1
      score1 = score1 + 1
      play_sound("bad")
      if score1 % 5 == 0 and score1 ~= 0 then
         play_sound("go")
      end
      if score1 == needed_to_win and score1 - score2 >= 2 then
         game_over = true
         winner = 1
      elseif score1 == needed_to_win then
         needed_to_win = needed_to_win + 1
      end
   end
end

function love.draw()
   love.graphics.translate(320, 200)

   if game_over then
      if score1 == 0 and score2 == 0 then
         love.graphics.setFont(bigfont)      
         love.graphics.setBackgroundColor(0, 0.1, 0.2, 1)
         love.graphics.setColor(1, 0.6, 0, 1)
         love.graphics.print("Lovely Pong",
                             -bigfont:getWidth("Lovely Pong")/2, -80)
         love.graphics.setColor(1, 1, 1, 1)
         love.graphics.setFont(midfont)
         love.graphics.print("Press [space]",
                             -midfont:getWidth("Press [space]")/2, 0)
         love.graphics.setFont(font)
         love.graphics.print("By liconaj",
                             -315, 200-font:getHeight("By liconaj")-5)
         return
      end
   end
   
   love.graphics.setFont(font)
   love.graphics.setBackgroundColor(0, 0.1, 0.2, 1)
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.print(score1, -50 - font:getWidth(score1)/2, -185)
   love.graphics.print(score2, 50 - font:getWidth(score2)/2, -185)
   for y=-200, 200, 20 do
      love.graphics.rectangle("fill", -2, y, 4, 10)
   end
   love.graphics.rectangle("fill", -300, pad1-40, 15, 80)
   love.graphics.rectangle("fill", 300-15, pad2-40, 15, 80)
   love.graphics.setColor(1, 0.6, 0, 1)
   love.graphics.circle("fill", ball.x, ball.y, 7)
   
   if game_over then
      love.graphics.setColor(0, 0.1, 0.2, 1)      
      love.graphics.rectangle("fill", -100, -100, 200, 200)
      love.graphics.setColor(1, 0.6, 0, 1)
      love.graphics.setFont(bigfont)
      love.graphics.print("Game Over",
                          -bigfont:getWidth("Game Over")/2, -70)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.print("Player " .. winner .. " wins!",
                          -bigfont:getWidth("Player" .. winner ..
                                            "wins")/2, 0)
   end
end
