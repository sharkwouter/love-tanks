--This is a simple tank game made by Wouter Wijsman

function love.load()
  
  --Create player object with variables
  player = {}
  player.x = 100
  player.y = 100
  player.speed = 64
  player.direction = 0
  player.tDirection = 0
  
  --Create mouse object, so we can track the mouse position
  mouse = {}
  
  --Initialize bullets
  bullets = {}
  bulletSpeed = 256
  
  
end

function love.update(dt)
  
  --calculate the direction in which the player's turrent should move
  mouse.x = love.mouse.getX()
  mouse.y = love.mouse.getY()
  player.tDirection = directionToPoint(player.x, player.y, mouse.x , mouse.y)
  
  --move player based on buttons pressed
  if love.keyboard.isDown("w") then
    player.x = player.x + math.sin(player.direction*math.pi/180) * player.speed * dt
    player.y = player.y + math.cos(player.direction*math.pi/180) * player.speed * dt
  end
  if love.keyboard.isDown("s") then
    player.x = player.x - math.sin(player.direction*math.pi/180) * player.speed * dt
    player.y = player.y - math.cos(player.direction*math.pi/180) * player.speed * dt
  end
  if love.keyboard.isDown("a") then
    player.direction = player.direction + 45 * dt
  end
  if love.keyboard.isDown("d") then
    player.direction = player.direction - 45 * dt
  end
  
  --Shoot
    if love.mouse.isDown('l') then
    createBullet(player.x, player.y, player.tDirection)
  end
  
  --Move all bullets
  for i, bullet in pairs(bullets) do
    bullet.x = bullet.x + math.sin(bullet.direction*math.pi/180) * bulletSpeed * dt
    bullet.y = bullet.y + math.cos(bullet.direction*math.pi/180) * bulletSpeed * dt
    
    --Remove the bullets which move off screen
    if pointIsOnScreen(bullets[i].x,bullets[i].y) == false then
      table.remove(bullets, i)
    end
  end
  
end

function love.draw()
  --Draw the player's tank
  drawTank(player.x, player.y, player.direction, player.tDirection)
  
  --Draw bullets
  for i, bullet in pairs(bullets) do
    love.graphics.circle('fill', bullet.x, bullet.y, 2)
  end
end

--Non-standard funcitons

--Draws tanks, like expected
--It is way too large and complex, I should use sprites instead of custom polygons which can rotate
function drawTank(xPos, yPos, bDirection, tDirection)
  tank = {}
  tank.body = {}
  tank.turret = {}
  tank.body.width = 64
  tank.body.height = 128
  
  tank.body.size = 64
  tank.turret.size = 16
  
  
  --Create the tank's body
  tank.body.points = {}
  
  tank.body.points[1] = {}
  tank.body.points[1].x = xPos + math.sin((bDirection-30)*math.pi/180) * tank.body.size/2;
  tank.body.points[1].y = yPos + math.cos((bDirection-30)*math.pi/180) * tank.body.size/2;
  
  tank.body.points[2] = {}
  tank.body.points[2].x = xPos + math.sin((bDirection+30)*math.pi/180) * tank.body.size/2;
  tank.body.points[2].y = yPos + math.cos((bDirection+30)*math.pi/180) * tank.body.size/2;
  
  tank.body.points[3] = {}
  tank.body.points[3].x = xPos + math.sin((bDirection+150)*math.pi/180) * tank.body.size/2;
  tank.body.points[3].y = yPos + math.cos((bDirection+150)*math.pi/180) * tank.body.size/2;
  
  tank.body.points[4] = {}
  tank.body.points[4].x = xPos + math.sin((bDirection+210)*math.pi/180) * tank.body.size/2;
  tank.body.points[4].y = yPos + math.cos((bDirection+210)*math.pi/180) * tank.body.size/2;
  
  love.graphics.polygon('line',
    tank.body.points[1].x, tank.body.points[1].y,
    tank.body.points[2].x, tank.body.points[2].y,
    tank.body.points[3].x, tank.body.points[3].y,
    tank.body.points[4].x, tank.body.points[4].y
  )
  
  --Create the tank's turret
  tank.turret.points = {}
  
  tank.turret.points[1] = {}
  tank.turret.points[1].x = xPos + math.sin((tDirection-30)*math.pi/180) * tank.turret.size/2;
  tank.turret.points[1].y = yPos + math.cos((tDirection-30)*math.pi/180) * tank.turret.size/2;
  
  tank.turret.points[2] = {}
  tank.turret.points[2].x = xPos + math.sin((tDirection+30)*math.pi/180) * tank.turret.size/2;
  tank.turret.points[2].y = yPos + math.cos((tDirection+30)*math.pi/180) * tank.turret.size/2;
  
  tank.turret.points[3] = {}
  tank.turret.points[3].x = xPos + math.sin((tDirection+150)*math.pi/180) * tank.turret.size/2;
  tank.turret.points[3].y = yPos + math.cos((tDirection+150)*math.pi/180) * tank.turret.size/2;
  
  tank.turret.points[4] = {}
  tank.turret.points[4].x = xPos + math.sin((tDirection+210)*math.pi/180) * tank.turret.size/2;
  tank.turret.points[4].y = yPos + math.cos((tDirection+210)*math.pi/180) * tank.turret.size/2;
  
  love.graphics.polygon('line',
    tank.turret.points[1].x, tank.turret.points[1].y,
    tank.turret.points[2].x, tank.turret.points[2].y,
    tank.turret.points[3].x, tank.turret.points[3].y,
    tank.turret.points[4].x, tank.turret.points[4].y
  )
  
end

--Calculated the direction to a point in degrees
function directionToPoint(orgX, orgY, aimX, aimY)
  deltaX = aimX - orgX
  deltaY = aimY - orgY
  result = math.atan2(deltaX, deltaY)
  return math.deg(result)
end

--Checks if a point is on screen, returns false if not
function pointIsOnScreen(xPos, yPos)
  result = true
  if xPos < 0 or yPos < 0 or xPos > love.graphics.getWidth() or yPos > love.graphics.getHeight() then
    result = false
  end
  return result
end

--Add a new bullet to the game
function createBullet(xPos, yPos, bulletDirection)
  newBullet = {}
    newBullet.x = xPos
    newBullet.y = yPos
    newBullet.direction = bulletDirection
    table.insert(bullets, newBullet)
  end