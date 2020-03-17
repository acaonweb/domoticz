-- this scripts holds all the globally persistent variables and helper functions
-- see the documentation in the wiki
-- NOTE:
-- THERE CAN BE ONLY ONE global_data SCRIPT in your Domoticz install.

return {
	-- global persistent data
	data = {
		--myGlobalVar = { initial = 12 }
	},

	-- global helper functions
	helpers = {
	    irrigationTime = function(hum,temperature,meteo)
			calculatedTime= (100-hum)/(100)*60*temperature/20
			if(meteo=='sunny') then
			    calculatedTime=calculatedTime*1.3
		    elseif (meteo == 'partly cloudy') then
		        calculatedTime=calculatedTime*1.15
	        elseif (meteo == 'cloudy') then
	            calculatedTime=calculatedTime*0.8
            elseif (meteo == 'rain') then
                calculatedTime=calculatedTime*0.3
		    end
		    return math.floor(calculatedTime)
		end
	}
}
