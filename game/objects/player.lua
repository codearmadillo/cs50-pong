Player = Class{}

function Player:init()
  self.width = 78;
  self.height = 6;
  self.speed = 600
  self:reset()
end
function Player:reset()
  self.x = WINDOW_WIDTH / 2 - self.width / 2;
  self.y = WINDOW_HEIGHT - self.height - WINDOW_PADDING;
end
function Player:draw()
  love.graphics.setColor(1, 1, 1, 1);
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 3)
end
function Player:update(dt)
  if love.keyboard.isDown('a') then
    self.x = self.x - self.speed * dt
  elseif love.keyboard.isDown('d') then
    self.x = self.x + self.speed * dt
  end
  -- Clamp
  if self.x < WINDOW_PADDING then
    self.x = WINDOW_PADDING
  end
  if self.x + self.width > WINDOW_WIDTH - WINDOW_PADDING then
    self.x = WINDOW_WIDTH - self.width - WINDOW_PADDING
  end
end