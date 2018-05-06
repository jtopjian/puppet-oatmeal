node /workstation/ {
  include roles::workstation
}

node /puppet/ {
  include roles::puppetserver
}

node /infra/ {
  include roles::infra
}

node /keystone/ {
  include roles::keystone
}

node /glance/ {
  include roles::glance
}

node /neutron/ {
  include roles::neutron
}

node /nova/ {
  include roles::nova
}

node /c01/ {
  include roles::compute
}

node /cinder/ {
  include roles::cinder
}

node /heat/ {
  include roles::heat
}

node /zaqar/ {
  include roles::zaqar
}

node /zun/ {
  include roles::zun
}

node /z01/ {
  include roles::zcompute
}

node /swift/ {
  include roles::swift
}

node /gnocchi/ {
  include roles::gnocchi
}

node /barbican/ {
  include roles::barbican
}

node /senlin/ {
  include roles::senlin
}

node /magnum/ {
  include roles::magnum
}

