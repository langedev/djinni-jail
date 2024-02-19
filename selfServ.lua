local m = peripheral.find("modem")
local submitPedName = "tconstruct:table_2"
local djinniPedName = "xreliquary:pedestal_2"
local userPedName = "xreliquary:pedestal_3"
local userMonName = "monitor_4"
local djinniMonName = "monitor_3"

if not isPresentRemote(submitPedName) or
   not isPresentRemote(xpPedName) or
   not isPresentRemote(userPedName) or
   not isPresentRemote(userMonName) or
   not isPresentRemote(xpMonName) then
  print("Uh-oh!")
  while true do sleep(100) end
 end

function process()
  local data = {}
  local submit = m.callRemote(submitPedName, "getItemDetail", 1)
  local processing = m.callRemote(userPedName, "getItemDetail", 1)
  local djinni = m.callRemote(djinniPedName, "getItemDetail", 1)

  local data.selfServe = {}

  if processing then
    data.selfServe.max = processing.maxDamage
    data.selfServe.current = processing.maxDamage - processing.damage
    if processing.damage == 0 then
      if m.callRemote(submitPedName, "pullItems", userPedName, 1) then
        data.selfServe.blocked = true
      else
        data.selfServe.done = true
      end
    end
  elseif submit then
    if submit.damage ~= 0 then
      for i, enchant in ipairs(submit.enchantments) do
        if enchant.name == "minecraft:mending" then
          data.selfServe.max = submit.maxDamage
          data.selfServe.current = submit.maxDamage - submit.damage
          m.callRemote(userPedName, "pullItems", submitPedName, 1)
        else
          data.selfServe.noMending = true
        end
      end
    else
      data.selfServe.noDamage = true
    end
  end

  if djinni then
    data.djinni = {}
    data.djinni.max = djinni.maxDamage
    data.djinni.current = djinni.maxDamage - djinni.damage
  end

  return data
end

function draw(data)
  if data.djinni then
    m.transmit(1, 0, data.djinni)
  end
  if data.selfServe then
    m.transmit(2, 0, data.selfServe)
  end
end

function main()
  data = process()
  draw(data)
end

while true do
  main()
  sleep(0.5)
end
