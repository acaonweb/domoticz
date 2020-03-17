-- Check the wiki at
-- http://www.domoticz.com/wiki/%27dzVents%27:_next_generation_LUA_scripting
return {

	-- 'active' controls if this entire script is considered or not
	active = true, -- set to false to disable this script

	-- trigger
	-- can be a combination:
	on = {
		devices = {
		    'PingLuceCameretta',
		    'PingLuceCucina',
		    'PingLuceAntiBagno',
		    'PingLuceSottotettoCassettiera',
		    'PingLuceBagno',
		    'PingLuceSottotettoScrivania',
		    'PingXiaomiGateway',
		    'PingWebcamSala'
		    
		}
	},

	-- actual event code
	-- in case of a timer event or security event, device == nil
	execute = function(domoticz, device)
	    
	    message='Dispositivo '..tostring(device.name)..' è '..tostring(device.state)..'line'
	    domoticz.log(message)
	    --domoticz.notify('Notifica',message, -1,0,'iPhone6S',domoticz.NSS_PUSHOVER)
	end
}