-- Check the wiki at
-- http://www.domoticz.com/wiki/%27dzVents%27:_next_generation_LUA_scripting
DEVICENAME='Finestra Sala'
return {

	-- 'active' controls if this entire script is considered or not
	active = true, -- set to false to disable this script

	-- trigger
	-- can be a combination:
	on = {
		devices = {
		    'Finestra Sala'
		}
	},
	logging = {
	    level = domoticz.LOG_DEBUG,
	    marker = "Finestra Sala: "
	},

	-- actual event code
	-- in case of a timer event or security event, device == nil
	execute = function(domoticz, device)
	 
	    if(device.name=='Finestra Sala' and device.state=='Open') then
	        domoticz.log('1.triggered  '..tostring(device.name)..' '..tostring(device.state))
	        --domoticz.scenes('luceIngresso').switchOn()
            domoticz.notify('Notifica Sala','Finestra Sala Aperta',PRIORITY_NORMAL,0,'iPhone6S',domoticz.NSS_PUSHOVER)
            domoticz.devices('Webcam Sala').switchOn()
        end
	end
}