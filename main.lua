-- "Nome do Jogo" Project
-- Developed By Yuri Cesar

-- Hide Status Bar

display.setStatusBar(display.HiddenStatusBar)

-- Import MovieClip

local movieclip = require('movieclip')

-- Graphics

-- [Background]

local bg = display.newImage('gameBg.png')

-- [Title View]

local titleBg
local playBtn
local creditsBtn
local titleView

-- [Credits]

local creditsView

-- [Score]

local score

-- [Time]
local clockTimer
local countDownText
local gameTime = 30

-- [Worms]

local m1
local m2
local m3
local m4
local m5
local m6
local m7
local m8

local moles
local lastMole = {}

-- Load Sound

local hit = audio.loadSound('hit.wav')
local gameOver = audio.loadSound('game_over.mp3')

-- Variables
  
local groundHogXPositions = {80.5,198.5,338.5,70.5,225.5,376.5,142.5,356.5}
local groundHogYPositions = {11,51,34,110,136,96,211,186}

local timerSource
local currentMoles = 0
local molesHit = 0

-- Functions

local Main = {}
local startButtonListeners = {}
local showCredits = {}
local hideCredits = {}
local showGameView = {}
local prepareMoles = {}
local startTimer = {}
local doCountdown = {}
local showMole = {}
local popOut = {}
local moleHit = {}
local alert = {}

-- Main Function

function Main()
  titleBg = display.newImage('titleBg.png')
  playBtn = display.newImage('playBtn.png', display.contentCenterX - 25.5, display.contentCenterY + 40)
  creditsBtn = display.newImage('creditsBtn.png', display.contentCenterX - 40.5, display.contentCenterY + 85)
  titleView = display.newGroup(titleBg, playBtn, creditsBtn)
  media.playSound("gameTrack.mp3",soundComplete)
  startButtonListeners('add')
end

function startButtonListeners(action)
  if(action == 'add') then
    playBtn:addEventListener('tap', showGameView)
    creditsBtn:addEventListener('tap', showCredits)
  else
    playBtn:removeEventListener('tap', showGameView)
    creditsBtn:removeEventListener('tap', showCredits)
  end
end

function showCredits:tap(e)
  playBtn.isVisible = false
  creditsBtn.isVisible = false
  creditsView = display.newImage('creditsView.png')
  transition.from(creditsView, {time = 300, x = -creditsView.width, onComplete = function() creditsView:addEventListener('tap', hideCredits) creditsView.x = creditsView.x - 0.5 end})
end

function hideCredits:tap(e)
  playBtn.isVisible = true
  creditsBtn.isVisible = true
  transition.to(creditsView, {time = 300, x = -creditsView.width, onComplete = function() creditsView:removeEventListener('tap', hideCredits) display.remove(creditsView) creditsView = nil end})
end

function showGameView:tap(e)
  transition.to(titleView, {time = 300, x = -titleView.height, onComplete = function() startButtonListeners('rmv') display.remove(titleView) titleView = nil end})
  score = display.newText('0' , 70, 6, native.systemFontBold, 16)
  score:setTextColor(238, 238, 238)
  countDownText = display.newText(gameTime,290,10,native.systemFontBold,20)
  countDownText:setTextColor(238, 238, 238)
  prepareMoles()
end

function prepareMoles()
   m1 = display.newImage('mole.png', 80.5, 11)
  m2 = display.newImage('mole.png', 198.5, 51)
  m3 = display.newImage('mole.png', 338.5, 34)
  m4 = display.newImage('mole.png', 70.5, 110)
  m5 = display.newImage('mole.png', 225.5, 136)
  m6 = display.newImage('mole.png', 376.5, 96)
  m7 = display.newImage('mole.png', 142.5, 211)
  m8 = display.newImage('mole.png', 356.5, 186)
 
  moles = display.newGroup(m1, m2, m3, m4, m5, m6, m7, m8)

  for i = 1, moles.numChildren do
    moles[i]:addEventListener('tap', moleHit)
    moles[i].isVisible = false
  end

  startTimer()
end

function startTimer()
  timerSource = timer.performWithDelay(1000, showMole, 0)
  clockTimer = timer.performWithDelay(1000,doCountdown,gameTime)
end

function doCountdown()
  local currentTime = countDownText.text
  currentTime = currentTime -1
  countDownText.text = currentTime
  if(currentTime == 0) then
    alert()
  end
end

function showMole(e)
  lastMole.isVisible = false 
  local randomHole = math.floor(math.random() * 8) + 1
  lastMole = display.newImage('mole.png',groundHogXPositions[randomHole],groundHogYPositions[randomHole])
  lastMole:addEventListener('tap', moleHit)
 -- lastMole = moles[randomHole]

  lastMole:setReferencePoint(display.BottomCenterReferencePoint)
  lastMole.yScale = 0.1
  lastMole.isVisible = true

  Runtime:addEventListener('enterFrame', popOut)

  currentMoles = currentMoles + 1

end

function popOut(e)
  lastMole.yScale = lastMole.yScale + 0.2

  if(lastMole.yScale >= 1) then
    Runtime:removeEventListener('enterFrame', popOut)
  end
end

function moleHit:tap(e)
  audio.play(hit)
  molesHit = molesHit + 10
  score.text = molesHit
  lastMole.isVisible = false
end

function alert()
  timer.cancel(clockTimer)
  timer.cancel(timerSource)
  lastMole.isVisible = false
  audio.play(gameOver)
  local alert = display.newImage('alertBg.png')
  alert:setReferencePoint(display.CenterReferencePoint)
  alert.x = display.contentCenterX
  alert.y = display.contentCenterY
  transition.from(alert, {time = 300, xScale = 0.3, yScale = 0.3})
  local score = display.newText(molesHit, 220, 190, native.systemFontBold, 20)
  score:setTextColor(204, 152, 102)
end

Main()
