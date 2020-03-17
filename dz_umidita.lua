return {
		on = {
		devices = {'Push On 3'},
		timer = {'every 30 minutes'},
		scenes = {}
		--timer = {'at 21:00'}
	},
	logging = {
	    level = domoticz.LOG_DEBUG,
	    marker = "Umidita: "
	},
	execute = function(dz, device, item)
		local hum1 = dz.devices("Leaf Moisture 01").state
		local hum2 = dz.devices("Leaf Moisture 02").state
		local checkSensor01 = dz.devices("Leaf Moisture 01").lastUpdate.daysAgo
		local checkSensor02 = dz.devices("Leaf Moisture 02").lastUpdate.daysAgo
		local checkExternalTemperature = dz.devices("Temperatura Esterna").lastUpdate.daysAgo
		local baro= string.lower(dz.devices("THB").forecastString)
		local tExt=math.floor(dz.devices("Temperatura Esterna").temperature)
		local CMD_PATH = "/home/pi/domoticz/scripts/alexa_remote_control.sh -e speak:"

		

		dz.log("d1 "..checkSensor01)
		dz.log("d2 "..checkSensor02)
		dz.log(device.trigger)
		
		--dz.devices('Leaf Moisture 01').updateCustomSensor("35")
		--dz.devices('Leaf Moisture 02').updateCustomSensor("25")
		
		
	    --dz.devices('Leaf Moisture 01').updateCustomSensor("40").silent()
		
		if(dz.time.matchesRule("between 01:00 and 23:59")) then
		    if(tExt >= dz.variables('maxTemp').value) then
		        dz.variables('maxTemp').set(tExt)
		    end
	    else 
	        dz.variables('maxTemp').set(10)
	    end
	   
	    --settaggio quando il sensore non funziona
	    if(checkExternalTemperature > 0) then
	        dz.log("Sensore Sconnesso")
	        
	        if(dz.time.matchesRule("in week 1-13")) then
	            dz.variables('maxTemp').set(15)
            elseif (dz.time.matchesRule("in week 14-26")) then
                dz.variables('maxTemp').set(25)
            elseif (dz.time.matchesRule("in week 27-39")) then
                dz.variables('maxTemp').set(35)
            elseif (dz.time.matchesRule("in week 40-52")) then
                dz.variables('maxTemp').set(15)
            end
            
        end
    
	    
	    if(checkSensor01 > 0) then
	        if(dz.variables('hum01').value == 1) then
	            dz.variables('hum01').set(0)
	            dz.log(checkSensor01)
	            dz.notify('Hum01','Batteria Scarica',dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
	            dz.notify('Hum01','Batteria Scarica',dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHBULLET)
	            alert="'Il sensore di umidità del piano 1 ha la batteria scarica'"
            end
        else
            dz.variables('hum01').set(1)
        end
        
	    if(checkSensor02 > 0) then
	        if(dz.variables('hum02').value == 1) then
	            dz.variables('hum02').set(0)
	            dz.log(checkSensor02)
	            dz.notify('Hum02','Batteria Scarica',dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
	            dz.notify('Hum02','Batteria Scarica',dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHBULLET)
	            alert="'Il sensore di umidità del piano 2 ha la batteria scarica'"
            end
        else
            dz.variables('hum02').set(1)
        end
    
        --[[
        if (tonumber(hum1) < 0) then
            hum1 = 30
            --dz.devices("Leaf Moisture 01").updateCustomSensor("30")
        end
        if (tonumber(hum2) < 0) then
            hum2 = 30
            --dz.devices("Leaf Moisture 02").updateCustomSensor("30")
        end
        ]]--dz

		testo = ""
		tRif=dz.variables('maxTemp').value
		
	    --newtempoIrrigazione01=math.floor((90-hum1)/(90-5)*60)
	    --newtempoIrrigazione02=math.floor((90-hum2)/(90-5)*60)
	    
        newtempoIrrigazione01=dz.helpers.irrigationTime(hum1,tRif,baro)
        newtempoIrrigazione02=dz.helpers.irrigationTime(hum2,tRif,baro)
        
	    --newtempoIrrigazione02=newtempoIrrigazione01
	    --[[
	    
	    if(baro=='sunny') then
                    dz.log("sunny")
	                newtempoIrrigazione01=math.floor(newtempoIrrigazione01*1.3*tRif/20)
	                newtempoIrrigazione02=math.floor(newtempoIrrigazione02*1.3*tRif/20)
	                
        elseif(baro=='partly cloudy') then
                    dz.log("pc")
                    newtempoIrrigazione01=math.floor(newtempoIrrigazione01*1.15*tRif/20)
	                newtempoIrrigazione02=math.floor(newtempoIrrigazione02*1.15*tRif/20)
                    
        elseif(baro=='cloudy') then
                    dz.log("cl")
                    newtempoIrrigazione01=math.floor(newtempoIrrigazione01*0.8*tRif/20)
                    newtempoIrrigazione02=math.floor(newtempoIrrigazione02*0.8*tRif/20)
                    
        elseif(baro=='rain' and dz.devices("Rain").rain < 0.5) then
                    dz.log("rn")
                    newtempoIrrigazione01=math.floor(newtempoIrrigazione01*0.5*tRif/20)
                    newtempoIrrigazione02=math.floor(newtempoIrrigazione02*0.5*tRif/20)
                    
        elseif(baro=='rain' and dz.devices("Rain").rain >= 0.5) then
                    dz.log("rn")
                    newtempoIrrigazione01=math.floor(newtempoIrrigazione01*0*tRif/20)
                    newtempoIrrigazione02=math.floor(newtempoIrrigazione02*0*tRif/20)
    
        end
        ]]--
    
        --[[
        if(dz.devices("Rain").rain >= 0.5) then
            dz.log("rn")
            newtempoIrrigazione01=math.floor(newtempoIrrigazione01*0*tRif/20)
            newtempoIrrigazione02=math.floor(newtempoIrrigazione02*0*tRif/20)
        end
        --]]
    
        testo = testo .. "Previsione Irrigazione \n"
        testo = testo .. "Valvola 01:\t"..newtempoIrrigazione01.."\n"
        testo = testo .. "Valvola 02:\t"..newtempoIrrigazione02.."\n"
        testo = testo .. "T_Max:\t"..tRif.."\n"
        testo = testo .. "Meteo:\t"..baro.."\n"
        dz.log(testo)
        dz.devices("irrigazioneText").updateText(testo)
            
        if(item.type==dz.EVENT_TYPE_DEVICE and device.state=="Click") then
            tts="'Previsione irrigazione Valvola 1 "..newtempoIrrigazione01.." minuti, Valvola 2 "..newtempoIrrigazione02.." minuti. La temperatura massima odierna è stata di "..tRif.." gradi centigradi'"
            dz.log(tts)
            --os.execute(CMD_PATH..tts)
            dz.log("........."..dz.variables('hum01').value)
        end

        
   
	end
}