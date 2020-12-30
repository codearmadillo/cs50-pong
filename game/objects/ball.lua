Ball = Class{}

function Ball:init()
  self.width = 8
  self.height = 8
  self:reset()
end

function Ball:draw()
  -- trace
  love.graphics.setColor(1, 1, 1, 0.35)
  love.graphics.rectangle('fill', self.trace_x, self.trace_y, self.width, self.height)
  -- ball
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:reset()
  -- Position
  self.x = math.random(32, WINDOW_WIDTH - 32)
  self.y = math.random(WINDOW_HEIGHT / 2, WINDOW_HEIGHT - WINDOW_HEIGHT / 3)
  self.trace_x = self.x
  self.trace_y = self.y
  -- Velocity
  self.dx = BALL_SPEED
  self.dy = BALL_SPEED
end

function Ball:update(dt)
  -- Trace
  self.trace_x = self.x
  self.trace_y = self.y
  -- Move ball
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
  -- Player collision - Bounce UP
  if self:collides_with_player() then
    -- Speed adjusted
    audio.bounce()
  elseif self:collides_with_wall() then
    -- Speed adjusted
    audio.bounce()
  else
    -- End of game
    if self.y + self.height >= WINDOW_HEIGHT - WINDOW_PADDING then
      game.game_over()
    else
      -- Wall collisions
      if self.x <= WINDOW_PADDING then
        self.x = WINDOW_PADDING
        self.dx = self:reverse_x()
      elseif self.x + self.width >= WINDOW_WIDTH - WINDOW_PADDING  then
        self.x = WINDOW_WIDTH - WINDOW_PADDING - self.width
        self.dx = -self.dx
      end
      if self.y <= WINDOW_PADDING then
        self.y = WINDOW_PADDING
        self.dy = -self.dy
      end
    end  
  end
end

--[[
  Returns number based
]]
function Ball:collides_with_wall()
  local collision_x = false
  local collision_y = false
  -- Iterate through colliders
  if MAP:has_colliders() then
    -- Check collisions with all colliders
    for i = 0, MAP.colliders_index do
      -- Break if collisions are already found
      if collision_x and collision_y then
        break
      end
      -- Get block
      local block = MAP.colliders[i]
      -- Check collisions on Y
      if collision_y == false then
        if self.dy < 0 then
          if block.render_x < self.x + self.width and block.render_x + block.width > self.x then
            if block.render_y + block.height > self.y - 5 then
              -- Trigger collision
              collision_y = true
              -- Change Y to corresponding block
              self.y = block.render_y + block.height
              -- Add points
              SCORE = SCORE + 1
              -- Destroy object
              MAP.blocks[block.y][block.x] = nil
            end
          end
        end
      end
      -- Check collision on X
      if collision_x == false and collision_y == false then
        -- Hello
      end
    end
  end
  -- Conditionally return
  if collision_x or collision_y then
    if collision_x then
      self.dx = self:reverse_x()
    else
      self.dy = -self.dy
    end
    MAP:check_available_blocks()
    return true
  else
    return false
  end
end

function Ball:reverse_x()
  return math.random(self.dx * 0.8, self.dx * 1.2) * -1
end

function Ball:collides_with_player()
  if self.dy > 0 and self.y + self.height >= PLAYER.y and self.x < PLAYER.x + PLAYER.width and self.x + self.width > PLAYER.x then
    self.dy = -self.dy
    return true
  else
    return false
  end
end