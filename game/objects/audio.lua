audio = {}
audio.sources = {}

function audio.load()
  audio.sources = {
    bounce = love.audio.newSource('assets/pong.wav', 'static'),
    gameOver = love.audio.newSource('assets/game-over.wav', 'static')
  }
end

function audio.bounce()
  audio.sources.bounce:play()
end

function audio.gameover()
  audio.sources.gameOver:play()
end