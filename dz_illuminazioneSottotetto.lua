-- Check the wiki at
-- http://www.domoticz.com/wiki/%27dzVents%27:_next_generation_LUA_scripting
return {

	-- 'active' controls if this entire script is considered or not
	active = true, -- set to false to disable this script

	-- trigger
	-- can be a combination:
	on = {
		devices = {
		    'Push On 1'
		}
	},
	data = {
            lightset = {initial=0}, colorset = {initial=0}, dimset = {initial=0}
        },

	-- actual event code
	-- in case of a timer event or security event, device == nil
	execute = function(domoticz, device)
	    domoticz.log(device.name)
	    domoticz.log(device.state)
	    
	    local scrivania=domoticz.devices('Luce Sottotetto Scrivania')
	    local cassettiera=domoticz.devices('Luce Sottotetto Cassettiera')
	    local neon=domoticz.devices('Neon')
	    
	    local rosso=domoticz.scenes('SottotettoRed')
	    local verde=domoticz.scenes('SottotettoGreen')
	    local viola=domoticz.scenes('SottotettoPurple')
	    local giallo=domoticz.scenes('SottotettoYellow')
	    local bianco=domoticz.scenes('SottotettoWhite')
	    
	    local dim10=domoticz.scenes('SottotettoDim10')
	    
	    if(device.state=="Click" and domoticz.data.lightset==0) then
	        domoticz.data.lightset = 1
            scrivania.switchOn()
            cassettiera.switchOff()
            neon.switchOff()
        elseif (device.state=="Click" and domoticz.data.lightset==1) then
            domoticz.data.lightset = 2
            scrivania.switchOff()
            cassettiera.switchOn()
            neon.switchOff()
        elseif (device.state=="Click" and domoticz.data.lightset==2) then
            domoticz.data.lightset = 0
            scrivania.switchOn()
            cassettiera.switchOn()
            neon.switchOn()
        end
        if (domoticz.data.lightset > 2) then
            domoticz.data.lightset = 0
        end
        
        
       if(device.state=="Double Click" and domoticz.data.colorset==0) then
	        domoticz.data.colorset = 1
	        rosso.switchOn()
	        neon.switchOff()
        elseif (device.state=="Double Click" and domoticz.data.colorset==1) then
            domoticz.data.colorset = 2
            verde.switchOn()
            neon.switchOff()
        elseif (device.state=="Double Click" and domoticz.data.colorset==2) then
            domoticz.data.colorset = 3
            viola.switchOn()
            neon.switchOff()
        elseif (device.state=="Double Click" and domoticz.data.colorset==3) then
            domoticz.data.colorset = 4
            giallo.switchOn()
            neon.switchOff()
        elseif (device.state=="Double Click" and domoticz.data.colorset==4) then
            domoticz.data.colorset = 0
            bianco.switchOn()
            neon.switchOn()
        end

--[[
       if(device.state=="Long Click" and domoticz.data.dimset==0) then
	        domoticz.data.dimset = 1
	        scrivania.dimTo(2)
	        cassettiera.dimTo(2)
	        neon.switchOff()
        elseif (device.state=="Long Click" and domoticz.data.dimset==1) then
            domoticz.data.dimset = 2
            scrivania.dimTo(50)
            cassettiera.dimTo(50)
            neon.switchOff()
        elseif (device.state=="Long Click" and domoticz.data.dimset==2) then
            domoticz.data.dimset = 0
            scrivania.dimTo(100)
            cassettiera.dimTo(100)       
            neon.switchOn()
        end
   


        
]]--
        if(device.state=="Long Click") then
            neon.switchOff()
            scrivania.dimTo(math.max((scrivania.level-10),0))
            cassettiera.dimTo(math.max((cassettiera.level-10),0))
            if(scrivania.level<=0) then
                scrivania.dimTo(100)
                neon.switchOn()
            end
            if(cassettiera.level<=0) then
                cassettiera.dimTo(100)
                neon.switchOn()
            end
        end
        
        
        if (domoticz.data.lightset > 2) then
            domoticz.data.lightset = 0
        end
        if (domoticz.data.colorset > 4) then
            domoticz.data.colorset = 0
        end
        --[[
        if (domoticz.data.dimset > 2) then
            domoticz.data.dimset = 0
        end
        ]]--


        domoticz.log('LS'..tostring(domoticz.data.lightset))
        domoticz.log('CS'..tostring(domoticz.data.colorset))
end
}