--user settings
local fr = 255
local fg = 0
local fb = 0
local tr = 255
local tg = 255
local tb = 255
local speed = 1
local number_of_flash = 2

return {
	on = {
		devices = {
			'Vibrazione Cassetto'}
		},
		logging = {
	    level = domoticz.LOG_DEBUG,
	    marker = "Cassetto: "
	},
	execute = function(dz, device)
	    dz.log("Cassetto in movimento")
	    dz.notify('Camera',"Cassetto In Movimento",dz.PRIORITY_NORMAL,0,'iPhone6S',dz.NSS_PUSHOVER)
	    for scan =0 , (speed*number_of_flash) , speed  do
	        dz.devices("Luce Sottotetto Cassettiera 2").setColor(fr, fg, fb).afterSec(scan)
		    dz.devices("Luce Sottotetto Cassettiera 2").setColor(tr, tg, tb, 100, 255,255, 3, 255).afterSec(1+scan)
		    dz.devices("Luce Sottotetto Cassettiera").setColor(fr, fg, fb).afterSec(scan)
		    dz.devices("Luce Sottotetto Cassettiera").setColor(tr, tg, tb, 100, 255,255, 3, 255).afterSec(1+scan)
		    dz.devices("Luce Sottotetto Scrivania").setColor(fr, fg, fb).afterSec(scan)
		    dz.devices("Luce Sottotetto Scrivania").setColor(tr, tg, tb, 100, 255,255, 3, 255).afterSec(1+scan)
		end
	end
}
