-- *** user settings below this line **

local windowSensorHelperName = '$FinestraCameretta'  -- if first char of name is '$' device is hidden in switches tab 
local windowSensorName = 'Finestra Cameretta'  -- change to the name of your doorSensor'
local temperatureSensorName = 'Temperatura Cameretta'
local minutesUntilNotification = 10
local tempCamerettaAlert = 15
local deltaTempCamerettaAlert = 5

-- *** No changes required below this line **

return {
	on = {
		devices = {windowSensorHelperName, windowSensorName,temperatureSensorName }
	},
	data = {'t_init'},
	logging = {
	    level = domoticz.LOG_DEBUG,
	    marker = "Aria Cameretta: "
	},
	execute = function(dz, item)
        local windowSensor = dz.devices(windowSensorName) 
        local helper = dz.devices(windowSensorHelperName) 
        local temperaturaCameretta = math.floor(dz.devices(temperatureSensorName).temperature)
        local gatewayRGB=dz.devices('Xiaomi RGB Gateway')
        dz.log("Esecuzione Aerazione CAmeretta")
        --dz.notify('Areazione Cameretta',"Porta Aperta da 6 secondi",dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
        if item.name == windowSensorName then
            dz.log('into item name '..item.state)
            if item.state == "Open" then
                dz.data.t_init = temperaturaCameretta
                helper.switchOn().afterMin(minutesUntilNotification)
                --dz.notify('Areazione Cameretta',"La Finestra Cameretta si è chiuso, parte il conteggio",dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
                dz.log(temperaturaCameretta)
            end
            if item.state == "Closed" then
                --dz.notify('Areazione Cameretta',"Finestra chiusa, azzero timer",dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
                helper.cancelQueuedCommands()
                gatewayRGB.cancelQueuedCommands()
                helper.switchOff().silent()
                gatewayRGB.switchOff().silent()
                dz.scenes("FinestraAperta").cancelQueuedCommands()
                dz.log("All closed")
                dz.data.t_init = temperaturaCameretta
            end
            
        elseif (item.name ==  windowSensorHelperName and windowSensor.state == "Open") then
            dz.notify('Aerazione Cameretta',"Sono Passati "..tostring(minutesUntilNotification).." Minuti",dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
            if(dz.time.matchesRule("on -1/5, 1/11-")) then
                dz.scenes("FinestraAperta").switchOn().repeatAfterSec(2, 1000)
            end
            dz.log("Timer")
            
        elseif item.name == temperatureSensorName then
            
            if ((temperaturaCameretta <= tempCamerettaAlert or (dz.data.t_init - temperaturaCameretta ) > deltaTempCamerettaAlert) and windowSensorName.state == "Open") then
                dz.notify('Areazione Cameretta',"Variazione Temperatura",dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
                dz.notify('Areazione Cameretta',"Tcam: "..tostring(temperaturaCameretta),dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
                dz.notify('Areazione Cameretta',"Trif: "..tostring(dz.data.t_init),dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
                if(dz.time.matchesRule("on -1/5, 1/11-")) then
                    dz.scenes("BassaTemperatura").switchOn().repeatAfterSec(2, 1000)
                end
                dz.log("Temp Alert")
                dz.data.t_init = temperaturaCameretta
                dz.log(dz.data.t_init - temperaturaCameretta)
                dz.notify('Areazione Cameretta',dz.data.t_init - temperaturaCameretta,dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
                dz.notify('Areazione Cameretta',deltaTempCamerettaAlert,dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
            end
            
        end
        
	end
}

