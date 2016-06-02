# Class packer
# ===========================
#
# Installs a specified version of packer
#
# Parameters
# ----------
#
# * `version`
# Optional. The version of go to install. Defaults to 0.8.6
#
# Examples
# --------
#
# @example
#   class { '::packer':
#     version => '0.8.5',
#   }
#
class packer ( $version = '0.8.6' ) {

  $url = "https://releases.hashicorp.com/packer/${version}/packer_${version}_linux_amd64.zip"

  exec { 'packer-download':
    user    => root,
    command => "wget -O /usr/local/packer_${version}_linux_amd64.zip ${url}",
    creates => "/usr/local/packer_${version}_linux_amd64.zip",
  }

  exec { 'packer-extract':
    user    => 'root',
    command => "unzip -d /usr/local/packer-${version} /usr/local/packer_${version}_linux_amd64.zip",
    require => Exec['packer-download'],
    creates => "/usr/local/packer-${version}",
  }

  file { '/usr/local/packer':
    ensure => link,
    target => "/usr/local/packer-${version}",
  }

  file { '/etc/profile.d/packer.sh':
    ensure  => present,
    mode    => '0644',
    content => 'export PATH=/usr/local/packer:$PATH',
  }
}
