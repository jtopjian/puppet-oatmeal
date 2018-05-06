class profiles::openstack::keystone {
  $settings          = lookup('openstack::keystone::settings')
  $region            = lookup('openstack::region', undef, undef, 'RegionOne')
  $admin_password    = lookup('openstack::users::admin::password')
  $demo_password     = lookup('openstack::users::demo::password')
  $glance_password   = lookup('openstack::users::glance::password')
  $neutron_password  = lookup('openstack::users::neutron::password')
  $nova_password     = lookup('openstack::users::nova::password')
  $cinder_password   = lookup('openstack::users::cinder::password')
  $heat_password     = lookup('openstack::users::heat::password')
  $zaqar_password    = lookup('openstack::users::zaqar::password')
  $zun_password      = lookup('openstack::users::zun::password')
  $kuryr_password    = lookup('openstack::users::kuryr::password')
  $swift_password    = lookup('openstack::users::swift::password')
  $gnocchi_password  = lookup('openstack::users::gnocchi::password')
  $barbican_password = lookup('openstack::users::barbican::password')
  $senlin_password   = lookup('openstack::users::senlin::password')
  $magnum_password   = lookup('openstack::users::magnum::password')

  class { 'cubbystack::keystone':
    settings => $settings,
  }
  contain cubbystack::keystone

  # Overwrite the default keystone wsgi configuration
  Package<| tag == 'cubbystack_keystone' |>          -> File['/etc/apache2/sites-available/keystone.conf']
  File['/etc/apache2/sites-available/keystone.conf'] ~> Exec<| tag == 'cubbystack_keystone_apache' |>
  file { '/etc/apache2/sites-available/keystone.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///files/profiles/openstack/keystone/wsgi.conf',
  }

  file { '/etc/keystone/fernet-keys':
    ensure => directory,
    owner  => 'keystone',
    group  => 'keystone',
    mode   => '0600',
  }

  exec { 'keystone-manage fernet_setup':
    command => 'keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone',
    path    => '/usr/bin',
    user    => 'keystone',
    creates => "/etc/keystone/fernet-keys/0",
    notify  => Exec['keystone-manage bootstrap'],
    require => File['/etc/keystone/fernet-keys'],
  }

  exec { 'keystone-manage bootstrap':
    command     => 'keystone-manage bootstrap',
    environment => "OS_BOOTSTRAP_PASSWORD=${admin_password}",
    user        => 'keystone',
    path        => '/usr/bin',
    refreshonly => true,
    tag         => 'keystone-exec',
  }

  # Catalog entries
  cubbystack::functions::create_keystone_endpoint { "${region}/identity":
    public_url   => "http://keystone:5000/v3",
    admin_url    => "http://keystone:35357/v3",
    internal_url => "http://keystone:5000/v3",
    service_name => 'OpenStack Identity Service',
    tag          => $region,
  }

  cubbystack::functions::create_keystone_endpoint { "${region}/image":
    public_url   => "http://glance:9292",
    admin_url    => "http://glance:9292",
    internal_url => "http://glance:9292",
    service_name => 'OpenStack Image Service',
    tag          => $region,
  }

  cubbystack::functions::create_keystone_endpoint { "${region}/network":
    public_url   => "http://neutron:9696",
    admin_url    => "http://neutron:9696",
    internal_url => "http://neutron:9696",
    service_name => 'OpenStack Networking Service',
    tag          => $region,
  }

  cubbystack::functions::create_keystone_endpoint { "${region}/compute":
    public_url   => "http://nova:8774/v2.1/%(tenant_id)s",
    admin_url    => "http://nova:8774/v2.1/%(tenant_id)s",
    internal_url => "http://nova:8774/v2.1/%(tenant_id)s",
    service_name => 'OpenStack Compute Service',
    tag          => $region,
  }

  cubbystack::functions::create_keystone_endpoint { "${region}/placement":
    public_url   => "http://nova:8778",
    admin_url    => "http://nova:8778",
    internal_url => "http://nova:8778",
    service_name => 'OpenStack Placement API',
    tag          => $region,
  }

 cubbystack::functions::create_keystone_endpoint { "${region}/volumev2":
    public_url   => "http://cinder:8776/v2/%(tenant_id)s",
    admin_url    => "http://cinder:8776/v2/%(tenant_id)s",
    internal_url => "http://cinder:8776/v2/%(tenant_id)s",
    service_name => 'OpenStack Volume Service',
    tag          => $region,
  }

 cubbystack::functions::create_keystone_endpoint { "${region}/volumev3":
    public_url   => "http://cinder:8776/v3/%(tenant_id)s",
    admin_url    => "http://cinder:8776/v3/%(tenant_id)s",
    internal_url => "http://cinder:8776/v3/%(tenant_id)s",
    service_name => 'cinderv3',
    tag          => $region,
  }

 cubbystack::functions::create_keystone_endpoint { "${region}/orchestration":
    public_url   => "http://heat:8004/v1/%(tenant_id)s",
    admin_url    => "http://heat:8004/v1/%(tenant_id)s",
    internal_url => "http://heat:8004/v1/%(tenant_id)s",
    service_name => 'OpenStack Orchestration Service',
    tag          => $region,
  }

 cubbystack::functions::create_keystone_endpoint { "${region}/cloudformation":
    public_url   => "http://heat:8000/v1",
    admin_url    => "http://heat:8000/v1",
    internal_url => "http://heat:8000/v1",
    service_name => 'OpenStack CloudFormation Service',
    tag          => $region,
  }

 cubbystack::functions::create_keystone_endpoint { "${region}/messaging":
    public_url   => "http://zaqar:8888",
    admin_url    => "http://zaqar:8888",
    internal_url => "http://zaqar:8888",
    service_name => 'OpenStack Messaging Service',
    tag          => $region,
  }

 cubbystack::functions::create_keystone_endpoint { "${region}/container":
    public_url   => "http://zun:9517/v1",
    admin_url    => "http://zun:9517/v1",
    internal_url => "http://zun:9517/v1",
    service_name => 'OpenStack Container Service',
    tag          => $region,
  }

 cubbystack::functions::create_keystone_endpoint { "${region}/object-store":
    public_url   => "http://swift:8080/v1/AUTH_%(tenant_id)s",
    admin_url    => "http://swift:8080/v1/AUTH_%(tenant_id)s",
    internal_url => "http://swift:8080/v1/AUTH_%(tenant_id)s",
    service_name => 'OpenStack Object Service',
    tag          => $region,
  }

 cubbystack::functions::create_keystone_endpoint { "${region}/metric":
    public_url   => "http://gnocchi:8041",
    admin_url    => "http://gnocchi:8041",
    internal_url => "http://gnocchi:8041",
    service_name => 'Metric Service',
    tag          => $region,
  }

 cubbystack::functions::create_keystone_endpoint { "${region}/key-manager":
    public_url   => "http://barbican:9311",
    admin_url    => "http://barbican:9311",
    internal_url => "http://barbican:9311",
    service_name => 'Key Manager',
    tag          => $region,
  }

 cubbystack::functions::create_keystone_endpoint { "${region}/clustering":
    public_url   => "http://senlin:8778",
    admin_url    => "http://senlin:8778",
    internal_url => "http://senlin:8778",
    service_name => 'Senlin Clustering Service V1',
    tag          => $region,
  }

 cubbystack::functions::create_keystone_endpoint { "${region}/container-infra":
    public_url   => "http://magnum:9511/v1",
    admin_url    => "http://magnum:9511/v1",
    internal_url => "http://magnum:9511/v1",
    service_name => 'OpenStack Container Infrastructure Management Service',
    tag          => $region,
  }

  # Projects
  cubbystack::functions::create_keystone_project { 'default/services': }
  cubbystack::functions::create_keystone_project { 'default/demo': }

  # Roles
  cubbystack::functions::create_keystone_role { '_member_': }
  cubbystack::functions::create_keystone_role { 'heat_stack_user': }
  cubbystack::functions::create_keystone_role { 'creator': }

  # Users
  cubbystack::functions::create_keystone_user { 'demo/demo':
    password => $demo_password,
  }

  cubbystack::functions::create_keystone_user { 'services/glance':
    password => $glance_password,
  }

  cubbystack::functions::create_keystone_user { 'services/neutron':
    password => $neutron_password,
  }

  cubbystack::functions::create_keystone_user { 'services/nova':
    password => $nova_password,
  }

  cubbystack::functions::create_keystone_user { 'services/cinder':
    password => $cinder_password,
  }

  cubbystack::functions::create_keystone_user { 'services/heat':
    password => $heat_password,
  }

  cubbystack::functions::create_keystone_user { 'services/zaqar':
    password => $zaqar_password,
  }

  cubbystack::functions::create_keystone_user { 'services/zun':
    password => $zun_password,
  }

  cubbystack::functions::create_keystone_user { 'services/kuryr':
    password => $kuryr_password,
  }

  cubbystack::functions::create_keystone_user { 'services/swift':
    password => $swift_password,
  }

  cubbystack::functions::create_keystone_user { 'services/gnocchi':
    password => $gnocchi_password,
  }

  cubbystack::functions::create_keystone_user { 'services/barbican':
    password => $barbican_password,
  }

  cubbystack::functions::create_keystone_user { 'services/senlin':
    password => $senlin_password,
  }

  cubbystack::functions::create_keystone_user { 'services/magnum':
    password => $magnum_password,
  }

  # Assignments
  cubbystack::functions::create_keystone_role_assignment { 'demo/demo/_member_': }
  cubbystack::functions::create_keystone_role_assignment { 'demo/demo/creator': }
  cubbystack::functions::create_keystone_role_assignment { 'services/glance/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/neutron/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/nova/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/cinder/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/heat/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/zaqar/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/zun/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/kuryr/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/swift/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/gnocchi/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/barbican/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/barbican/creator': }
  cubbystack::functions::create_keystone_role_assignment { 'services/senlin/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/magnum/admin': }
  cubbystack::functions::create_keystone_role_assignment { 'services/magnum/creator': }

  # heat
  cubbystack::functions::create_keystone_domain { 'heat': }

  $heat_domain_admin = "openstack user create --domain heat --password \"${heat_password}\" heat_domain_admin"
  $heat_domain_admin_unless = "openstack user show --domain heat heat_domain_admin"

  exec { "heat_domain_admin":
    path    => ['/usr/bin'],
    command => "/bin/bash -c 'source /root/openrc && ${heat_domain_admin}'",
    unless  => "/bin/bash -c 'source /root/openrc && ${heat_domain_admin_unless}'",
  }

  $heat_domain_admin_role = "openstack role add --domain heat --user-domain heat --user heat_domain_admin admin"
  $heat_domain_admin_role_unless = "openstack role assignment list --names --domain heat --user heat_domain_admin --role admin | grep -q heat_domain_admin"

  exec { "heat_domain_admin role":
    path    => ['/bin', '/usr/bin'],
    command => "/bin/bash -c 'source /root/openrc && ${heat_domain_admin_role}'",
    unless  => "/bin/bash -c 'source /root/openrc && ${heat_domain_admin_role_unless}'",
  }

  # magnum
  cubbystack::functions::create_keystone_domain { 'magnum': }

  $magnum_domain_admin = "openstack user create --domain magnum --password \"${magnum_password}\" magnum_domain_admin"
  $magnum_domain_admin_unless = "openstack user show --domain magnum magnum_domain_admin"

  exec { "magnum_domain_admin":
    path    => ['/usr/bin'],
    command => "/bin/bash -c 'source /root/openrc && ${magnum_domain_admin}'",
    unless  => "/bin/bash -c 'source /root/openrc && ${magnum_domain_admin_unless}'",
  }

  $magnum_domain_admin_role = "openstack role add --domain magnum --user-domain magnum --user magnum_domain_admin admin"
  $magnum_domain_admin_role_unless = "openstack role assignment list --names --domain magnum --user magnum_domain_admin --role admin | grep -q magnum_domain_admin"

  exec { "magnum_domain_admin role":
    path    => ['/bin', '/usr/bin'],
    command => "/bin/bash -c 'source /root/openrc && ${magnum_domain_admin_role}'",
    unless  => "/bin/bash -c 'source /root/openrc && ${magnum_domain_admin_role_unless}'",
  }
}
