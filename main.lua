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

-- [Worms]

local w1
local w2
local w3
local w4
local w5
local w6
local w7
local w8

local worms
local lastWorm = {}

-- Load Sound

local hit = audio.loadSound('hit.wav')

-- Variables

local timerSource
local currentWorms = 0
local wormsHit = 0
local totalWorms = 10

-- Functions

local Main = {}
local startButtonListeners = {}
local showCredits = {}
local hideCredits = {}
local showGameView = {}
local prepareWorms = {}
local startTimer = {}
local showWorm = {}
local popOut = {}
local wormHit = {}
local alert = {}

-- Main Function

function Main()
	titleBg = display.newImage('titleBg.png')
	playBtn = display.newImage('playBtn.png', display.contentCenterX - 25.5, display.contentCenterY + 40)
	creditsBtn = display.newImage('creditsBtn.png', display.contentCenterX - 40.5, display.contentCenterY + 85)
	titleView = display.newGroup(titleBg, playBtn, creditsBtn)
	
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
	score = display.newText('0' .. '/' .. totalWorms, 58, 6, native.systemFontBold, 16)
	score:setTextColor(238, 238, 238)
	prepareWorms()
end

function prepareWorms()
	w1 = display.newImage('worm.png', 80.5, 11)
	w2 = display.newImage('worm.png', 198.5, 51)
	w3 = display.newImage('worm.png', 338.5, 34)
	w4 = display.newImage('worm.png', 70.5, 110)
	w5 = display.newImage('worm.png', 225.5, 136)
	w6 = display.newImage('worm.png', 376.5, 96)
	w7 = display.newImage('worm.png', 142.5, 211)
	w8 = display.newImage('worm.png', 356.5, 186)
	
	worms = display.newGroup(w1, w2, w3, w4, w5, w6, w7, w8)
	
	for i = 1, worms.numChildren do
		worms[i]:addEventListener('tap', wormHit)
		worms[i].isVisible = false
	end
	
	startTimer()
end

function startTimer()
	timerSource = timer.performWithDelay(1400, showWorm, 0)
end

function showWorm(e)
	if(currentWorms == totalWorms) then
		alert()
	else
		lastWorm.isVisible = false
		local randomHole = math.floor(math.random() * 8) + 1
		
		lastWorm = worms[randomHole]
		lastWorm:setReferencePoint(display.BottomCenterReferencePoint)
		lastWorm.yScale = 0.1
		lastWorm.isVisible = true
		
		Runtime:addEventListener('enterFrame', popOut)
		
		currentWorms = currentWorms + 1
	end
end

function popOut(e)
	lastWorm.yScale = lastWorm.yScale + 0.2
	
	if(lastWorm.yScale >= 1) then
		Runtime:removeEventListener('enterFrame', popOut)
	end
end

function wormHit:tap(e)
	audio.play(hit)
	wormsHit = wormsHit + 1
	score.text = wormsHit .. '/' .. totalWorms
	lastWorm.isVisible = false
end

function alert()
	timer.cancel(timerSource)
	lastWorm.isVisible = false
	
	local alert = display.newImage('alertBg.png')
	alert:setReferencePoint(display.CenterReferencePoint)
	alert.x = display.contentCenterX
	alert.y = display.contentCenterY
	transition.from(alert, {time = 300, xScale = 0.3, yScale = 0.3})
	
	local score = display.newText(wormsHit .. '/' .. totalWorms, 220, 190, native.systemFontBold, 20)
	score:setTextColor(204, 152, 102)
end

Main()