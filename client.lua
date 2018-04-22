--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]


vRP = Proxy.getInterface("vRP")
vRPg = Proxy.getInterface("vRP_garages")

function deleteVehiclePedIsIn()
  local v = GetVehiclePedIsIn(GetPlayerPed(-1),false)
  SetVehicleHasBeenOwnedByPlayer(v,false)
  Citizen.InvokeNative(0xAD738C3085FE7E11, v, false, true) -- set not as mission entity
  SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(v))
  Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(v))
end

local vehshop = {
	opened = false,
	title = "Concessionária de Veiculos",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.1,
		y = 0.08,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "Veiculos de SLS",
			name = "main",
			buttons = {
				{name = "Carros", description = ""},
				{name = "Motos", description = ""},
			}
		},
        ["Carros"] = {
			title = "Carros",
			name = "Carros",
			buttons = {
				{name = "Brasileiros", description = ''},
				{name = "Arrancadao", description = ''},
				{name = "Importados", description = ''},
			}
		},
		["Brasileiros"] = {
			title = "Brasileiros",
			name = "Brasileiros",
			buttons = {
                {name = "Gm Chevette", costs = 8000, description = {}, model = "chevette"},
                {name = "Citrôen DS4", costs = 90000, description = {}, model = "citroends4"},
                {name = "Fiat Toro", costs = 85000, description = {}, model = "fiattoro"},
                {name = "Ford Everest", costs = 160000, description = {}, model = "fordeverest"},
                {name = "Ford Fiesta", costs = 55000, description = {}, model = "fordfiesta"},
                {name = "Vw Fusca", costs = 8000, description = {}, model = "fusca"},
                {name = "Pajero", costs = 165000, description = {}, model = "pajero"},
                {name = "Vw Passat", costs = 155000, description = {}, model = "passat"},
                {name = "Hyundai Veloster", costs = 45000, description = {}, model = "veloster"},
                {name = "Volkswagen R50", costs = 280000, description = {}, model = "volkswagenr50"},
                

			}
		},
		["Arrancadao"] = {
			title = "Arrancadao",
			name = "Arrancadao",
			buttons = {
				{name = "KR 150cc", costs = 100000, description = {}, model = "kr150"},
                {name = "C10 Turbo", costs = 100000, description = {}, model = "c10ss"},
                
			}
		},
		["sports"] = {
			title = "sports",
			name = "sports",
			buttons = {
				--{name = "9F", costs = 120000, description = {}, model = "ninef"},
				--{name = "9F Cabrio", costs = 130000, description = {}, model = "ninef2"},
				--{name = "Alpha", costs = 150000, description = {}, model = "alpha"},
			    --{name = "Banshee", costs = 105000, description = {}, model = "banshee"},
				--{name = "Bestia GTS", costs = 610000, description = {}, model = "bestiagts"},
				--{name = "Blista Compact", costs = 42000, description = {}, model = "blista"},
				--{name = "Buffalo", costs = 35000, description = {}, model = "buffalo"},
				--{name = "Buffalo S", costs = 96000, description = {}, model = "buffalo2"},
				{name = "Carbonizzare", costs = 195000, description = {}, model = "carbonizzare"},
				{name = "Comet", costs = 100000, description = {}, model = "comet2"},
				{name = "Coquette", costs = 138000, description = {}, model = "coquette"},
				--{name = "Drift Tampa", costs = 995000, description = {}, model = "tampa2"},
				--{name = "Feltzer", costs = 130000, description = {}, model = "feltzer2"},
				--{name = "Fusilade", costs = 36000, description = {}, model = "fusilade"},
				--{name = "Jester", costs = 240000, description = {}, model = "jester"},
				--{name = "Jester(Racecar)", costs = 350000, description = {}, model = "jester2"},	
				{name = "Lancer EVO", costs = 45000, description = {}, model = "Kuruma"},
				{name = "Audi S5", costs = 45000, description = {}, model = "sentinel"},
				{name = "Audi RS6", costs = 75000, description = {}, model = "rs6"},
				{name = "Massacro", costs = 275000, description = {}, model = "massacro"},
				{name = "Massacro(Racecar)", costs = 385000, description = {}, model = "massacro2"},
				--{name = "Omnis", costs = 701000, description = {}, model = "omnis"},
				--{name = "Penumbra", costs = 24000, description = {}, model = "penumbra"},
				--{name = "Rapid GT", costs = 140000, description = {}, model = "rapidgt"},
				--{name = "Rapid GT Convertible", costs = 150000, description = {}, model = "rapidgt2"},
				{name = "Schafter V12", costs = 140000, description = {}, model = "schafter3"},
				{name = "Sultan", costs = 12000, description = {}, model = "sultan"},
				--{name = "Surano", costs = 110000, description = {}, model = "surano"},
				--{name = "Tropos", costs = 816000, description = {}, model = "tropos"},
				--{name = "Verkierer", costs = 695000, description = {}, model = "verlierer2"},
			}
		},
		["sportsclassics"] = {
			title = "sportsclassics",
			name = "sportsclassics",
			buttons = {
				{name = "Casco", costs = 680000, description = {}, model = "casco"},
				{name = "Coquette Classic", costs = 665000, description = {}, model = "coquette2"},
				{name = "JB 700", costs = 350000, description = {}, model = "jb700"},
				{name = "Pigalle", costs = 400000, description = {}, model = "pigalle"},
				{name = "Stinger", costs = 850000, description = {}, model = "stinger"},
				{name = "Stinger GT", costs = 875000, description = {}, model = "stingergt"},
				{name = "Stirling GT", costs = 975000, description = {}, model = "feltzer3"},
				{name = "Z-Type", costs = 950000, description = {}, model = "ztype"},
			}
		},
		["supers"] = {
			title = "supers",
			name = "supers",
			buttons = {
				{name = "Adder", costs = 1000000, description = {}, model = "adder"},
				{name = "Banshee 900R", costs = 565000, description = {}, model = "banshee2"},
				{name = "Bullet", costs = 155000, description = {}, model = "bullet"},
				{name = "Cheetah", costs = 650000, description = {}, model = "cheetah"},
				{name = "Entity XF", costs = 795000, description = {}, model = "entityxf"},
				{name = "ETR1", costs = 199500, description = {}, model = "sheava"},
				{name = "FMJ", costs = 1750000, description = {}, model = "fmj"},
				{name = "Infernus", costs = 440000, description = {}, model = "infernus"},
				{name = "Osiris", costs = 1950000, description = {}, model = "osiris"},
				{name = "RE-7B", costs = 2475000, description = {}, model = "le7b"},
				{name = "Reaper", costs = 1595000, description = {}, model = "reaper"},
				{name = "Sultan RS", costs = 795000, description = {}, model = "sultanrs"},
				{name = "T20", costs = 2200000, description = {}, model = "t20"},
				{name = "Turismo R", costs = 500000, description = {}, model = "turismor"},
				{name = "Tyrus", costs = 2550000, description = {}, model = "tyrus"},
				{name = "Vacca", costs = 240000, description = {}, model = "vacca"},
				{name = "Voltic", costs = 150000, description = {}, model = "voltic"},
				{name = "X80 Proto", costs = 2700000, description = {}, model = "prototipo"},
				{name = "Zentorno", costs = 725000, description = {}, model = "zentorno"},
			}
		},
		["Importados"] = {
			title = "Importados",
			name = "Importados",
			buttons = {

			    {name = "Subaru STI", costs = 150000, description = {}, model = "sti"},
			    {name = "Mercedez G65", costs = 300000, description = {}, model = "g65amg"},
			    {name = "Mercedez S500", costs = 400000, description = {}, model = "s500w222"},
			    --{name = "Jeep CJ7", costs = 150000, description = {}, model = "cj7"},
			    --{name = "Bronco", costs = 150000, description = {}, model = "mudsl"},
			    --{name = "Rancher XL", costs = 150000, description = {}, model = "rancherxlextreme"},
			    --{name = "Dodge Ram", costs = 150000, description = {}, model = "megaram"},
			    {name = "Caracara", costs = 250000, description = {}, model = "caracarase"},
			    --{name = "Ford Raptor", costs = 200000, description = {}, model = "raptor2017"},
			    --{name = "Mercedez G65", costs = 150000, description = {}, model = "G65"},
			    {name = "Mercedez A45", costs = 120000, description = {}, model = "a45"},
			    {name = "Audi R8", costs = 1150000, description = {}, model = "audir8"},
			    {name = "Audi RS6", costs = 650000, description = {}, model = "audirs6"},
			    {name = "Audi TT ", costs = 200000, description = {}, model = "auditt"},
			    {name = "Bmw X6", costs = 300000 , description = {}, model = "bmwx6"},
			    {name = "Bmw i8", costs = 400000, description = {}, model = "i8"},
			    {name = "Evoque", costs = 250000, description = {}, model = "evoque"},
			    {name = "Ferrari F360", costs = 1250000, description = {}, model = "ferrarif360"},
			    {name = "Ferrari GTB", costs = 2500000, description = {}, model = "ferrarigtb"},
			    {name = "Lamborghini 610", costs = 1120000, description = {}, model = "lamborghini610"},
			    {name = "Lamborghini Gallardo", costs = 1425000, description = {}, model = "lamborghinigallardo"},
			    {name = "Lamborghini Veneno", costs = 2700000, description = {}, model = "lamborghiniveneno"},
			    {name = "Lancer Evolution", costs = 125000, description = {}, model = "lancerevolution"},
			    {name = "Mazda RX8", costs = 150000, description = {}, model = "mazdarx8"},
			    {name = "Murcielago", costs = 2300000, description = {}, model = "murcielago"},
			    {name = "Mustang GT500", costs = 170000, description = {}, model = "mustanggt500"},
			    {name = "Nissan GTR", costs = 500000, description = {}, model = "nissangtr"},
			    {name = "Nissan GTR Conver", costs = 400000, description = {}, model = "nissangtrconversivel"},
			    {name = "Mazda RX7", costs = 140000, description = {}, model = "rx7fortune"},
			    {name = "Skyline GTR34", costs = 350000, description = {}, model = "skylinegtr34"},
			    {name = "Subaru Impreza", costs = 80000, description = {}, model = "subaruimpreza"},
			    {name = "Tesla Roadster", costs = 800000, description = {}, model = "teslaroadster"},
			  

			}
		},
		["offroad"] = {
			title = "offroad",
			name = "offroad",
			buttons = {
				{name = "Bifta", costs = 75000, description = {}, model = "bifta"},
				{name = "Blazer", costs = 8000, description = {}, model = "blazer"},
				{name = "Brawler", costs = 715000, description = {}, model = "brawler"},
				{name = "Bubsta 6x6", costs = 249000, description = {}, model = "dubsta3"},
				{name = "Dune Buggy", costs = 20000, description = {}, model = "dune"},
				{name = "Rebel", costs = 22000, description = {}, model = "rebel2"},
				{name = "Sandking", costs = 38000, description = {}, model = "sandking"},
				{name = "The Liberator", costs = 550000, description = {}, model = "monster"},
				{name = "Trophy Truck", costs = 550000, description = {}, model = "trophytruck"},
			}
		},
		["suvs"] = {
			title = "suvs",
			name = "suvs",
			buttons = {
				{name = "Baller", costs = 90000, description = {}, model = "baller"},
				{name = "Saveiro", costs = 60000, description = {}, model = "cavalcade"},
				{name = "Grabger", costs = 35000, description = {}, model = "granger"},
				{name = "Huntley S", costs = 195000, description = {}, model = "huntley"},
				{name = "Landstalker", costs = 58000, description = {}, model = "landstalker"},
				{name = "Radius", costs = 32000, description = {}, model = "radi"},
				{name = "Rocoto", costs = 85000, description = {}, model = "rocoto"},
				{name = "Seminole", costs = 30000, description = {}, model = "seminole"},
				{name = "XLS", costs = 253000, description = {}, model = "xls"},
			}
		},
		["vans"] = {
			title = "vans",
			name = "vans",
			buttons = {
				{name = "Bison", costs = 30000, description = {}, model = "bison"},
				{name = "Bobcat XL", costs = 23000, description = {}, model = "bobcatxl"},
				{name = "Gang Burrito", costs = 65000, description = {}, model = "gburrito"},
				{name = "Journey", costs = 15000, description = {}, model = "journey"},
				{name = "Minivan", costs = 30000, description = {}, model = "minivan"},
				{name = "Paradise", costs = 25000, description = {}, model = "paradise"},
				{name = "Rumpo", costs = 13000, description = {}, model = "rumpo"},
				{name = "Surfer", costs = 11000, description = {}, model = "surfer"},
				{name = "Youga", costs = 16000, description = {}, model = "youga"},
			}
		},
		["sedans"] = {
			title = "sedans",
			name = "sedans",
			buttons = {
				{name = "Asea", costs = 1000000, description = {}, model = "asea"},
				{name = "Asterope", costs = 1000000, description = {}, model = "asterope"},
				{name = "Cognoscenti", costs = 1000000, description = {}, model = "cognoscenti"},
				{name = "Cognoscenti(Armored)", costs = 1000000, description = {}, model = "cognoscenti2"},
				{name = "Cognoscenti 55", costs = 1000000, description = {}, model = "cog55"},
				{name = "Cognoscenti 55(Armored", costs = 1500000, description = {}, model = "cog552"},
				{name = "Fugitive", costs = 24000, description = {}, model = "fugitive"},
				{name = "Glendale", costs = 200000, description = {}, model = "glendale"},
			--	{name = "Ingot", costs = 9000, description = {}, model = "ingot"},
				--{name = "Intruder", costs = 16000, description = {}, model = "intruder"},
			--	{name = "Premier", costs = 10000, description = {}, model = "premier"},
			--	{name = "Primo", costs = 9000, description = {}, model = "primo"},
				--{name = "Primo Custom", costs = 9500, description = {}, model = "primo2"},
				--{name = "Regina", costs = 8000, description = {}, model = "regina"},
				{name = "Schafter", costs = 65000, description = {}, model = "schafter2"},
				--{name = "Stanier", costs = 10000, description = {}, model = "stanier"},
				--{name = "Stratum", costs = 10000, description = {}, model = "stratum"},
				--{name = "Stretch", costs = 30000, description = {}, model = "stretch"},
				--{name = "Super Diamond", costs = 250000, description = {}, model = "superd"},
				--{name = "Surge", costs = 38000, description = {}, model = "surge"},
				--{name = "Tailgater", costs = 55000, description = {}, model = "tailgater"},
				--{name = "Warrener", costs = 120000, description = {}, model = "warrener"},
				--{name = "Washington", costs = 15000, description = {}, model = "washington"},
			}
		},
		["Motos"] = {
			title = "Motos",
			name = "Motos",
			buttons = {
				{name = "Biz 125", costs = 3000, description = {}, model = "biz25"},
				{name = "Mobilete", costs = 1500, description = {}, model = "mobi"},
				{name = "Titan 150", costs = 5000, description = {}, model = "150"},
                {name = "Bmw S1000RR", costs = 75000, description = {}, model = "bmwrr"},
                {name = "Honda CB1000", costs = 55000, description = {}, model = "cb1000"},
                {name = "Honda CB1000RR", costs = 65000, description = {}, model = "cbrr"},
                {name = "Agusta F4RR", costs = 50000, description = {}, model = "f4rr"},
                {name = "Harley F131", costs = 50000, description = {}, model = "f131"},
                {name = "Kw ZX10R", costs = 75000, description = {}, model = "kwninja"},
                {name = "Motinha", costs = 2000, description = {}, model = "motinha"},
                {name = "Yamaha R1", costs = 55000, description = {}, model = "r1"},
                {name = "Kw Z1000", costs = 60000, description = {}, model = "z1000"},
                {name = "Kw ZX10", costs = 65000, description = {}, model = "zx10"},
			}
		},
	}
}
local fakecar = {model = '', car = nil}
local vehshop_locations = {
{entering = {-33.803,-1102.322,25.422}, inside = {-46.56327,-1097.382,25.99875, 120.1953}, outside = {-31.849,-1090.648,25.998,322.345}},
}

local vehshop_blips ={}
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false

function vehSR_drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function vehSR_IsPlayerInRangeOfVehshop()
	return inrangeofvehshop
end

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
if firstspawn == 0 then
	--326 car blip 227 225
	vehSR_ShowVehshopBlips(true)
	firstspawn = 1
end
end)

function vehSR_ShowVehshopBlips(bool)
	if bool and #vehshop_blips == 0 then
		for station,pos in pairs(vehshop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			-- 60 58 137
			SetBlipSprite(blip,326)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Simeon Showroom")
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(vehshop_blips, {blip = blip, pos = loc})
		end
		Citizen.CreateThread(function()
			while #vehshop_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				for i,b in ipairs(vehshop_blips) do
					if IsPlayerWantedLevelGreater(GetPlayerIndex(),0) == false and vehshop.opened == false and IsPedInAnyVehicle(vehSR_LocalPed(), true) == false and  GetDistanceBetweenCoords(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],GetEntityCoords(vehSR_LocalPed())) < 5 then
						DrawMarker(1,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0)
						vehSR_drawTxt("Pressione ~g~ENTER~s~ para comprar ~b~veiculo",0,1,0.5,0.8,0.6,255,255,255,255)
						currentlocation = b
						inrange = true
					end
				end
				inrangeofvehshop = inrange
			end
		end)
	elseif bool == false and #vehshop_blips > 0 then
		for i,b in ipairs(vehshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		vehshop_blips = {}
	end
end

function vehSR_f(n)
	return n + 0.0001
end

function vehSR_LocalPed()
	return GetPlayerPed(-1)
end

function vehSR_try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end
function vehSR_firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end
--local veh = nil
function vehSR_OpenCreator()
	boughtcar = false
	local ped = vehSR_LocalPed()
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])
	vehshop.currentmenu = "main"
	vehshop.opened = true
	vehshop.selectedbutton = 0
end
local vehicle_price = 0
function vehSR_CloseCreator(vehicle,veh_type)
	Citizen.CreateThread(function()
		local ped = vehSR_LocalPed()
		if not boughtcar then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
		else
			deleteVehiclePedIsIn()
			vRP.teleport({-44.21378326416,-1079.1402587891,26.67050743103})
			vRPg.spawnBoughtVehicle({veh_type, vehicle})
			SetEntityVisible(ped,true)
			FreezeEntityPosition(ped,false)
		end
		vehshop.opened = false
		vehshop.menu.from = 1
		vehshop.menu.to = 10
	end)
end

function vehSR_drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function vehSR_drawMenuTitle(txt,x,y)
local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end
function vehSR_tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
function vehSR_Notify(text)
SetNotificationTextEntry('STRING')
AddTextComponentString(text)
DrawNotification(false, false)
end

function vehSR_drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.06, y - menu.height/2 + 0.0028)
end
local backlock = false
Citizen.CreateThread(function()
	local last_dir
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1,201) and vehSR_IsPlayerInRangeOfVehshop() then
			if vehshop.opened then
				vehSR_CloseCreator("","")
			else
				vehSR_OpenCreator()
			end
		end
		if vehshop.opened then
			local ped = vehSR_LocalPed()
			local menu = vehshop.menu[vehshop.currentmenu]
			vehSR_drawTxt(vehshop.title,1,1,vehshop.menu.x,vehshop.menu.y,1.0, 255,255,255,255)
			vehSR_drawMenuTitle(menu.title, vehshop.menu.x,vehshop.menu.y + 0.08)
			vehSR_drawTxt(vehshop.selectedbutton.."/"..vehSR_tablelength(menu.buttons),0,0,vehshop.menu.x + vehshop.menu.width/2 - 0.0385,vehshop.menu.y + 0.067,0.4, 255,255,255,255)
			local y = vehshop.menu.y + 0.12
			buttoncount = vehSR_tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= vehshop.menu.from and i <= vehshop.menu.to then

					if i == vehshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					vehSR_drawMenuButton(button,vehshop.menu.x,y,selected)
					if button.costs ~= nil then
						if vehshop.currentmenu == "Brasileiros" or vehshop.currentmenu == "Arrancadao" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "supers" or vehshop.currentmenu == "Importados" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "Motos" then
							vehSR_drawMenuRight(button.costs.."$",vehshop.menu.x,y,selected)
						else
							vehSR_drawMenuButton(button,vehshop.menu.x,y,selected)
						end
					end
					y = y + 0.04
					if vehshop.currentmenu == "Brasileiros" or vehshop.currentmenu == "Arrancadao" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "supers" or vehshop.currentmenu == "Importados" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "Motos" then
						if selected then
							if fakecar.model ~= button.model then
								if DoesEntityExist(fakecar.car) then
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
								end
								local pos = currentlocation.pos.inside
								local hash = GetHashKey(button.model)
								RequestModel(hash)
								local timer = 0
								while not HasModelLoaded(hash) and timer < 255 do
									Citizen.Wait(1)
									vehSR_drawTxt("Loading...",0,1,0.5,0.5,1.5,255,255-timer,255-timer,255)
									RequestModel(hash)
									timer = timer + 1
								end
								if timer < 255 then
									local veh = CreateVehicle(hash,pos[1],pos[2],pos[3],pos[4],false,false)
									while not DoesEntityExist(veh) do
										Citizen.Wait(1)
										vehSR_drawTxt("Loading...",0,1,0.5,0.5,1.5,255,255-timer,255-timer,255)
									end
									FreezeEntityPosition(veh,true)
									SetEntityInvincible(veh,true)
									SetVehicleDoorsLocked(veh,4)
									--SetEntityCollision(veh,false,false)
									TaskWarpPedIntoVehicle(vehSR_LocalPed(),veh,-1)
									for i = 0,24 do
										SetVehicleModKit(veh,0)
										RemoveVehicleMod(veh,i)
									end
									fakecar = { model = button.model, car = veh}
								else
									timer = 0
									while timer < 50 do
										Citizen.Wait(1)
										vehSR_drawTxt("Failed!",0,1,0.5,0.5,1.5,255,0,0,255)
										timer = timer + 1
									end
									if last_dir then
										if vehshop.selectedbutton < buttoncount then
											vehshop.selectedbutton = vehshop.selectedbutton +1
											if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
												vehshop.menu.to = vehshop.menu.to + 1
												vehshop.menu.from = vehshop.menu.from + 1
											end
										else
											last_dir = false
											vehshop.selectedbutton = vehshop.selectedbutton -1
											if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
												vehshop.menu.from = vehshop.menu.from -1
												vehshop.menu.to = vehshop.menu.to - 1
											end
										end
									else
										if vehshop.selectedbutton > 1 then
											vehshop.selectedbutton = vehshop.selectedbutton -1
											if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
												vehshop.menu.from = vehshop.menu.from -1
												vehshop.menu.to = vehshop.menu.to - 1
											end
										else
											last_dir = true
											vehshop.selectedbutton = vehshop.selectedbutton +1
											if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
												vehshop.menu.to = vehshop.menu.to + 1
												vehshop.menu.from = vehshop.menu.from + 1
											end
										end
									end
								end
							end
						end
					end
					if selected and IsControlJustPressed(1,201) then
						vehSR_ButtonSelected(button)
					end
				end
			end
			if IsControlJustPressed(1,202) then
				vehSR_Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				last_dir = false
				if vehshop.selectedbutton > 1 then
					vehshop.selectedbutton = vehshop.selectedbutton -1
					if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
						vehshop.menu.from = vehshop.menu.from -1
						vehshop.menu.to = vehshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				last_dir = true
				if vehshop.selectedbutton < buttoncount then
					vehshop.selectedbutton = vehshop.selectedbutton +1
					if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
						vehshop.menu.to = vehshop.menu.to + 1
						vehshop.menu.from = vehshop.menu.from + 1
					end
				end
			end
		end

	end
end)


function vehSR_round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end
function vehSR_ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = vehshop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Carros" then
			vehSR_OpenMenu('Carros')
		elseif btn == "Motos" then
			vehSR_OpenMenu('Motos')
		end
	elseif this == "Carros" then
		if btn == "sports" then
			vehSR_OpenMenu('sports')
		elseif btn == "sedans" then
			vehSR_OpenMenu('sedans')
		elseif btn == "Brasileiros" then
			vehSR_OpenMenu('Brasileiros')
		elseif btn == "Arrancadao" then
			vehSR_OpenMenu('Arrancadao')
		elseif btn == "sportsclassics" then
			vehSR_OpenMenu("sportsclassics")
		elseif btn == "supers" then
			vehSR_OpenMenu('supers')
		elseif btn == "Importados" then
			vehSR_OpenMenu('Importados')
		elseif btn == "offroad" then
			vehSR_OpenMenu('offroad')
		elseif btn == "suvs" then
			vehSR_OpenMenu('suvs')
		elseif btn == "vans" then
			vehSR_OpenMenu('vans')
		end
	elseif this == "Brasileiros" or this == "Arrancadao" or this == "sedans" or this == "sports" or this == "sportsclassics" or this == "supers" or this == "Importados" or this == "offroad" or this == "suvs" or this == "vans" or this == "industrial" then
		TriggerServerEvent('veh_SR:CheckMoneyForVeh',button.model,button.costs, "car")
    elseif this == "cycles" or this == "Motos" then
		TriggerServerEvent('veh_SR:CheckMoneyForVeh',button.model,button.costs, "bike")
	end
end

RegisterNetEvent('veh_SR:CloseMenu')
AddEventHandler('veh_SR:CloseMenu', function(vehicle, veh_type)
	boughtcar = true
	vehSR_CloseCreator(vehicle,veh_type)
end)

function vehSR_OpenMenu(menu)
	fakecar = {model = '', car = nil}
	vehshop.lastmenu = vehshop.currentmenu
	if menu == "Carros" then
		vehshop.lastmenu = "main"
	elseif menu == "bikes"  then
		vehshop.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		vehshop.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		vehshop.lastmenu = "race_create_objects"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end


function vehSR_Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		vehSR_CloseCreator("","")
	elseif vehshop.currentmenu == "Brasileiros" or vehshop.currentmenu == "Arrancadao" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "supers" or vehshop.currentmenu == "Importados" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "Motos" then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		vehSR_OpenMenu(vehshop.lastmenu)
	else
		vehSR_OpenMenu(vehshop.lastmenu)
	end

end

function vehSR_stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end