require 'facter'

Facter.add('carbon_c_relay_rpm_version') do
  setcode do
    version = Facter::Util::Resolution.exec('/bin/rpm -q --queryformat "%{VERSION}" carbon-c-relay')
    if version
      version.match(/^\d+.*$/).to_s
    else
      nil
    end
  end
end
