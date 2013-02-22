require 'tk'
libdir = './lib'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require 'create'
require 'start'
require 'generate'
$root = TkRoot.new { 
title "Test Creator" 
minsize(400,400)
}
btn_start = TkButton.new($root) do
  text "Start"
  borderwidth 3
  font TkFont.new('arial 12 bold')
  foreground  "black"
  activebackground "blue"
  command {start}
  pack('fill' => 'x')
end
btn_create = TkButton.new($root) do
  text "Create"
  borderwidth 3
  font TkFont.new('arial 12 bold')
  foreground  "black"
  activebackground "blue"
  command {create}
  pack('fill' => 'x')
end
btn_start = TkButton.new($root) do
  text "Generate"
  borderwidth 3
  font TkFont.new('arial 12 bold')
  foreground  "black"
  activebackground "blue"
  command {generate}
  pack('fill' => 'x')
end

exiting = Proc.new{
  exit(0)
}
file_menu = TkMenu.new($root)

file_menu.add('command',
              'label'     => "Create",
              'command'   => Proc.new{create},
              'underline' => 0)
file_menu.add('command',
              'label'     => "Start",
              'command'   => Proc.new{start},
              'underline' => 0)
file_menu.add('command',
              'label'     => "Generate",
              'command'   => Proc.new{generate},
              'underline' => 0)
file_menu.add('separator')
file_menu.add('command',
              'label'     => "Exit",
              'command'   => exiting,
              'underline' => 3)
help_menu = TkMenu.new($root)
help_menu.add('command',
              'label'     => "Help",
              'command'   => exiting,
              'underline' => 0)
menu_bar = TkMenu.new
menu_bar.add('cascade',
             'menu'  => file_menu,
             'label' => "File")
menu_bar.add('cascade',
             'menu'  => help_menu,
             'label' => "Help")
$root.menu(menu_bar)

Tk.mainloop