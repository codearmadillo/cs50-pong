Block = Class{}

function Block:init(x, y)
  self.width = BLOCKS_AREA_X / BLOCKS_HORIZONTAL
  self.height = BLOCKS_AREA_Y / BLOCKS_VERTICAL
  self.x = x
  self.y = y
  self.offset_x = (WINDOW_WIDTH - BLOCKS_AREA_X) / 4
  self.offset_y = 72
  self.color = 1 - (self.y * 0.08)
  self.collision_detection = false
  -- render offset
  self.render_x = self.offset_x + self.x * (self.width + 4)
  self.render_y = self.offset_y + self.y * (self.height + 4)
end

function Block:draw()
  love.graphics.setColor(self.color, self.color, self.color, 1)
  love.graphics.rectangle(
    'fill',
    self.render_x + 1, self.render_y + 1,
    self.width - 2, self.height - 2
  )
  -- Outlines
  love.graphics.setLineWidth(1)
  love.graphics.setColor(self.color, self.color, self.color, 0.5)
  love.graphics.line(
    self.render_x, self.render_y,
    self.render_x, self.render_y + self.height,
    self.render_x + self.width, self.render_y + self.height
  )
  love.graphics.setColor(self.color, self.color, self.color, .75)
  love.graphics.line(
    self.render_x + 1, self.render_y,
    self.render_x + self.width, self.render_y,
    self.render_x + self.width, self.render_y + self.height - 1
  )
end

function Block:update(dt)
  -- Check collisions with ball locally (rough collisions to prevent unrequired looping through all blocks in ball's update)
  if BALL.y < WINDOW_HEIGHT * 0.5 then
    -- Y collision
    if BALL.y + BALL.height > self.render_y - self.height and BALL.y < self.render_y + self.height * 2 then
      -- X collision
      if BALL.x + BALL.width > self.render_x - self.width and BALL.x < self.render_x + self.width * 2 then
        self.collision_detection = true
      else
        self.collision_detection = false
      end
    else
      self.collision_detection = false
    end
  else
    self.collision_detection = false
  end
  -- Add collision to map collision list
  if self.collision_detection then
    MAP:add_block_collider(self.x, self.y)
  end
end