project('headphones-plug-controller', ['c', 'vala'],
  version: '0.1.1',
  meson_version: '>= 0.40.0',
)

app_id = 'com.gitlab.nvlgit.' + meson.project_name()

datadir = get_option('datadir')

doc_subdir = join_paths(datadir, 'doc', meson.project_name())
install_data('README.md',
             install_dir: doc_subdir)

licenses_subdir = join_paths(datadir, 'licenses', meson.project_name())
install_data('COPYING',
             install_dir: licenses_subdir)

subdir('src')
subdir('systemd')
