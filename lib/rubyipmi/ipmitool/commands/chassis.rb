module Rubyipmi::Ipmitool

  class Chassis < Rubyipmi::Ipmitool::BaseCommand

    def initialize(opts = ObservableHash.new)
      super("ipmitool", opts)

    end

    # Turn the led light on / off or with a delay
    def identify(status=false, delay=0)
      if status
        if delay <= 0
          options["cmdargs"] = "chassis identify -1"
        else
          options["cmdargs"] = "chassis identify #{delay}"
        end
      else
        options["cmdargs"] = "chassis identify 0"
      end
      # Run the command
      value = runcmd
      options.delete_notify("cmdargs")
      return value
    end

    # Access to the power command created on the fly
    def power
      @power ||= Rubyipmi::Ipmitool::Power.new(@options)
    end

    # Access to the config command created on the fly
    def config
      @config ||= Rubyipmi::Ipmitool::ChassisConfig.new(@options)
    end

    # set boot device from given boot device
    def bootdevice(device, persistent=false, reboot=false)
      if config.bootdevices.include?(device)
        status = config.bootdevice(device, persistent)
        if reboot and status
          power.cycle
        end

      else
        raise "Device with name: #{device} is not a valid boot device for host #{options["hostname"]}"
      end
    end

    # set boot device to pxe with option to reboot
    def bootpxe(reboot=false,persistent=false)
      status = config.bootpxe(persistent)
      # Only reboot if setting the boot flag was successful
      if reboot and status
        power.cycle
      end
    end

    # set boot device to disk with option to reboot
    def bootdisk(reboot=false,persistent=false)
      config.bootdisk(persistent)
      # Only reboot if setting the boot flag was successful
      if reboot and status
        power.cycle
      end

    end

    # set boot device to cdrom with option to reboot
    def bootcdrom(reboot=false,persistent=false)
      config.bootcdrom(persistent)
      # Only reboot if setting the boot flag was successful
      if reboot and status
        power.cycle
      end
    end

    # boot into bios setup with option to reboot
    def bootbios(reboot=false,persistent=false)
      config.bootbios(persistent)
      # Only reboot if setting the boot flag was successful
      if reboot and status
        power.cycle
      end
    end

    def status
       options["cmdargs"] = "chassis status"
       value = runcmd
       options.delete_notify("cmdargs")
       return { :result => @result, :value => value }
    end

    # A currently unsupported method to retrieve the led status
    def identifystatus
      options["cmdargs"] = "chassis identify status"
      value = runcmd
      options.delete_notify("cmdargs")
      if value
        @result.chomp.split(":").last.strip
      end
    end


  end
end