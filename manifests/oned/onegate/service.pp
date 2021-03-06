# == Class one::oned::onegate::service
#
# Installation and Configuration of OpenNebula
# http://opennebula.org/
#
# === Author
# ePost Development GmbH
# (c) 2013
#
# Contributors:
# - Martin Alfke
# - Achim Ledermueller (Netways GmbH)
# - Sebastian Saemann (Netways GmbH)
# - Matthias Schmitz
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::oned::onegate::service {
  service {'opennebula-gate':
    ensure  => running,
    enable  => true,
    require => Service['opennebula'],
  }
}
