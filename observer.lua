local m = peripheral.find("modem")
local d = peripheral.wrap("right")
local occultismType = "occultism:dimensional_mineshaft"

function constructMineshaftList()
  remoteNames = m.getNamesRemote()

  mineshafts = {}
  index = 1

  for i, name in ipairs(remoteNames) do
    if m.hasTypeRemote(name, occultismType) then
      mineshafts[index] = name
      index = index + 1
    end
  end

  return mineshafts, index
end

function displayMineshafts(mineshafts, msLength)
  local width, height = d.getSize()

  width = width + 1
  height = height + 1

  local column1 = 1
  local column2 = math.floor(width / 2) + 1
  local colSize = column2 - 1

  local remaining = (height - (3*(msLength / 2))) / 2

  local x = column1
  local y = remaining + 1

  for i, ms in ipairs(mineshafts) do
    displayMineshaft(ms, i, x, y, colSize)
    if i % 2 == 0 then
      x = column1
      y = y + 3
    else
      x = column2
    end
  end
end

function displayMineshaft(mineshaft, cell, x, y, w)
  d.setCursorPos(x, y)

  local barSize = w - 3
  local barFillSize = 0
  local barColor = colors.gray
  local barFillColor = colors.green
  local textColor = colors.white

  local djinni = m.callRemote(mineshaft, "getItemDetail", 1)
  if djinni == nil then
    barColor = colors.red
    barFillColor = colors.red
    textColor = colors.red
  else
    local ratio = ((djinni.maxDamage - djinni.damage) / djinni.maxDamage)
    if ratio > 0.5 then
      barFillColor = colors.green
    elseif ratio > 0.25 then
      barFillColor = colors.orange
    else
      barFillColor = colors.red
    end
    barFillSize = ratio * barSize
  end

  d.setBackgroundColor(colors.black)
  d.setTextColor(textColor)
  d.write("Cell ")
  d.write(cell)

  if djinni == nil then
    d.write(" - Requires reeducation")
  else
    term.redirect(d)
    paintutils.drawFilledBox(x, y+1, x+barSize, y+1, barColor)
    paintutils.drawFilledBox(x, y+1, x+barFillSize, y+1, barFillColor)
    term.redirect(term.current())
  end
end

function main()
  mineshafts, length = constructMineshaftList()
  displayMineshafts(mineshafts, length)
end


d.clear()
term.redirect(d)
paintutils.drawFilledBox(1,1,100,100, colors.black)
term.redirect(term.current())
while true do
  main()
  sleep(5)
end
