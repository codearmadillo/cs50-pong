local http = require "socket.http"
local ltn12 = require("ltn12")

--[[
  State
    0: New game
    1: Pause
    2: Play
    3: Result
]]
local GAME_STATE = 0
local CHAR_WHITELIST = 'yxcvbnmlkjhgfdsaqwertzuiop'
local CHAR_MEMORY = nil

game = { }

--[[
  Game state setters
]]
function game.new_game()
  GAME_STATE = 0
  -- Reset ball and player
  BALL:reset()
  PLAYER:reset()
  -- Reset score
  SCORE = 0
  -- Reset submit
  SCORE_NAME_INPUT = ''
  SCORE_SUBMITTED = false
  -- Reset map
  MAP:generate(true)
end
function game.pause_game()
  GAME_STATE = 1
end
function game.unpause_game()
  GAME_STATE = 2
end
function game.start_game()
  GAME_STATE = 2
end
function game.game_over()
  audio.gameover()
  if SCORE > MAX_SCORE then
    MAX_SCORE = SCORE
    SCORE_SHOW_SAVE = true
  else
    SCORE_SHOW_SAVE = false
  end
  GAME_STATE = 3
end

--[[
  Game state getters
]]
function game.is_new_game()
  return GAME_STATE == 0
end
function game.is_in_progress()
  return GAME_STATE == 2
end
function game.is_paused()
  return GAME_STATE == 1
end
function game.is_over()
  return GAME_STATE == 3
end
function game.register_name_input(key)
  if SCORE_SHOW_SAVE and not SCORE_SUBMITTED then
    -- Remove
    if key == 'backspace' and string.len(SCORE_NAME_INPUT) > 0 then
      SCORE_NAME_INPUT = SCORE_NAME_INPUT:sub(1, -2)
    end
    -- Enter characters
    if string.find(CHAR_WHITELIST, key) and string.len(SCORE_NAME_INPUT) < 16 then
      SCORE_NAME_INPUT = SCORE_NAME_INPUT .. (UPPERCASE and key:upper() or key:lower())
    end
    -- Submit
    if key == 'return' or key == 'enter' then
      if string.len(SCORE_NAME_INPUT) > 3 then
        game.submit_result();
      end
    end
  end
end
function game.submit_result()
  -- Get values
  local name = SCORE_NAME_INPUT
  local score = SCORE
  -- Submit
  local base = 'http://jirikralovec-cs50-pong.herokuapp.com/api/new'
  local data = '?name=' .. name .. '&score=' .. tostring(score);
  local a, b, c = http.request {
    url = base .. data,
    method = "POST",
    headers = {
      ["Content-Type"] = "application/json"
    },
    source = ltn12.source.empty()
  }
  if(b > 201) then
    print(c.status)
  else
    print("Saved")
  end
  -- And disable
  SCORE_SUBMITTED = true
  return
end