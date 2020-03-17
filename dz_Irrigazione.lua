-- Check the wiki at
-- http://www.domoticz.com/wiki/%27dzVents%27:_next_generation_LUA_scripting
return {

	-- 'active' controls if this entire script is considered or not
	active = true, -- set to false to disable this script

	-- trigger
	-- can be a combination:
	on = {
		devices = {'Irrigatore'},
		timer = {'30 minutes after sunset'}
		--timer = {'at 21:00'}
	},
	logging = {
	    level = domoticz.LOG_DEBUG,
	    marker = "Irrigazione: "
	},

	-- actual event code
	-- in case of a timer event or security event, device == nil
	execute = function(dz, device, tginfo)
	    local v_01 = dz.devices("Valvola_01")
	    local v_02 = dz.devices("Valvola_02")
	    local irrig = dz.devices("Irrigatore")
	    --local webcam= dz.devices("Webcam Sala")
	    local rain = dz.devices("Rain").rain
	    local baro= string.lower(dz.devices("THB").forecastString)
	    local waterConsumption=dz.devices("water")
	    local tExt=math.floor(dz.devices("Temperatura Esterna").temperature)
	    local notifyText =""
	    local freqTime = ''
	    local frequenza = dz.devices("Frequenza Irrigatore").level
	    local freqState = dz.devices("Frequenza Irrigatore").state
	    local hum1 = 40--dz.devices("Leaf Moisture 01").state
	    local hum2 = 40--dz.devices("Leaf Moisture 02").state
	    local tRif=dz.variables('maxTemp').value
	    if (frequenza == 0) then
	        freqTime = ''
        elseif (frequenza == 10) then
            freqTime = 'on mon, tue, wed,thu, fri, sat, sun'
        elseif (frequenza == 20) then
            freqTime = 'on mon, wed, fri, sun'
        elseif (frequenza == 30) then 
            freqTime = 'on sun'
        end
        
	            
	    dz.log("Rain Ratio: "..rain)
	    dz.log("Meteo Status: "..baro)
	    --dz.log(">>>>>"..dz.BARO_CLOUDY)
	    dz.log("Temp tExt: "..tExt)
	    dz.log("Frequ: "..freqTime)
	    dz.log("HUM01: "..hum1)
	    dz.log("HUM02: "..hum2)
	    
	    --[[
	    if (tonumber(hum1) < 0) then
            hum1 = 30
        end
        if (tonumber(hum2) < 0) then
            hum2 = 30
        end
        ]]--
    
        --[[
        if(dz.devices("Humidity Sensors").state=="No") then
            hum1=30
            hum2=30
        end
        ]]--


	    --tempoIrrigazione=tExt
	    --newtempoIrrigazione=(70-0.5*(hum1+hum2))/(70-5)*80
	    newtempoIrrigazione01=(90-hum1)/(90-5)*60
	    newtempoIrrigazione02=(90-hum2)/(90-5)*60
	    
	    --select algoritm
	    if (dz.devices('Rain Evaluation').state == "Yes") then
	        waterIsOK = (rain < 0.5 or baro ~= "rain") 
        elseif (dz.devices('Rain Evaluation').state == "No") then
            waterIsOK = true
        end
        
	    --dz.log("alg ")
	    dz.log("Test water ok: "..tostring(waterIsOK))
	    
	    
	    
	    if (waterIsOK) then
	    --if (rain < 0.5 or baro ~= "rain") then
	        if(tginfo.type==dz.EVENT_TYPE_DEVICE) then
	            --[[
	            if(baro=='sunny') then
	                dz.log("Opt:sunny")
	                --tempoIrrigazione=tempoIrrigazione+20
	                --newtempoIrrigazione=math.floor(newtempoIrrigazione*1.3*tRif/20)
	                newtempoIrrigazione01=math.floor(newtempoIrrigazione01*1.3*tRif/20)
	                newtempoIrrigazione02=math.floor(newtempoIrrigazione02*1.3*tRif/20)
	                
                elseif(baro=='partly cloudy') then
                    dz.log("Opt:par cloud")
                    --tempoIrrigazione=tempoIrrigazione+15
                    --newtempoIrrigazione=math.floor(newtempoIrrigazione*1.15*tRif/20)
                    newtempoIrrigazione01=math.floor(newtempoIrrigazione01*1.15*tRif/20)
	                newtempoIrrigazione02=math.floor(newtempoIrrigazione02*1.15*tRif/20)
                    
                elseif(baro=='cloudy') then
                    dz.log("Opt:cloudy")
                    --tempoIrrigazione=tempoIrrigazione
                    --newtempoIrrigazione=math.floor(newtempoIrrigazione*0.8*tRif/20)
                    newtempoIrrigazione01=math.floor(newtempoIrrigazione01*0.8*tRif/20)
	                newtempoIrrigazione02=math.floor(newtempoIrrigazione02*0.8*tRif/20)
	                
	            elseif(baro=='rain') then
                    dz.log("Opt:rain")
                    --tempoIrrigazione=tempoIrrigazione
                    --newtempoIrrigazione=math.floor(newtempoIrrigazione*0.5*tRif/20)
                    newtempoIrrigazione01=math.floor(newtempoIrrigazione01*0.5*tRif/20)
	                newtempoIrrigazione02=math.floor(newtempoIrrigazione02*0.5*tRif/20)
                    
                end
                --]]
                
                newtempoIrrigazione01=dz.helpers.irrigationTime(hum1,tRif,baro)
                newtempoIrrigazione02=dz.helpers.irrigationTime(hum2,tRif,baro)
                
                totalTime=math.max(newtempoIrrigazione01,newtempoIrrigazione02)
                dz.log("Total Time: "..totalTime)
                
                --[[
                notifyText=notifyText.." Irrigazione attivata per "
                notifyText=notifyText..tostring(tempoIrrigazione).." minuti \n"
                notifyText=notifyText.."Temperatura esterna "..tostring(tExt).."°C \n"
                notifyText=notifyText.."Previsione "..baro
                --]]
                
                notifyText=notifyText.." Irrigazione attivata per \n"
                notifyText=notifyText.."Valvola 01 :"..tostring(newtempoIrrigazione01).." minuti \n"
                notifyText=notifyText.."Valvola 02 :"..tostring(newtempoIrrigazione02).." minuti \n"
                notifyText=notifyText.."Tempo Totale :"..tostring(totalTime).." minuti \n"
                notifyText=notifyText.."Temperatura esterna "..tostring(tRif).."°C \n"
                notifyText=notifyText.."Previsione "..baro
                
	            if (irrig.state=="On") then
	                waterConsumption.updateCustomSensor(2)
	                --dz.notify('Irrigazione','Attivata per '..tostring(tempoIrrigazione)..' minuti',PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
	                --dz.notify('Irrigazione','Attivata per '..tostring(tempoIrrigazione)..' minuti',PRIORITY_NORMAL,0,'iPadAir',dz.NSS_PUSHOVER)
	                dz.notify('Irrigazione',notifyText,dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
	                dz.notify('Irrigazione',notifyText,dz.PRIORITY_NORMAL,0,'iPadAir',dz.NSS_PUSHOVER)
	                dz.devices("irrigazioneText").updateText(notifyText)
	                
	                --[[
	                v_01.switchOn().forMin(tempoIrrigazione)
	                v_02.switchOn().forMin(tempoIrrigazione)
	                v_01.switchOn().forMin(tempoIrrigazione)
	                v_02.switchOn().forMin(tempoIrrigazione)
	                irrig.switchOff().afterMin(tempoIrrigazione)
	                --]]
	                
	                v_01.switchOn().forMin(newtempoIrrigazione01)
	                v_02.switchOn().forMin(newtempoIrrigazione02)
	                v_01.switchOn().forMin(newtempoIrrigazione01)
	                v_02.switchOn().forMin(newtempoIrrigazione02)
	                irrig.switchOff().afterMin(totalTime)
	                
	                
	                --webcam.switchOn().afterMin(1)
                end
                if irrig.state=="Off" then
                    
                    irrig.cancelQueuedCommands()
                    v_01.cancelQueuedCommands()
	                v_02.cancelQueuedCommands()
	                
	                v_01.switchOff().repeatAfterMin(1,5)
	                v_02.switchOff().repeatAfterMin(1,5)
	                dz.devices("irrigazioneText").updateText("Stop")
	                
	                --calcolo consumo acqua
	                waterConsumption.updateCustomSensor(math.floor(irrig.lastUpdate.secondsAgo/60*0.7*2))
	                waterConsumption.updateCustomSensor(0).afterMin(5)

	                --scrivo il riassunto updateCustomSensor
	                local riassunto = os.date("%d/%m/%y %H:%M").."\nTempo effettivo: "..tostring(math.floor(irrig.lastUpdate.secondsAgo/60)).." minuti\n"
	                riassunto = riassunto.."Litri effettivi: "..tostring(math.floor(irrig.lastUpdate.secondsAgo/60*0.7*2)).."\n"
	                dz.devices("irrigazioneText").updateText(riassunto)
	                --notifiche
	                dz.notify('Irrigazione',"Stop\n"..riassunto,dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
	                dz.notify('Irrigazione',"Stop\n"..riassunto,dz.PRIORITY_NORMAL,0,'iPadAir',dz.NSS_PUSHOVER)
                end
            end
            if(tginfo.type==dz.EVENT_TYPE_TIMER) then
                if(freqTime ~= "") then
                    if (dz.time.matchesRule(freqTime)) then
                        irrig.switchOn()
                    else
                        dz.notify('Irrigazione',"Disattivo. Impostato a: "..freqState,dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
                        dz.notify('Irrigazione',"Disattivo. Impostato a: "..freqState,dz.PRIORITY_NORMAL,0,'iPadAir',dz.NSS_PUSHOVER)  
                    end
                else
                    dz.notify('Irrigazione',"Impianto Disattivato",dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
	                dz.notify('Irrigazione',"Impianto Disattivato",dz.PRIORITY_NORMAL,0,'iPadAir',dz.NSS_PUSHOVER)    
                end
                
            end
        else
            dz.notify('Irrigazione','Piove '..tostring(math.floor(rain))..' mm',dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
            dz.notify('Irrigazione','Piove '..tostring(math.floor(rain))..' mm',dz.PRIORITY_NORMAL,0,'iPadAir',dz.NSS_PUSHOVER)
            irrig.cancelQueuedCommands()
            irrig.switchOff().silent()
            dz.devices("irrigazioneText").updateText("Piove")
        
        end
	end
}