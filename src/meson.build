headphones_plug_controller_sources = [
  'main.vala',
  'detector.vala',
  'controller.vala'
]

headphones_plug_controller_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('libpulse', version: '>= 11.0'),
  dependency('libpulse-mainloop-glib', version: '>= 11.0'),
]

#gnome = import('gnome')
c_args = [
  '-DVERSION="' + meson.project_version() + '"',
  '-DAPP_NAME="' + meson.project_name() + '"',
  '-DAPP_ID="' + app_id + '"'
]

executable('headphones-plug-controller', headphones_plug_controller_sources,
  vala_args: '--target-glib=2.50',
  c_args: c_args,
  dependencies: headphones_plug_controller_deps,
  install: true,
)
