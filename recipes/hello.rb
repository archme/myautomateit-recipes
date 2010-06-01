if tagged?("archlinux")
  puts "Hello, I'm an Archlinux"
  package_manager.install("xterm")
  service_manager.start("mysqld")
  #service_manager.restart("mysqld")
  service_manager.enable("mysqld")
  #service_manager.disable("mysqld")
else
  puts "I'm not supported"
end
