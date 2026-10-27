#!/bin/bash
if [ -e "/sys/bus/acpi/drivers/button/PNP0C0D:00" ]; then
    echo "PNP0C0D:00" > /sys/bus/acpi/drivers/button/unbind
fi
