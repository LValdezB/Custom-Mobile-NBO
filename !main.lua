setDefaultTab ("Main");
UI.Label("NBO Brasil")
UI.Button("Official Discord", function() g_platform.openUrl("https://discord.gg/C3U7CD58vk") end)

UI.Button("Official Site", function() g_platform.openUrl("https://www.nbosimulator.com") end)
UI.Separator()
local panelName = "playerList"
  local ui = setupUI([[
Panel
  height: 18

  Button
    id: editList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    background: #292A2A
    height: 18
    text: Player Lists
  ]], parent)
  ui:setId(panelName)
ui:setId(panelName)
local playerListWindow = setupUI([[
PlayerName < Label
  background-color: alpha
  text-offset: 2 0
  focusable: true
  height: 16

  $focus:
    background-color: #00000055

  Button
    id: remove
    !text: tr('x')
    anchors.right: parent.right
    margin-right: 15
    width: 15
    height: 15

MainWindow
  !text: tr('Player Lists')
  size: 580 350
  @onEscape: self:hide()

  Label
    anchors.left: FriendList.left
    anchors.top: parent.top
    anchors.right: FriendList.right
    text-align: center
    text: Friends List
    margin-right: 3 

  TextList
    id: FriendList
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 15
    margin-bottom: 5
    margin-right: 3
    padding: 1
    width: 180
    height: 160
    vertical-scrollbar: FriendListScrollBar

  VerticalScrollBar
    id: FriendListScrollBar
    anchors.top: FriendList.top
    anchors.bottom: FriendList.bottom
    anchors.right: FriendList.right
    step: 14
    pixels-scroll: true

  TextEdit
    id: FriendName
    anchors.right: FriendList.right
    anchors.left: FriendList.left
    anchors.top: FriendList.bottom
    margin-right: 3    
    margin-top: 5

  Button
    id: AddFriend
    !text: tr('Add Friend')
    anchors.right: FriendList.right
    anchors.left: FriendList.left
    anchors.top: prev.bottom
    margin-right: 3    
    margin-top: 3

  Label
    anchors.right: EnemyList.right
    anchors.top: parent.top
    anchors.left: EnemyList.left
    text-align: center
    text: Enemy List
    margin-left: 3     

  TextList
    id: EnemyList
    anchors.top: parent.top
    anchors.left: FriendList.right
    margin-top: 15
    margin-bottom: 5
    margin-left: 3
    padding: 1
    width: 180
    height: 160
    vertical-scrollbar: EnemyListScrollBar

  VerticalScrollBar
    id: EnemyListScrollBar
    anchors.top: EnemyList.top
    anchors.bottom: EnemyList.bottom
    anchors.right: EnemyList.right
    step: 14
    pixels-scroll: true

  TextEdit
    id: EnemyName
    anchors.left: EnemyList.left
    anchors.right: EnemyList.right
    anchors.top: EnemyList.bottom
    margin-left: 3    
    margin-top: 5

  Button
    id: AddEnemy
    !text: tr('Add Enemy')
    anchors.left: EnemyList.left
    anchors.right: EnemyList.right
    anchors.top: prev.bottom
    margin-left: 3    
    margin-top: 3

  Label
    anchors.right: BlackList.right
    anchors.top: parent.top
    anchors.left: BlackList.left
    text-align: center
    text: Anty RS List
    margin-left: 3   

  TextList
    id: BlackList
    anchors.top: parent.top
    anchors.left: EnemyList.right
    margin-top: 15
    margin-bottom: 5
    margin-left: 3
    padding: 1
    width: 180
    height: 160
    vertical-scrollbar: BlackListScrollBar

  VerticalScrollBar
    id: BlackListScrollBar
    anchors.top: BlackList.top
    anchors.bottom: BlackList.bottom
    anchors.right: BlackList.right
    step: 14
    pixels-scroll: true

  TextEdit
    id: BlackName
    anchors.left: BlackList.left
    anchors.right: BlackList.right
    anchors.top: BlackList.bottom
    margin-left: 3    
    margin-top: 5

  Button
    id: AddBlack
    !text: tr('Add Anty-RS')
    anchors.left: BlackList.left
    anchors.right: BlackList.right
    anchors.top: prev.bottom
    margin-left: 3    
    margin-top: 3

  BotSwitch
    id: Members
    anchors.left: parent.left
    anchors.top: AddEnemy.bottom
    margin-top: 15
    width: 135
    text-align: center
    text: Group Members  

  BotSwitch
    id: Outfit
    anchors.bottom: prev.bottom
    anchors.left: prev.right
    margin-left: 3
    width: 135
    text-align: center
    text: Color Outfits

  BotSwitch
    id: Marks
    anchors.bottom: prev.bottom
    anchors.left: prev.right
    width: 135
    margin-left: 3
    text-align: center
    text: Not Ally = Enemy    

  BotSwitch
    id: Highlight    
    anchors.bottom: prev.bottom
    anchors.left: prev.right
    width: 135
    margin-left: 3
    text-align: center
    text: Highlight     

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8    

  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-top: 15
    margin-right: 5    
]], g_ui.getRootWidget())

if not storage[panelName] then
  storage[panelName] = {
    enemyList = {},
    friendList = {},
    blackList = {},
    groupMembers = true,
    outfits = false,
    marks = false,
    highlight = false
  }
end

local config = storage[panelName]
-- for backward compability
if not config.blackList then
  config.blackList = {}
end


-- functions
local function clearCachedPlayers()
  CachedFriends = {}
  CachedEnemies = {}
end

local refreshStatus = function()
  for _, spec in ipairs(getSpectators()) do
    if spec:isPlayer() and not spec:isLocalPlayer() then
      if config.outfits then
        local specOutfit = spec:getOutfit()
        if isFriend(spec:getName()) then
          if config.highlight then
            spec:setMarked('#0000FF')
          end
          specOutfit.head = 88
          specOutfit.body = 88
          specOutfit.legs = 88
          specOutfit.feet = 88
          if storage.BOTserver.outfit then
            local voc = vBot.BotServerMembers[spec:getName()]
            specOutfit.addons = 3 
            if voc == 1 then
              specOutfit.type = 131
            elseif voc == 2 then
              specOutfit.type = 129
            elseif voc == 3 then
              specOutfit.type = 130
            elseif voc == 4 then
              specOutfit.type = 144
            end
          end
          spec:setOutfit(specOutfit)
        elseif isEnemy(spec:getName()) then
          if config.highlight then
            spec:setMarked('#FF0000')
          end
          specOutfit.head = 94
          specOutfit.body = 94
          specOutfit.legs = 94
          specOutfit.feet = 94
          spec:setOutfit(specOutfit)
        end
      end
    end
  end
end
refreshStatus()

local checkStatus = function(creature)
  if not creature:isPlayer() or creature:isLocalPlayer() then return end

  local specName = creature:getName()
  local specOutfit = creature:getOutfit()

  if isFriend(specName) then
    if config.highlight then
      creature:setMarked('#0000FF')
    end
    if config.outfits then
      specOutfit.head = 88
      specOutfit.body = 88
      specOutfit.legs = 88
      specOutfit.feet = 88
      if storage.BOTserver.outfit then
        local voc = vBot.BotServerMembers[creature:getName()]
        specOutfit.addons = 3 
        if voc == 1 then
          specOutfit.type = 131
        elseif voc == 2 then
          specOutfit.type = 129
        elseif voc == 3 then
          specOutfit.type = 130
        elseif voc == 4 then
          specOutfit.type = 144
        end
      end
      creature:setOutfit(specOutfit)
    end
  elseif isEnemy(specName) then
    if config.highlight then
      creature:setMarked('#FF0000')
    end
    if config.outfits then
      specOutfit.head = 94
      specOutfit.body = 94
      specOutfit.legs = 94
      specOutfit.feet = 94
      creature:setOutfit(specOutfit)
    end
  end
end

-- eof

-- UI
rootWidget = g_ui.getRootWidget()
playerListWindow:hide()

playerListWindow.Members:setOn(config.groupMembers)
playerListWindow.Members.onClick = function(widget)
  config.groupMembers = not config.groupMembers
  if not config then
    clearCachedPlayers()
  end
  refreshStatus()
  widget:setOn(config.groupMembers)
end
playerListWindow.Outfit:setOn(config.outfits)
playerListWindow.Outfit.onClick = function(widget)
  config.outfits = not config.outfits
  widget:setOn(config.outfits)
end
playerListWindow.Marks:setOn(config.marks)
playerListWindow.Marks.onClick = function(widget)
  config.marks = not config.marks
  widget:setOn(config.marks)
end
playerListWindow.Highlight:setOn(config.highlight)
playerListWindow.Highlight.onClick = function(widget)
  config.highlight = not config.highlight
  widget:setOn(config.highlight)
end

if config.enemyList and #config.enemyList > 0 then
  for _, name in ipairs(config.enemyList) do
    local label = g_ui.createWidget("PlayerName", playerListWindow.EnemyList)
    label.remove.onClick = function(widget)
      table.removevalue(config.enemyList, label:getText())
      label:destroy()
    end
    label:setText(name)
  end
end

if config.blackList and #config.blackList > 0 then
  for _, name in ipairs(config.blackList) do
    local label = g_ui.createWidget("PlayerName", playerListWindow.BlackList)
    label.remove.onClick = function(widget)
      table.removevalue(config.blackList, label:getText())
      label:destroy()
    end
    label:setText(name)
  end
end

if config.friendList and #config.friendList > 0 then
  for _, name in ipairs(config.friendList) do
    local label = g_ui.createWidget("PlayerName", playerListWindow.FriendList)
    label.remove.onClick = function(widget)
      table.removevalue(config.friendList, label:getText())
      label:destroy()
    end
    label:setText(name)
  end
end

playerListWindow.AddFriend.onClick = function(widget)
  local friendName = playerListWindow.FriendName:getText()
  if friendName:len() > 0 and not table.contains(config.friendList, friendName, true) then
    table.insert(config.friendList, friendName)
    local label = g_ui.createWidget("PlayerName", playerListWindow.FriendList)
    label.remove.onClick = function(widget)
      table.removevalue(config.friendList, label:getText())
      label:destroy()
    end
    label:setText(friendName)
    playerListWindow.FriendName:setText('')
    clearCachedPlayers()
    refreshStatus()
  end
end

playerListWindow.AddEnemy.onClick = function(widget)
  local enemyName = playerListWindow.EnemyName:getText()
  if enemyName:len() > 0 and not table.contains(config.enemyList, enemyName, true) then
    table.insert(config.enemyList, enemyName)
    local label = g_ui.createWidget("PlayerName", playerListWindow.EnemyList)
    label.remove.onClick = function(widget)
      table.removevalue(config.enemyList, label:getText())
      label:destroy()
    end
    label:setText(enemyName)
    playerListWindow.EnemyName:setText('')
    clearCachedPlayers()
    refreshStatus()
  end
end 

playerListWindow.AddBlack.onClick = function(widget)
  local blackName = playerListWindow.BlackName:getText()
  if blackName:len() > 0 and not table.contains(config.blackList, blackName, true) then
    table.insert(config.blackList, blackName)
    local label = g_ui.createWidget("PlayerName", playerListWindow.BlackList)
    label.remove.onClick = function(widget)
      table.removevalue(config.blackList, label:getText())
      label:destroy()
    end
    label:setText(blackName)
    playerListWindow.BlackName:setText('')
    clearCachedPlayers()
    refreshStatus()
  end
end 

ui.editList.onClick = function(widget)
  playerListWindow:show()
  playerListWindow:raise()
  playerListWindow:focus()
end
playerListWindow.closeButton.onClick = function(widget)
  playerListWindow:hide()
end


-- execution

onCreatureAppear(function(creature)
checkStatus(creature)
end)

onPlayerPositionChange(function(x,y)
if x.z ~= y.z then
  schedule(20, function()
    refreshStatus()
  end)
end
end)
UI.Separator()
local panelName = "alarms"
local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Alarms')

  Button
    id: alerts
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Edit

]])
ui:setId(panelName)
local alarmsWindow = setupUI([[
MainWindow
  !text: tr('Alarms')
  size: 300 280
  @onEscape: self:hide()

  BotSwitch
    id: playerAttack
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    text: Player Attack
    !tooltip: tr('Alerts when attacked by player.')

  BotSwitch
    id: playerDetected
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 4
    text-align: center
    text: Player Detected
    !tooltip: tr('Alerts when a player is detected on screen.')

  CheckBox
    id: playerDetectedLogout
    anchors.top: playerDetected.top
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-top: 3
    margin-left: 4
    text: Logout
    !tooltip: tr('Attempts to logout when a player is detected on screen.')

  BotSwitch
    id: ignoreFriends
    anchors.left: parent.left
    anchors.top: playerDetected.bottom
    anchors.right: parent.right
    text-align: center
    margin-top: 4
    text: Ignore Friends
    !tooltip: tr('Player detection alerts will ignore friends.')

  HorizontalSeparator
    id: sepPlayer
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 4

  BotSwitch
    id: creatureDetected
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: sepPlayer.bottom
    margin-top: 4
    text-align: center
    text: Creature Detected
    !tooltip: tr('Alerts when a creature is detected on screen.')

  BotSwitch
    id: warnBoss
    anchors.left: parent.left
    anchors.top: prev.bottom
    anchors.right: parent.horizontalCenter
    text-align: center
    margin-top: 5
    text: Creature Name
    !tooltip: tr('Alerts when a creature/npc with name is detected on screen. \n eg: Benjamin or [boss] would detect a creature with [boss] in name. \n You can add many examples, just separate them by comma.')

  BotTextEdit
    id: bossName
    anchors.left: prev.right
    margin-left: 4
    anchors.top: prev.top
    anchors.right: parent.right
    margin-top: 1
    height: 17
    font: terminus-10px

  HorizontalSeparator
    id: sepCreature
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 4

  BotSwitch
    id: healthBelow
    anchors.left: parent.left
    anchors.top: prev.bottom
    anchors.right: parent.horizontalCenter
    text-align: center
    margin-top: 4
    text: Health < 50%

  HorizontalScrollBar
    id: healthValue
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: healthBelow.top
    margin-left: 3
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1

  BotSwitch
    id: manaBelow
    anchors.left: parent.left
    anchors.top: healthBelow.bottom
    anchors.right: parent.horizontalCenter
    text-align: center
    margin-top: 4
    text: Mana < 50%

  HorizontalScrollBar
    id: manaValue
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: manaBelow.top
    margin-left: 3
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1

  HorizontalSeparator
    id: sepMessages
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 4

  BotSwitch
    id: privateMessage
    anchors.left: parent.left
    anchors.top: prev.bottom
    anchors.right: parent.right
    text-align: center
    margin-top: 4
    text: Private Message
    !tooltip: tr('Alerts when recieving a private message.')

  BotSwitch
    id: warnMessage
    anchors.left: parent.left
    anchors.top: prev.bottom
    anchors.right: parent.horizontalCenter
    text-align: center
    margin-top: 5
    text: Message Alert
    !tooltip: tr('Alerts when players receive a message that contains given part. \n Eg. event - will trigger alert whenever a message with word event appears. \n You can give many examples, just separate them by comma.')

  BotTextEdit
    id: messageText
    anchors.left: prev.right
    margin-left: 4
    anchors.top: prev.top
    anchors.right: parent.right
    margin-top: 1
    height: 17
    font: terminus-10px

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8

  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-top: 15
    margin-right: 5  
]], g_ui.getRootWidget())

if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
    playerAttack = false,
    playerDetected = false,
    playerDetectedLogout = false,
    creatureDetected = false,
    healthBelow = false,
    healthValue = 40,
    manaBelow = false,
    manaValue = 50,
    privateMessage = false,
    ignoreFriends = true,
    warnBoss = false,
    bossName = '[B]'
}
end



local config = storage[panelName]

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
config.enabled = not config.enabled
widget:setOn(config.enabled)
end

-- new var's validation
config.messageText = config.messageText or ""
config.bossName = config.bossName or ""

rootWidget = g_ui.getRootWidget()
if rootWidget then
  alarmsWindow:hide()

  alarmsWindow.closeButton.onClick = function(widget)
    alarmsWindow:hide()
  end

  alarmsWindow.playerAttack:setOn(config.playerAttack)
  alarmsWindow.playerAttack.onClick = function(widget)
    config.playerAttack = not config.playerAttack
    widget:setOn(config.playerAttack)
  end

  alarmsWindow.playerDetected:setOn(config.playerDetected)
  alarmsWindow.playerDetected.onClick = function(widget)
    config.playerDetected = not config.playerDetected
    widget:setOn(config.playerDetected)
  end

  alarmsWindow.playerDetectedLogout:setChecked(config.playerDetectedLogout)
  alarmsWindow.playerDetectedLogout.onClick = function(widget)
    config.playerDetectedLogout = not config.playerDetectedLogout
    widget:setChecked(config.playerDetectedLogout)
  end

  alarmsWindow.creatureDetected:setOn(config.creatureDetected)
  alarmsWindow.creatureDetected.onClick = function(widget)
    config.creatureDetected = not config.creatureDetected
    widget:setOn(config.creatureDetected)
  end

  alarmsWindow.healthBelow:setOn(config.healthBelow)
  alarmsWindow.healthBelow.onClick = function(widget)
    config.healthBelow = not config.healthBelow
    widget:setOn(config.healthBelow)
  end

  alarmsWindow.healthValue.onValueChange = function(scroll, value)
    config.healthValue = value
    alarmsWindow.healthBelow:setText("Health < " .. config.healthValue .. "%")  
  end
  alarmsWindow.healthValue:setValue(config.healthValue)

  alarmsWindow.manaBelow:setOn(config.manaBelow)
  alarmsWindow.manaBelow.onClick = function(widget)
    config.manaBelow = not config.manaBelow
    widget:setOn(config.manaBelow)
  end

  alarmsWindow.manaValue.onValueChange = function(scroll, value)
    config.manaValue = value
    alarmsWindow.manaBelow:setText("Mana < " .. config.manaValue .. "%")  
  end
  alarmsWindow.manaValue:setValue(config.manaValue)

  alarmsWindow.privateMessage:setOn(config.privateMessage)
  alarmsWindow.privateMessage.onClick = function(widget)
    config.privateMessage = not config.privateMessage
    widget:setOn(config.privateMessage)
  end

  alarmsWindow.ignoreFriends:setOn(config.ignoreFriends)
  alarmsWindow.ignoreFriends.onClick = function(widget)
    config.ignoreFriends = not config.ignoreFriends
    widget:setOn(config.ignoreFriends)
  end

  alarmsWindow.warnBoss:setOn(config.warnBoss)
  alarmsWindow.warnBoss.onClick = function(widget)
    config.warnBoss = not config.warnBoss
    widget:setOn(config.warnBoss)
  end

  alarmsWindow.bossName:setText(config.bossName)
  alarmsWindow.bossName.onTextChange = function(widget, text)
    config.bossName = text
  end

  alarmsWindow.warnMessage:setOn(config.warnMessage)
  alarmsWindow.warnMessage.onClick = function(widget)
    config.warnMessage = not config.warnMessage
    widget:setOn(config.warnMessage)
  end

  alarmsWindow.messageText:setText(config.messageText)
  alarmsWindow.messageText.onTextChange = function(widget, text)
    config.messageText = text
  end

  local pName = player:getName()
  onTextMessage(function(mode, text)
    if config.enabled and config.playerAttack and mode == 16 and string.match(text, "hitpoints due to an attack") and not string.match(text, "hitpoints due to an attack by a ") then
      playSound("/sounds/Player_Attack.ogg")
      g_window.setTitle(pName .. " - Player Attacks!")
      return
    end

    if config.warnMessage and config.messageText:len() > 0 then
      text = text:lower()
      local parts = string.split(config.messageText, ",")
      for i=1,#parts do
        local part = parts[i]
        part = part:trim()
        part = part:lower()

        if text:find(part) then
          delay(1500)
          playSound(g_resources.fileExists("/sounds/Special_Message.ogg") and "/sounds/Special_Message.ogg" or "/sounds/Private_Message.ogg")
          g_window.setTitle(pName .. " - Special Message Detected: "..part)
          return
        end
      end
    end
  end)

  macro(100, function()
    if not config.enabled then
      return
    end
    local specs = getSpectators()
    if config.playerDetected then
      for _, spec in ipairs(specs) do
        if spec:isPlayer() and spec:getName() ~= name() then
          local specPos = spec:getPosition()
          if (not config.ignoreFriends or not isFriend(spec)) and math.max(math.abs(posx()-specPos.x), math.abs(posy()-specPos.y)) <= 8 then
            playSound("/sounds/Player_Detected.ogg")
            delay(1500)
            g_window.setTitle(pName .. " - Player Detected! "..spec:getName())
            if config.playerDetectedLogout then
              modules.game_interface.tryLogout(false)
            end
            return
          end
        end
      end
    end

    if config.creatureDetected then
      for _, spec in ipairs(specs) do
        if not spec:isPlayer() then
          local specPos = spec:getPosition()
          if math.max(math.abs(posx()-specPos.x), math.abs(posy()-specPos.y)) <= 8 then
            playSound("/sounds/Creature_Detected.ogg")
            delay(1500)
            g_window.setTitle(pName .. " - Creature Detected! "..spec:getName())
            return
          end
        end
      end
    end

    if config.warnBoss then
      -- experimental, but since we check only names i think the best way would be to combine all spec's names into one string and then check it to avoid multiple loops
      if config.bossName:len() > 0 then
        local names = string.split(config.bossName, ",")
        local combinedString = ""
        for _, spec in ipairs(specs) do
          local specPos = spec:getPosition()
          if math.max(math.abs(posx() - specPos.x), math.abs(posy() - specPos.y)) <= 8 then
            local name = spec:getName():lower()
            -- add special sign between names to avoid unwanted combining mistakes
            combinedString = combinedString .."&"..name
          end
        end
        for i=1,#names do
          local name = names[i]
          name = name:trim()
          name = name:lower()

          if combinedString:find(name) then
            playSound(g_resources.fileExists("/sounds/Special_Creature.ogg") and "/sounds/Special_Creature.ogg" or "/sounds/Creature_Detected.ogg")
            delay(1500)
            g_window.setTitle(pName .. " - Special Creature Detected: "..name)
            return
          end

        end
      end
    end

    if config.healthBelow then
      if hppercent() <= config.healthValue then
        playSound("/sounds/Low_Health.ogg")
        delay(1500)
        g_window.setTitle(pName .. " - Low Health! only: "..hppercent().."%")
        return
      end
    end

    if config.manaBelow then
      if manapercent() <= config.manaValue then
        playSound("/sounds/Low_Mana.ogg")
        delay(1500)
        g_window.setTitle(pName .. " - Low Mana! only: "..manapercent().."%")
        return
      end
    end
  end)

  onTalk(function(name, level, mode, text, channelId, pos)
    if mode == 4 and config.enabled and config.privateMessage then
      playSound("/sounds/Private_Message.ogg")
      g_window.setTitle(pName .. " - Private Message from: " .. name)
      return
    end
  end)
end

ui.alerts.onClick = function(widget)
  alarmsWindow:show()
  alarmsWindow:raise()
  alarmsWindow:focus()
end

UI.Separator()
UI.Label("Custom by: Valdez")
UI.Separator()