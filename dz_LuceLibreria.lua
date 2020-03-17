return {
	on = {
		devices = {
			'Luce Libreria'
		}
	},
	logging = {
	level = domoticz.LOG_DEBUG,
	marker = "Libreria: "
	},
	execute = function(dz, device)
	    --local dimLevel = 100
        local delay = 0
        local dimDevice=dz.devices("Libreria")
        local dimLevel=dimDevice.level
        if(device.state=="Click" and dimDevice.state == "Off") then
            dimDevice.switchOn()
        else
            dimDevice.switchOff()
            
        end
        
	end
}