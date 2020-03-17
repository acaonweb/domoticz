-- Check the wiki at
-- http://www.domoticz.com/wiki/%27dzVents%27:_next_generation_LUA_scripting
return {

	-- 'active' controls if this entire script is considered or not
	active = true, -- set to false to disable this script

	-- trigger
	-- can be a combination:
	on = {
		timer = {
			'every 15 minutes between sunset and 60 minutes after sunset'
		}
	},

	-- actual event code
	-- in case of a timer event or security event, device == nil
	execute = function(domoticz, timer)
	    domoticz.log('trigger')
	    if(domoticz.devices('Finestra Divano').state=='Open' or
	        domoticz.devices('Finestra Cucina').state=='Open' or
	        domoticz.devices('Finestra Sala').state=='Open' or
	        domoticz.devices('Finestra Bagno').state=='Open') then
	        elenco = 'Elenco\n'
	        elenco = elenco..'Finestra Divano\t'..tostring(domoticz.devices('Finestra Divano').state)..'\n'
	        elenco = elenco..'Finestra Cucina\t'..tostring(domoticz.devices('Finestra Cucina').state)..'\n'
	        elenco = elenco..'Finestra Sala\t'..tostring(domoticz.devices('Finestra Sala').state)..'\n'
	        elenco = elenco..'Finestra Bagno\t'..tostring(domoticz.devices('Finestra Bagno').state)..'\n'
	        
	        
	        domoticz.log(elenco)
	        domoticz.notify('Notifica',elenco,PRIORITY_NORMAL,'siren','iPhone6S',domoticz.NSS_PUSHOVER)
	        domoticz.notify('Notifica',elenco,PRIORITY_NORMAL,'siren','debby',domoticz.NSS_PUSHOVER)
        end
        
	        

	end
}