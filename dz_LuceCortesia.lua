-- Check the wiki at
-- http://www.domoticz.com/wiki/%27dzVents%27:_next_generation_LUA_scripting
return {

	-- 'active' controls if this entire script is considered or not
	active = true, -- set to false to disable this script

	-- trigger
	-- can be a combination:
	on = {
		devices = {
		     --['Body Sensor Scala']={'at nightime'}
		     'Body Sensor Scala','Body Sensor Sala'
		}
	},
	logging = {
	    level = domoticz.LOG_DEBUG,
	    marker = "Luce Cortesia: "
	},

	-- actual event code
	-- in case of a timer event or security event, device == nil
	execute = function(domoticz, device, tginfo)
	    --domoticz.log('ORA CORRENTE '..tostring(currentTime))
	    if(device.name=='Body Sensor Scala' and device.state=='On') then
	        domoticz.variables('pplAtHome').set(1)
	        domoticz.log('1.triggered  '..tostring(device.name)..' '..tostring(device.state))
	        domoticz.scenes('luceCortesia').switchOn()
            --domoticz.notify('Notifica Scala','Luce cortesia attivata',PRIORITY_NORMAL,0,'iPhone6S',domoticz.NSS_PUSHOVER)
            if(domoticz.devices("Body Sensor Sala").state=='On') then
                if (domoticz.time.matchesRule('at 21:00-05:00')) then
                   domoticz.notify('Notifica Scala','Salendo',domoticz.PRIORITY_NORMAL,0,'iPhone6S',domoticz.NSS_PUSHOVER)
                end
                --if (domoticz.time.matchesRule('at 17:00-21:00') or domoticz.time.matchesRule('at 11:00-11:01 on mon,tue,wed,thu,fri')) then
                if (domoticz.time.matchesRule('at sunset-60 minutes after sunset') or domoticz.time.matchesRule('at 11:00-11:01 on mon,tue,wed,thu,fri')) then    
                    if(domoticz.devices('Plug 1').state=='Off') then
                        domoticz.devices('Plug 1').switchOn().forMin(1)
                        
                    end
                end
            else     
                domoticz.notify('Notifica Scala','Luce Cortesia',domoticz.PRIORITY_NORMAL,0,'iPhone6S',domoticz.NSS_PUSHOVER)
            end
        
        end
        if(device.name=='Body Sensor Scala' and device.state=='On') then
            domoticz.variables('pplAtHome').set(1)
        end
        
	end
}