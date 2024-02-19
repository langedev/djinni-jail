local modem = peripheral.find("modem")
local minDjinniHp = 120
local pedestalName = "xreliquary:pedestal_0"
local occultismType = "occultism:dimensional_mineshaft"

function handleMineshaft(ms)
   local djinni = modem.callRemote(ms, "getItemDetail", 1)
   if djinni == nil then
       fromPedestalTo(ms)
   else
       checkDjinni(djinni, ms)
   end
end

function fromPedestalTo(mineshaft)
    local remoteDjinni = modem.callRemote(pedestal(), "getItemDetail", 1)
    if remoteDjinni == nil then
        jailBreak()
    end
    if remoteDjinni.damage == 0 then
        modem.callRemote(mineshaft, "pullItems", pedestal(), 1)
    end
end

function checkDjinni(djinni, inMS)
    local health = djinni.maxDamage - djinni.damage
    if health <= minDjinniHp then
        modem.callRemote(pedestal(), "pullItems", inMS, 1)
    end
end

function pedestal()
    if modem.isPresentRemote(pedestalName) == false then
        jailBreak()
    else
        return pedestalName
    end
end

function jailBreak()
    local connected = modem.getNamesRemote()

    for i, name in ipairs(connected) do
        if hasTypeRemote(name, occultismType) then
            modem.callRemote(name, "pushItems", "minecraft:chest_1", 1)
        end
    end
end

function main()
  while true do
      local connected = modem.getNamesRemote()

      for i, name in ipairs(connected) do
          if modem.hasTypeRemote(name, occultismType) then
              handleMineshaft(name)
          end
      end
      sleep(5)
  end
end

main()
