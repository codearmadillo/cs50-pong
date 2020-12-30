Map = Class{}

function Map:init()
  self:generate();
end

function Map:draw()
  for y = 0, BLOCKS_VERTICAL do
    for x = 0, BLOCKS_HORIZONTAL do
      if self.blocks[y][x] then
        self.blocks[y][x]:draw()
      end
    end
  end
end

function Map:update(dt)
  -- Clear colliders
  self.colliders = {}
  self.colliders_index = -1
  for y = 0, BLOCKS_VERTICAL do
    for x = 0, BLOCKS_HORIZONTAL do
      if self.blocks[y][x] then
        self.blocks[y][x]:update(dt)
      end
    end
  end
end

function Map:generate(start)
  if start then
    DIFFICULTY = 1
  end
  -- Colliders
  self.colliders = {}
  self.colliders_index = -1
  -- new blocks
  self.blocks = {}
  -- generate
  for y = 0, BLOCKS_VERTICAL do
    self.blocks[y] = {}
    for x = 0, BLOCKS_HORIZONTAL do
      self.blocks[y][x] = Block(x, y)
    end
  end
end

function Map:test_remove_all_blocks()
  for y = 0, BLOCKS_VERTICAL do
    for x = 0, BLOCKS_HORIZONTAL do
      self.blocks[y][x] = nil
    end
  end
  self:check_available_blocks()
end

function Map:check_available_blocks()
  print('Checking available blocks')
  local found = false
  for y = 0, BLOCKS_VERTICAL do
    for x = 0, BLOCKS_HORIZONTAL do
      if self.blocks[y][x] then
        found = true
        break
      end
    end
  end
  if not found then
    DIFFICULTY = DIFFICULTY + 1
    self:generate()
  end
end

function Map:has_colliders()
  return self.colliders_index > -1
end

function Map:add_block_collider(x, y)
  self.colliders_index = self.colliders_index + 1;
  self.colliders[self.colliders_index] = self.blocks[y][x];
end