# == PlatformManager::Archlinux
#
# A PlatformManager driver for ArchLinux.
class AutomateIt::PlatformManager::Archlinux < ::AutomateIt::PlatformManager::Uname
  VERSION_FILE = "/etc/arch-release"

  depends_on :files => [VERSION_FILE]

  def suitability(method, *args) # :nodoc:
    # Must be higher than PlatformManager::Struct
    return available? ? 3 : 0
  end

  def _prepare
    return if @struct[:distro]
    @struct[:distro] = "archlinux"
    @struct[:release] = "rolling"
    @struct
  end
  private :_prepare

  def query(search)
    _prepare
    super(search)
  end
end
