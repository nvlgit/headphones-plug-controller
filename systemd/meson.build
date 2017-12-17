
systemd_dep = dependency('systemd')
servicedir = systemd_dep.get_pkgconfig_variable('systemduserunitdir')

if servicedir == ''
  error('Couldn\'t determine systemd user unit service directory')
endif

config_bindir = configuration_data()
config_bindir.set('bindir', join_paths(get_option('prefix'), get_option('bindir')))

configure_file(
  input: 'headphones-plug-controller.service.in',
  output: 'headphones-plug-controller.service',
  configuration : config_bindir,
  install: true,
  install_dir: servicedir
)

