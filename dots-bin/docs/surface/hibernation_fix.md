# Debian 13 Hibernation Fix on Surface Devices

## Problem
Hibernation only worked when closing the laptop lid but failed on idle timeout, displaying an "authentication required" polkit dialog. Manual hibernation also caused kernel panics.

## Root Causes
1. **i915 GPU driver power management** incompatible with hibernation on Surface devices
2. **Polkit authorization** blocking idle hibernation triggers

## Solution

### 1. Fix i915 Kernel Panic

Edit GRUB configuration:
```bash
sudo nano /etc/default/grub
```

Add `i915.enable_dc=0` to the `GRUB_CMDLINE_LINUX_DEFAULT` line. Example:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=UUID=b3d46aa5-a71c-45cb-86a9-472118f9aa62 i915.enable_dc=0"
```

Update GRUB and reboot:
```bash
sudo update-grub
sudo reboot
```

### 2. Configure Idle Timeout Hibernation

Edit logind configuration:
```bash
sudo nano /etc/systemd/logind.conf
```

Uncomment or add these lines:
```
IdleAction=hibernate
IdleActionSec=600
```

(600 seconds = 10 minutes; adjust as needed)

Restart systemd-logind:
```bash
sudo systemctl restart systemd-logind
```

### 3. Fix Polkit Authorization

Create a polkit policy file using the `.pkla` format:
```bash
sudo mkdir -p /etc/polkit-1/localauthority/50-local.d
sudo bash -c 'cat > /etc/polkit-1/localauthority/50-local.d/hibernate.pkla << "EOF"
[Allow Hibernate]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate
ResultActive=yes
ResultInactive=yes
EOF'
```

Restart polkit:
```bash
sudo systemctl restart polkit
```

## Verification

Test manual hibernation:
```bash
sudo systemctl hibernate
```

Test idle timeout hibernation by leaving the laptop idle with the lid open for the configured duration (default 10 minutes) and monitor:
```bash
sudo journalctl -u systemd-logind -f
```

You should see: `The system will hibernate now!`

## Notes

- The `i915.enable_dc=0` parameter disables Intel GPU display power management, which was causing kernel panics during hibernation on this Surface device
- The `.pkla` format is more reliable than `.rules` files for this particular authorization scenario
- Ensure your swap space is at least equal to your RAM size for hibernation to work properly
- Check with `free -h` and `sudo cat /sys/power/image_size` if hibernation fails
