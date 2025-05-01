#!/bin/bash

echo "🧠 Development Optimization Script for Ubuntu/Debian"
echo "🔧 Making your system leaner, faster, and more dev-focused."

# --- Step 1: Services to Disable or Remove ---
services_to_disable=(
  bluetooth.service
  cups.service
  avahi-daemon.service
  snapd.service
  ModemManager.service
)

echo ""
echo "🚫 Services to be disabled (if found):"
for service in "${services_to_disable[@]}"; do
  echo " - $service"
done

# Show current memory/CPU usage by those services
echo ""
echo "📊 Checking current memory/CPU usage:"
for service in "${services_to_disable[@]}"; do
  pid=$(pidof $(basename "$service" .service))
  if [ -n "$pid" ]; then
    ps -p $pid -o pid,%mem,%cpu,cmd
  else
    echo "$service: Not running"
  fi
done

read -p "Do you want to proceed disabling these services? (y/n): " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  for service in "${services_to_disable[@]}"; do
    if systemctl list-unit-files | grep -q "^$service"; then
      sudo systemctl disable --now "$service" && echo "✅ Disabled $service"
    else
      echo "⚠️ $service not found or already disabled"
    fi
  done

  # Optional: purge Snap completely
  echo ""
  read -p "Do you want to completely remove Snap (recommended for lean systems)? (y/n): " snapremove
  if [[ $snapremove =~ ^[Yy]$ ]]; then
    sudo apt purge snapd -y && echo "🧹 Snap removed!"
  fi
else
  echo "❌ Skipped service disabling."
fi

# --- Step 2: Autostart App Cleanup ---
autostart_dir="$HOME/.config/autostart"
echo ""
echo "🗂️ Cleaning user autostart apps..."
if [ -d "$autostart_dir" ]; then
  mkdir -p "$autostart_dir/backup"
  find "$autostart_dir" -name "*.desktop" -exec mv {} "$autostart_dir/backup/" \;
  echo "✅ Moved startup apps to backup."
else
  echo "✅ No autostart entries found."
fi

# --- Step 3: Basic sysctl tuning for dev machines ---
echo ""
echo "🧠 Applying memory performance tweaks..."
sudo tee -a /etc/sysctl.conf > /dev/null <<EOF

# Custom dev system tuning
vm.swappiness=10
vm.vfs_cache_pressure=50
EOF
sudo sysctl -p

# --- Step 4: ZRAM for swap (RAM compression) ---
echo ""
echo "🧬 Enabling ZRAM (compressed RAM swap)..."
sudo apt install zram-tools -y
echo "ALGO=lz4" | sudo tee /etc/default/zramswap
sudo systemctl restart zramswap

# --- Step 5: Boot analysis ---
echo ""
echo "⏱️ Boot Performance Summary:"
systemd-analyze
systemd-analyze blame | head -n 10

# --- Step 6: (Optional) Dev Tool Install ---
echo ""
read -p "Install common developer tools (git, htop, build-essential)? (y/n): " devtools
if [[ $devtools =~ ^[Yy]$ ]]; then
  sudo apt install git build-essential htop curl net-tools wget gnome-system-monitor -y
fi

echo ""
echo "🎯 Optimization complete! Reboot recommended to finalize changes."
