--[[
  Vendor
]]
Class = require 'vendor.class'

--[[
  Dependencies
]]
require 'objects.audio'
require 'objects.screen'
require 'objects.game'
require 'objects.player'
require 'objects.ball'
require 'objects.block'
require 'objects.map'

--[[
  Constants
]]
WINDOW_WIDTH = 768
WINDOW_HEIGHT = 768
WINDOW_PADDING = 4
BALL_SPEED = 350
BLOCKS_HORIZONTAL = 10
BLOCKS_VERTICAL = 8
BLOCKS_AREA_X = math.floor(WINDOW_WIDTH * 0.75)
BLOCKS_AREA_Y = math.floor(WINDOW_HEIGHT * 0.2)

--[[
  Globals
]]
SCORE = 0
MAX_SCORE = 0
PLAYER = nil
MAP = nil
BALL = nil
SCORE_SHOW_SAVE = false
SCORE_NAME_INPUT = ''
SCORE_SUBMITTED = false
DIFFICULTY = 1
UPPERCASE = false

--[[
  Game loop
]]
function love.load()
  math.randomseed(os.time())
  -- Setup screen
  love.window.setTitle('Pong!');
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT);
  love.graphics.setDefaultFilter('nearest', 'nearest')
  screen.load()
  audio.load()
  -- Create objects
  PLAYER = Player()
  BALL = Ball()
  MAP = Map()
end
function love.draw()
  -- Clear
  love.graphics.clear();
  -- screen.render_fps()
  -- Base game
  screen.render_game()
  if not game.is_new_game() then
    screen.render_score()
  end
  -- Supporting screens  
  if game.is_paused() then
    screen.render_pause()
  elseif game.is_new_game() then
    screen.render_intro()
  elseif game.is_over() then
    screen.render_game_over()
  end  
end
function love.keyreleased(key)
  if key == 'lshift' or key == 'rshift' then
    UPPERCASE = false
  end
end
function love.keypressed(key)
  if key == 'lshift' or key == 'rshift' then
    UPPERCASE = true
  end
  if key == 'space' then
    if game.is_new_game() then
      game.start_game()
    end
    if game.is_over() then
      game.new_game()
    end
  end
  if key == 'escape' then
    if game.is_paused() then
      game.unpause_game()
    elseif game.is_in_progress() then
      game.pause_game()
    elseif game.is_over() then
      game.new_game()
    end
  end
  if game.is_over() then
    game.register_name_input(key)
  end
end
function love.update(dt)
  if game.is_in_progress() then
    MAP:update(dt)
    PLAYER:update(dt)
    BALL:update(dt)
  end
end