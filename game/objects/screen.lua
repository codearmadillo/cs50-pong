screen = {}
screen.fonts = {}

function screen.load()
  print("Loading screen");
  -- Load fonts
  screen.fonts = {
    title = love.graphics.newFont('assets/slkscr.ttf', 38, 'mono'),
    controls = love.graphics.newFont('assets/slkscr.ttf', 21, 'mono'),
    score = love.graphics.newFont('assets/slkscr.ttf', 21, 'mono'),
    fps = love.graphics.newFont('assets/slkscr.ttf', 18, 'mono'),
    credits = love.graphics.newFont('assets/slkscr.ttf', 15, 'mono')
  }
end
function screen.render_fps()
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.setFont(screen.fonts.fps)
  love.graphics.print(
    'FPS: ' .. tostring(love.timer.getFPS()), 32, 32
  )
end
function screen.render_score()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(screen.fonts.score)
  love.graphics.print(
    'Score: ' .. tostring(SCORE), 32, WINDOW_HEIGHT - 48
  )
end
function screen.render_intro()
  -- Backdrop
  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  -- Title
  love.graphics.setFont(screen.fonts.title)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Welcome to Pong!", 0, WINDOW_HEIGHT / 2 - 8, WINDOW_WIDTH, "center")
  -- Directions
  love.graphics.setFont(screen.fonts.controls)
  love.graphics.printf("Press Space to start the game", 0, WINDOW_HEIGHT / 2 + 54, WINDOW_WIDTH, "center")
  -- Credits
  love.graphics.setFont(screen.fonts.credits)
  love.graphics.printf("Silkscreen font by Jason Kottke (jason@kottke.org)", 32, WINDOW_HEIGHT - 96, WINDOW_WIDTH - 64, "center")
  love.graphics.printf("Pong sound by NoiseCollector (freesound.org/people/NoiseCollector)", 32, WINDOW_HEIGHT - 72, WINDOW_WIDTH - 64, "center")
  love.graphics.printf("Game over sound by myfox14 (freesound.org/people/myfox14)", 32, WINDOW_HEIGHT - 48, WINDOW_WIDTH - 64, "center") 
end
function screen.render_pause()
  -- Backdrop
  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  -- Title
  love.graphics.setFont(screen.fonts.title)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Paused", 0, WINDOW_HEIGHT / 2 - 8, WINDOW_WIDTH, "center")
end
function screen.render_game_over()
  -- Backdrop
  love.graphics.setColor(0, 0, 0, 0.5)
  love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  -- Title
  love.graphics.setFont(screen.fonts.title)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Game over!", 0, WINDOW_HEIGHT / 2 - 46, WINDOW_WIDTH, "center")
  -- Save score
  if SCORE_SHOW_SAVE then
    love.graphics.setFont(screen.fonts.controls)
    love.graphics.printf("New high score reached! Enter your name and press Enter to submit! Press Escape to play again", 32, WINDOW_HEIGHT / 2, WINDOW_WIDTH - 32, "center")
    if not SCORE_SUBMITTED then
      -- Name
      love.graphics.setLineWidth(2)
      love.graphics.line(
        WINDOW_WIDTH / 2 - 150, WINDOW_HEIGHT - 128,
        WINDOW_WIDTH / 2 + 150, WINDOW_HEIGHT - 128
      )
      love.graphics.printf(SCORE_NAME_INPUT, WINDOW_WIDTH / 2 - 150, WINDOW_HEIGHT - 156, 300, "center")
    else
      love.graphics.printf("Score submitted. Go to jirikralovec-cs50-pong.herokuapp.com to see results", WINDOW_WIDTH / 2 - 275, WINDOW_HEIGHT - 156, 550, "center")
    end
  end
end
function screen.render_game()
  PLAYER:draw();
  BALL:draw();
  MAP:draw()
end