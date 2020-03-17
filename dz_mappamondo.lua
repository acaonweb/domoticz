return {
	on = {
		devices = {
			'Push On 2', 'Push On 4', 'Mappamondo'
		}
	},
	logging = {
	    level = domoticz.LOG_DEBUG,
	    marker = "Mappamondo: "
	},
	execute = function(dz, device)
		local mappamondo = dz.devices("Mappamondo")
		local p2 = dz.devices("Push On 2")
		local p4 = dz.devices("Push On 4")
		if (device.state=='Click' and mappamondo.state=='On') then
		    mappamondo.cancelQueuedCommands()
	        mappamondo.switchOff().silent()
	    elseif (device.state=='Click' and mappamondo.state=='Off' and dz.time.matchesRule("between 07:00 and 21:00")) then
	        mappamondo.cancelQueuedCommands()
	        mappamondo.switchOn().forMin(30).silent()
        elseif (device.state=='Double Click') then
            mappamondo.cancelQueuedCommands()
            mappamondo.switchOn().forMin(30).silent()
            dz.notify('Notifica','Timer Attivato',dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
        end
        if(device.name=="Mappamondo" and device.state=="On") then
            dz.notify('Notifica','Alexa command',dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
            mappamondo.cancelQueuedCommands()
            mappamondo.switchOff().afterMin(30).silent()
        end
        
	
	end
}