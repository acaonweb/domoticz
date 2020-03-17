-- *** user settings below this line **

local doorSensorHelperName = '$Doorsensor'  -- if first char of name is '$' device is hidden in switches tab 
local doorSensorName = 'Porta Ingresso'  -- change to the name of your doorSensor' 
local minutesUntilNotification = 10

-- *** No changes required below this line **

return {
	on = {
		devices = {doorSensorName, doorSensorHelperName}
	},
	logging = {
	    level = domoticz.LOG_DEBUG,
	    marker = "PortaIngresso : "
	},
	execute = function(dz, item)
        local doorSensor = dz.devices(doorSensorName) 
        local helper = dz.devices(doorSensorHelperName) 
        local luci = dz.groups('LuciCasa')
        local mappamondo = dz.devices('Mappamondo')
        local libreria = dz.devices('Albero')
        local plug1 = dz.devices('Spina 1')
        local luxval = dz.devices('Luminosita Sala').lux
        local lucelibreria = dz.devices('Luce Libreria')
        dz.log("Esecuzione Test Event")
        --dz.notify('Test',"Porta Aperta da 6 secondi",dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
        if item == doorSensor then
            
            if item.state == "Open" then
                --operazioni da fare quando apro
                helper.cancelQueuedCommands()
                dz.log('1.triggered  '..tostring(item.name)..' '..tostring(item.state))
                dz.scenes('luceIngresso').switchOn()
                dz.devices('Luce Cucina').switchOn().checkFirst()
                dz.devices('Spina 1').switchOn()
                if (dz.time.matchesRule("between 09:00 and 21:00")) then
                    
                    --elenco luci da accendere
                    dz.devices('Luce AntiBagno').switchOn().checkFirst()
                    dz.devices('Luce Sottotetto Cassettiera').switchOn().checkFirst()
                    dz.devices('Luce Sottotetto Scrivania').switchOn().checkFirst()
                    dz.devices('Neon').switchOn().checkFirst()
                    
                    if(luxval <= 200) then
                        --dz.devices('Albero').switchOn().checkFirst()
                        lucelibreria.switchOn().forMin(5)
                    end
                    
                    --allerta mappamondo
                    mappamondo.switchOn().forSec(1).silent().repeatAfterSec(1, 3)
                end
                dz.notify('Notifica Ingresso','Porta Aperta',dz.PRIORITY_HIGH,'siren','iPhone6S',dz.NSS_PUSHOVER)
                if(dz.devices("doff").state=="Off") then
                    dz.notify('Notifica Ingresso','Porta Aperta',dz.PRIORITY_NORMAL,'siren','debby',dz.NSS_PUSHOVER)
                end

            end
            
            --
            if item.state == "Closed" then
                --operazione da fare quando chiudo
                --dz.notify('Test',"La Porta si è chiuso, parte il conteggio",dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
                helper.switchOn().afterMin(minutesUntilNotification) -- come back after x seconds
                dz.log("Porta chiusa, parte il timer interno")
            end    
    else -- triggered by helper
            local bd1 = dz.devices("Body Sensor Sala").lastUpdate.minutesAgo 
            local bd2 = dz.devices("Body Sensor Scala").lastUpdate.minutesAgo
            dz.log("Timer interno eseguito, controllo sensori body")
            dz.log(bd1)
            dz.log(bd2)
            if (doorSensor.state == "Closed" and bd1 >= (minutesUntilNotification-2) and bd2 >= (minutesUntilNotification-2)) then 
                    dz.log("in casa non c'è nessuno")
                    dz.devices('Luce AntiBagno').switchOff().afterSec(2).checkFirst()
                    dz.devices('Luce Cucina').switchOff().afterSec(2).checkFirst()
                    dz.devices('Luce Sottotetto Cassettiera').switchOff().afterSec(2).checkFirst()
                    dz.devices('Luce Sottotetto Scrivania').switchOff().afterSec(2).checkFirst()
                    dz.devices('Neon').switchOff().afterSec(2).checkFirst()
                    --dz.devices('Albero').switchOff().afterSec(2).checkFirst()
                    dz.devices('Libreria').switchOff().afterSec(2).checkFirst()
                    dz.devices('Spina 1').switchOff().afterSec(2).checkFirst()
                    dz.notify('Casa',"Nessuno in casa",dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
                    helper.cancelQueuedCommands()
                    helper.switchOff().silent()
                    dz.variables('pplAtHome').set(0)
                else
                    dz.log("in casa c'è qualcuno")
                    dz.notify('Casa',"Qualcuno in casa",dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
                    helper.cancelQueuedCommands()
                    helper.switchOff().silent()
            end
        end
        
	end
}
