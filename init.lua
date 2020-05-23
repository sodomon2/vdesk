#!/usr/bin/lua

--[[--
 @package   vdesk
 @filename  init.lua
 @version   1.0
 @author    Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      08.05.2020 00:07:45 -04
--]] 

-- declaro mis variables globales

require('lib.middleclass')                 -- la libreria middleclass me da soporte a OOP
local lgi = require('lgi')                 -- requiero esta libreria que me permitira usar GTK

local GObject = lgi.GObject                -- parte de lgi
local GLib    = lgi.GLib                   -- para el treeview
local Gtk     = lgi.require('Gtk', '3.0')  -- el objeto GTK

local assert  = lgi.assert
local builder = Gtk.Builder()

assert(builder:add_from_file('vistas/vdesk.ui'),"error al cargar el archivo") -- hago un debugger, si este archivo existe (true) enlaso el archivo ejemplo.ui, si no existe (false) imprimo un error
local ui = builder.objects

local app_run      = false

-- declaro los objetos
local main_window  = ui.main_window                     -- invoco la ventana con el id main_window
local about_window = ui.about_window                    -- invoco la ventana con el id about_window

local btn_play     = builder:get_object("btn_play")     -- invoco al boton con el id btn_play
local btn_about    = builder:get_object("btn_about")    -- invoco al boton con el id btn_about
local btn_cerrar   = builder:get_object("btn_cerrar")   -- invoco al boton con el id btn_cerrar
local mensaje      = builder:get_object("mensaje")      -- invoco al label con el id mensaje
local load_file    = builder:get_object("load_file")    -- invoco al boton con el id load_file
local vdesk_tray   = builder:get_object("vdesk_tray")   -- invoco al statusicon con el id vdesk_tray

function btn_play:on_clicked()
	local filename = load_file:get_filename()
	if filename and app_run == false then
        mensaje.label = "Ejecutando"
		local cmd  =  "/usr/bin/mplayer -fs ".. filename .."  &"
		os.execute(cmd)
        main_window:hide()
    else
		mensaje.label = "Por favor selecione un video"
    end
end

-- al precionar el btn_about me despliga la about_window
function btn_about:on_clicked()
  about_window:run()  
  about_window:hide()  
end

-- cierro la ventana cuando se presione boton cerrar (x)
-- y mato el proceso mplayer
function main_window:on_destroy()
	os.execute("killall -9 mplayer")
    Gtk.main_quit()
end

-- variable para detectar si la ventana es visible
local visible = false

-- defino si el trayicon es visible, si es visible muestro la ventana main_window
-- si no es visible entonces oculto la ventana main_window
function trayicon()
	visible = not visible
	if visible then
		ui.main_window:show_all()
	else
		ui.main_window:hide()
	end
end

-- al precionar el trayicon ejecuta la funcion trayicon()
function vdesk_tray:on_activate()
	trayicon()
end

-- al precionar el btn_cerrar cierro la ventana
function btn_cerrar:on_clicked()
    Gtk.main_quit()
end 

-- inicio la ventana y muestro todo
main_window:show_all()
Gtk.main()
