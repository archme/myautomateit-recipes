# == PackageManager::PACMAN
#
# The PACMAN driver for the PackageManager provides a way to manage software
# packages on ArchLinux-style systems using +pacman+.
class AutomateIt::PackageManager::PACMAN < ::AutomateIt::PackageManager::BaseDriver
  depends_on :programs => %w(pacman)

  def suitability(method, *args) # :nodoc:
    return available? ? 1 : 0
  end

  # See AutomateIt::PackageManager#installed?
  def installed?(*packages)
    return _installed_helper?(*packages) do |list, opts|
      cmd = 'pacman -Q'
      list.each{|package| cmd << " "+package}
      cmd << " 2>&1"
      cmd << " > /dev/null" if opts[:quiet]

      log.debug(PEXEC+cmd)
      data = `#{cmd}`
      matches = data.scan(/^(.+) .+$/)
      available = matches.inject([]) do |sum, match|
        package, status = match
        sum << package
        sum
      end
      available
    end
  end

  # See AutomateIt::PackageManager#not_installed?
  def not_installed?(*packages)
    _not_installed_helper?(*packages)
  end

  # See AutomateIt::PackageManager#install
  def install(*packages)
    return _install_helper(*packages) do |list, opts|
      cmd = "pacman --needed --noconfirm --noprogressbar -S "+list.join(" ")
      cmd << " 2>&1"
      cmd << " > /dev/null" if opts[:quiet]

      interpreter.sh(cmd)
    end
  end

  # See AutomateIt::PackageManager#uninstall
  def uninstall(*packages)
    return _uninstall_helper(*packages) do |list, opts|
      cmd = "pacman --noconfirm --noprogressbar -R "+list.join(" ")
      cmd << " 2>&1"
      cmd << " > /dev/null" if opts[:quiet]

      interpreter.sh(cmd)
    end
  end
end
