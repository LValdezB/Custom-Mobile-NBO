-- tools tab
setDefaultTab("Tools")

UI.Separator()
UI.Label("Facility")
UI.Separator()
UI.Button("Stop Cave/Target Bot", function()
  if CaveBot.isOn() or TargetBot.isOn() then
      CaveBot.setOff()
      TargetBot.setOff()
  elseif CaveBot.isOff() or TargetBot.isOff() then
      CaveBot.setOn()
      TargetBot.setOn()
   end
  end)
  UI.Separator()
  ---Bug map mobile
local bugMapMobile = {};

local cursorWidget = g_ui.getRootWidget():recursiveGetChildById('pointer');

local initialPos = { x = cursorWidget:getPosition().x / cursorWidget:getWidth(), y = cursorWidget:getPosition().y / cursorWidget:getHeight() };

local availableKeys = {
    ['Up'] = { 0, -5 },
    ['Down'] = { 0, 5 },
    ['Left'] = { -5, 0 },
    ['Right'] = { 5, 0 }
};

function bugMapMobile.logic()
    local pos = pos();
    local keypadPos = { x = cursorWidget:getPosition().x / cursorWidget:getWidth(), y = cursorWidget:getPosition().y / cursorWidget:getHeight() };
    local diffPos = { x = initialPos.x - keypadPos.x, y = initialPos.y - keypadPos.y };

    if (diffPos.y < 0.46 and diffPos.y > -0.46) then
        if (diffPos.x > 0) then
            pos.x = pos.x + availableKeys['Left'][1];
        elseif (diffPos.x < 0) then
            pos.x = pos.x + availableKeys['Right'][1];
        else return end
    elseif (diffPos.x < 0.46 and diffPos.x > -0.46) then
        if (diffPos.y > 0) then
            pos.y = pos.y + availableKeys['Up'][2];
        elseif (diffPos.y < 0) then
            pos.y = pos.y + availableKeys['Down'][2];
        else return; end
    end
    local tile = g_map.getTile(pos);
    if (not tile) then return; end

    g_game.use(tile:getTopUseThing());
end

bugMapMobile.macro = macro(1, "Bug Map", bugMapMobile.logic);
UI.Separator()
---Bless----
local windowUI = setupUI([[
MainWindow
  id: main
  !text: tr('Bless')
  size: 200 210
  scrollable: true
    
  ScrollablePanel
    id: TpList
    anchors.top: parent.top
    anchors.left: parent.left
    size: 190 225
    vertical-scrollbar: mainScroll

    Button
      !text: tr('first bless')
      anchors.top: parent.top
      anchors.left: parent.left
      width: 165

    Button
      !text: tr('second bless')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165

    Button
      !text: tr('third bless')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165

    Button
      !text: tr('fourth bless')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165

    Button
      !text: tr('fifth bless')
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5
      width: 165

  VerticalScrollBar  
    id: mainScroll
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    step: 48
    pixels-scroll: true
    
  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-top: 15
    margin-right: 15

]], g_ui.getRootWidget());
windowUI:hide();

Bless = {};
Bless.macro = macro(100, "Bless", function() end);
local TpList = windowUI.TpList;

Bless.close = function()
  windowUI:hide()
  NPC.say('bye');
end

Bless.show = function()
    print("Ta aqui?")
    windowUI:show();
    windowUI:raise();
    windowUI:focus();
end

windowUI.closeButton.onClick = function()
    Bless.close();
end

Bless.ToBless = function(Bless)
        NPC.say(Bless);
        schedule(100, function()
          NPC.say('yes');
        end);
      end

for i, child in pairs(TpList:getChildren()) do
    child.onClick = function()
        Bless.ToBless(child:getText())
    end
end

onTalk(function(name, level, mode, text, channelId, pos)
  if (Bless.macro.isOff()) then return; end
  if (name ~= 'benefactor') then return; end              
  if (mode ~= 51) then return; end
  if (text:find('I can grant you blessings to suffer less in this dangerous ninja world! I offer progressive blesses')) then
      Bless.show();
  else
      Bless.close();
  end
end);

onKeyDown(function(keys)
    if (keys == 'Escape' and windowUI:isVisible())  then
        Bless.close();
    end
end);
---------
local showhp = macro(20000, "All Creature HP %", function() end)
onCreatureHealthPercentChange(function(creature, healthPercent)
    if showhp:isOff() then  return end
    if creature:isMonster() or creature:isPlayer() and creature:getPosition() and pos() then
        if getDistanceBetween(pos(), creature:getPosition()) <= 5 then
            creature:setText(healthPercent .. "%")
        else
            creature:clearText()
        end
    end
end)
UI.Separator()
UI.Label("Utility")
UI.Separator()
---auto haste--
macro(500, "Auto Haste", nil, function()
  if not hasHaste() and storage.autoHasteText:len() > 0 then
    if saySpell(storage.autoHasteText) then
      delay(5000)
    end
  end
end)
addTextEdit("autoHasteText", storage.autoHasteText or "chakra feet", function(widget, text) 
  storage.autoHasteText = text
end)
---Buff--
macro(5000, "Auto Buff", function()
  if not hasPartyBuff() and storage.autoBuffText:len() > 0 then
    if saySpell(storage.autoBuffText) then
      delay(1000)
    end
  end
end)

addTextEdit("autoBuffText", storage.autoBuffText or "Buff", function(widget, text)
  storage.autoBuffText = text
end)

---escada--
UI.Separator()
local panelName = "escadaadv"
  local ui = setupUI([[
Panel
  height: 25

  BotSwitch
    id: titleescada
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    height: 20
    font: verdana-11px-rounded
    !text: tr('Escada')

  Button
    id: editList
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    font: verdana-11px-rounded
    height: 20
    text: Edit
      
  ]], parent)
  ui:setId(panelName)
local EscadaWindow = setupUI([[
MainWindow
  !text: tr('Key Ladder Edit')
  size: 180 280
  font: verdana-11px-rounded
  color: #0FFF50
  @onEscape: self:hide()

  Label
    id: Fistkey
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Key Use
    font: verdana-11px-rounded

  BotTextEdit
    id: IdUseKey
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: Fistkey.bottom
    margin-top: 3
  
  Label
    id: secondkey
    anchors.top: IdUseKey.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-top: 5
    font: verdana-11px-rounded
    text: Key Walk

  BotTextEdit
    id: IdWalkKey
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: secondkey.bottom
    margin-top: 3

  Label
    id:textoinfo
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: IdWalkKey.bottom
    margin-top: 10
    text-align: center
    color: #9c9a9a
    font: verdana-11px-rounded
    text: Info

  Label
    id:texto
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: textoinfo.bottom
    margin-top: 10
    color: #aeaeae
    font: verdana-11px-rounded
    text: Put F1 to be in volume +

  Label
    id:textoasd
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: texto.bottom
    margin-top: 10
    font: verdana-11px-rounded
    color: #aeaeae
    text: Put F2 to be in volume -

  Label
    id:textoex
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: textoasd.bottom
    margin-top: 10
    font: verdana-11px-rounded
    color: #aeaeae
    text-wrap: true
    text-auto-resize: true
    !text: tr ("The same key can be placed in both spaces")


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
    IdUseKey= 'F1',
    IdWalkKey='F1'

  }
end

local config = storage[panelName]
rootWidget = g_ui.getRootWidget()
if rootWidget then
EscadaWindow:hide()

ui.titleescada:setOn(storage.titleescadaEnabled);
ui.titleescada.onClick = function(widget)
    storage.titleescadaEnabled = not storage.titleescadaEnabled;
    widget:setOn(storage.titleescadaEnabled);
end

ui.editList.onClick = function(widget)
  EscadaWindow:show()
  EscadaWindow:raise()
  EscadaWindow:focus()
end
EscadaWindow.closeButton.onClick = function(widget)
  EscadaWindow:hide()
end
EscadaWindow.IdUseKey.onTextChange = function(widget, text)
  storage[panelName].IdUseKey = text
end
EscadaWindow.IdWalkKey.onTextChange = function(widget, text)
  storage[panelName].IdWalkKey = text
end

EscadaWindow.IdUseKey:setText(config.IdUseKey)
EscadaWindow.IdWalkKey:setText(config.IdWalkKey) 

end 


isKeyPressed = modules.corelib.g_keyboard.isKeyPressed

local useId =  {
435,
1948,
1968,
5542,


}


for index, id in ipairs(useId) do
useId[id] = true
useId[index] = nil
end

macro(100, function()
if (not storage.titleescadaEnabled) then
  return
end
if isKeyPressed(config.IdUseKey) then
  local pos = pos()
  for _, tile in pairs(g_map.getTiles(pos.z)) do
    local tilePos = tile:getPosition()
    if tilePos then
      if getDistanceBetween(pos, tilePos) <= 7 then
        for _, item in pairs(tile:getItems()) do
          local itemId = item:getId()
          if itemId == 432 then
            return useWith(3003, item)
          elseif useId[itemId] then
            return use(item)
          end
        end
      end
    end
  end
end
end)

local walkId = {
7736,
7735,
7734,
7733,
7732,
7731,
7730,
7729,
6924,
6923,
6922,
6921,
6920,
6919,
6918,
6917,
6173,
6172,
6130,
6129,
6128,
6127,
5081,
1156,
8932,
476,
601,
600,
605,
604,
8690,
8658,
7768,
433,
432,
428,
414,
4825,
4826,
369,
379,
411,
7767,
413,
475,
859,
4823,
567,
566,
485,
484,
483,
428,
432,
433,
434,
437,
438,
482,
414,
413,
412,
411,
370,
369,
5731,
610,
609,
607,
595,
1948,
1968,
5542,
1947,
1958,
855,
8657,
1978,
1977,
5259,
5258,
5257,
856,
1950,
1952,
1954,
1956,
1960,
1962,
1966,
7544,
7542,
6915,
6913,
6911,
6909,
1964,
7546,
7546,
7548,
1975,
1971,
1973,
1969,
}

for index, id in ipairs(walkId) do
walkId[id] = true
walkId[index] = nil
end

isOnKamui = function(pos)
if pos.z == 13 then
  if pos.x >= 1100 and pos.x <= 1300 then
    if pos.y >= 850 and pos.y <= 1000 then
      return true
    end
  end
end
end

macro(1, function()
if (not storage.titleescadaEnabled) then
  return
end
if player:isAutoWalking() then
  return
end
local pos = pos()
if isOnKamui(pos) then
  return
end
    
if isKeyPressed(config.IdWalkKey) then
  for _, tile in pairs(g_map.getTiles(pos.z)) do
    local tilePos = tile:getPosition()
    if tilePos then
      local distance = getDistanceBetween(tilePos, pos)
      if distance <= 5 then
        for _, item in pairs(tile:getItems()) do
          if walkId[item:getId()] then
            return player:autoWalk(tilePos)
          end
        end
    end
  end
end
end
end)

UI.Separator()
UI.Label("Offensive")
UI.Separator()
--------combo
local panelName = "Comboadv"
  local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: titlecomboI
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Combo I')

  Button
    id: editList
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Edit
      
  ]], parent)
  ui:setId(panelName)
local ComboListWindow = setupUI([[
MainWindow
  !text: tr('Combo I Options')
  size: 200 230
  @onEscape: self:hide()

  Label
    id: FistSpell
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Fist Spell

  BotTextEdit
    id: Combokeyone
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: FistSpell.bottom
    margin-bot: 5

  Label
    id: SecondSpell
    anchors.top: Combokeyone.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Second Spell

  BotTextEdit
    id: Combokeytwo
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: SecondSpell.bottom

  Label
    id: TirdSpell
    anchors.top: Combokeytwo.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Tird Spell

  BotTextEdit
    id: Combokeythree
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: TirdSpell.bottom
    margin-top: 5

  Label
    id: FourthSpell
    anchors.top: Combokeythree.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Fourth Spell

  BotTextEdit
    id: Combokeyfour
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: FourthSpell.bottom
    margin-top: 3

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
  }
end

local config = storage[panelName]
rootWidget = g_ui.getRootWidget()
if rootWidget then
ComboListWindow:hide()

ui.titlecomboI:setOn(storage.titlecomboIEnabled);
ui.titlecomboI.onClick = function(widget)
    storage.titlecomboIEnabled = not storage.titlecomboIEnabled;
    widget:setOn(storage.titlecomboIEnabled);
end

ui.editList.onClick = function(widget)
  ComboListWindow:show()
  ComboListWindow:raise()
  ComboListWindow:focus()
end
ComboListWindow.closeButton.onClick = function(widget)
  ComboListWindow:hide()
end
ComboListWindow.Combokeyone.onTextChange = function(widget, text)
  storage[panelName].Combokeyone = text
end
ComboListWindow.Combokeytwo.onTextChange = function(widget, text)
  storage[panelName].Combokeytwo = text
end
ComboListWindow.Combokeythree.onTextChange = function(widget, text)
  storage[panelName].Combokeythree = text
end
ComboListWindow.Combokeyfour.onTextChange = function(widget, text)
  storage[panelName].Combokeyfour = text
end
ComboListWindow.Combokeyone:setText(config.Combokeyone) 
ComboListWindow.Combokeytwo:setText(config.Combokeytwo)
ComboListWindow.Combokeythree:setText(config.Combokeythree)
ComboListWindow.Combokeyfour:setText(config.Combokeyfour)
end

local keyboard = modules.corelib.g_keyboard;
macro(200, function()
if (not storage.titlecomboIEnabled) then
  return
end
if (
  g_game.isAttacking()
) then
say(storage[panelName].Combokeyone)
say(storage[panelName].Combokeytwo)
say(storage[panelName].Combokeythree)
say(storage[panelName].Combokeyfour)
end
end)

-------combo 2---
local panelName = "Ctwotwoadv"
  local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: titletwo
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Combo II')

  Button
    id: editList
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Edit
      
  ]], parent)
  ui:setId(panelName)
local CtwotwoListWindow = setupUI([[
MainWindow
  !text: tr('Combo II Options')
  size: 200 230
  @onEscape: self:hide()

  Label
    id: FistSpell
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Fist Spell

  BotTextEdit
    id: Ctwotwokeyone
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: FistSpell.bottom
    margin-bot: 5

  Label
    id: SecondSpell
    anchors.top: Ctwotwokeyone.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Second Spell

  BotTextEdit
    id: Ctwotwokeytwo
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: SecondSpell.bottom

  Label
    id: TirdSpell
    anchors.top: Ctwotwokeytwo.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Tird Spell

  BotTextEdit
    id: Ctwotwokeythree
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: TirdSpell.bottom
    margin-top: 5

  Label
    id: FourthSpell
    anchors.top: Ctwotwokeythree.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Fourth Spell

  BotTextEdit
    id: Ctwotwokeyfour
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: FourthSpell.bottom
    margin-top: 3

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
  }
end

local config = storage[panelName]
rootWidget = g_ui.getRootWidget()
if rootWidget then
CtwotwoListWindow:hide()

ui.titletwo:setOn(storage.titletwoEnabled);
ui.titletwo.onClick = function(widget)
    storage.titletwoEnabled = not storage.titletwoEnabled;
    widget:setOn(storage.titletwoEnabled);
end

ui.editList.onClick = function(widget)
  CtwotwoListWindow:show()
  CtwotwoListWindow:raise()
  CtwotwoListWindow:focus()
end
CtwotwoListWindow.closeButton.onClick = function(widget)
  CtwotwoListWindow:hide()
end
CtwotwoListWindow.Ctwotwokeyone.onTextChange = function(widget, text)
  storage[panelName].Ctwotwokeyone = text
end
CtwotwoListWindow.Ctwotwokeytwo.onTextChange = function(widget, text)
  storage[panelName].Ctwotwokeytwo = text
end
CtwotwoListWindow.Ctwotwokeythree.onTextChange = function(widget, text)
  storage[panelName].Ctwotwokeythree = text
end
CtwotwoListWindow.Ctwotwokeyfour.onTextChange = function(widget, text)
  storage[panelName].Ctwotwokeyfour = text
end
CtwotwoListWindow.Ctwotwokeyone:setText(config.Ctwotwokeyone) 
CtwotwoListWindow.Ctwotwokeytwo:setText(config.Ctwotwokeytwo)
CtwotwoListWindow.Ctwotwokeythree:setText(config.Ctwotwokeythree)
CtwotwoListWindow.Ctwotwokeyfour:setText(config.Ctwotwokeyfour)
end

macro(200, function()
if (not storage.titletwoEnabled) then
  return
end
if (g_game.isAttacking()) then
say(storage[panelName].Ctwotwokeyone)
say(storage[panelName].Ctwotwokeytwo)
say(storage[panelName].Ctwotwokeythree)
say(storage[panelName].Ctwotwokeyfour)
end
end)


-----Attack Target----------
macro(100, "Attack Target", nil, function()
  if g_game.isAttacking() 
then
 oldTarget = g_game.getAttackingCreature()
  end
  if (oldTarget and oldTarget:getPosition()) 
then
 if (not g_game.isAttacking() and getDistanceBetween(pos(), oldTarget:getPosition()) <= 8) then
    
if (oldTarget:getPosition().z == posz()) then
        g_game.attack(oldTarget)
      end
    end
  end
end)

onKeyDown(function(keys)
 
if keys == "Escape" then
    oldTarget = nil
g_game.cancelAttack()
  end
end)

UI.Separator()
UI.Label("Hunt")
UI.Separator()
local panelName = "AntiRedadv"
  local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: titleAntiRed
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Anti-Red')

  Button
    id: editList
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Edit
  ]], parent)
  ui:setId(panelName)
local AntiListWindow = setupUI([[
MainWindow
  !text: tr('Anti-Red Options')
  color: #03C04A
  size: 350 200

  @onEscape: self:hide()

  Label
    id: ComboSpell
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Combo

  BotTextEdit
    id: AntiComboText
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: ComboSpell.bottom
    margin-bot: 5

  Label
    id: AreaSpell
    anchors.top: AntiComboText.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Area

  BotTextEdit
    id: AntiAreaText
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: AreaSpell.bottom
    margin-bot: 5

  Label
    id:textoinfo
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: AntiAreaText.bottom
    margin-top: 10
    text-align: center
    color: #aeaeae
    text: Info

  Label
    id:texto
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: textoinfo.bottom
    margin-top: 10
    color: #aeaeae
    text: Combo must be in sequence and separated by " , "


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
  }
end

local config = storage[panelName]
rootWidget = g_ui.getRootWidget()
if rootWidget then
AntiListWindow:hide()

ui.titleAntiRed:setOn(storage.titleAntiRedEnabled);
ui.titleAntiRed.onClick = function(widget)
    storage.titleAntiRedEnabled = not storage.titleAntiRedEnabled;
    widget:setOn(storage.titleAntiRedEnabled);
end

ui.editList.onClick = function(widget)
  AntiListWindow:show()
  AntiListWindow:raise()
  AntiListWindow:focus()
end
AntiListWindow.closeButton.onClick = function(widget)
  AntiListWindow:hide()
end
AntiListWindow.AntiComboText.onTextChange = function(widget, text)
  storage[panelName].AntiComboText = text
end
AntiListWindow.AntiAreaText.onTextChange = function(widget, text)
  storage[panelName].AntiAreaText = text
end

AntiListWindow.AntiComboText:setText(config.AntiComboText) 
AntiListWindow.AntiAreaText:setText(config.AntiAreaText)
end
AntiRed = {
areaSpell = config.AntiAreaText,
comboSpells = config.AntiComboText, -- Combo separado por VIRGULA
delayTime = 60 * 1000,
time = 0,
};

AntiRed.macro = macro(100, function()
if (not storage.titleAntiRedEnabled) then
  return
end
local spectators = getSpectators(true);
local monstersNextTo = getMonstersInRange(pos(), 2);
for _, creature in pairs(spectators) do
    if (creature:getName() ~= player:getName() and creature:isPlayer() and creature:getEmblem() ~= 1) then
        AntiRed.time = now + AntiRed.delayTime;
        break;
    end
end
if (monstersNextTo > 0 and AntiRed.time < now and player:getSkull() < 3) then
    say(AntiRed.areaSpell);
elseif (g_game.isAttacking() and (AntiRed.time >= now or player:getSkull() >= 3)) then
    local arraySpells = AntiRed.comboSpells:explode(",");
    for _, spell in ipairs(arraySpells) do
      say(spell);
    end
end
end);



---Lure---

local MIN_RANGE = 12;
macro(100, 'Lure', function()
    if (CaveBot.isOff()) then return; end
    local creaturesAround = getMonstersInRange(pos(), MIN_RANGE);
    if (TargetBot.isOff() and creaturesAround >= storage.LureMin) then
        TargetBot.setOn();
    elseif (TargetBot.isOn() and creaturesAround <= storage.LureOff) then
        TargetBot.setOff();
    end
end);

addTextEdit("LureMinText", storage.LureMin or "Min To Stop", function(widget, text)
    storage.LureMin = tonumber(text)
end)
addTextEdit("LureOffText", storage.LureOff or "Run Again", function(widget, text)
    storage.LureOff = tonumber(text)
end)