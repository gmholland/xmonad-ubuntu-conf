#!/bin/bash

acpi_output_raw=`/usr/bin/acpi`
acpi_output_subs=${acpi_output_raw//,/}

IFS=' ' read -r -a acpi_output <<< "$acpi_output_subs"

declare -A status_symbols=( \
	[Unknown]=↔ \
	[Full]=↔ \
	[Charging]=↑ \
	[Discharging]=↓)

output_percentage=${acpi_output[3]}
level=${output_percentage/\%/}

if [[ level -ge 0 && level -lt 10 ]]; then
	battery_level="<fc=#dc322f>${output_percentage}</fc>"
elif [[ level -ge 10 && level -lt 20 ]]; then
	battery_level="<fc=#b58900>${output_percentage}</fc>"
else
	battery_level="<fc=#859900>${output_percentage}</fc>"
fi

time_raw=${acpi_output[4]}
if [[ $time_raw} ]]; then
	IFS=':' read -r -a time_orig <<< "$time_raw"
	time="(${time_orig[0]}:${time_orig[1]})"
else
	time="(F)"
fi

status=${acpi_output[2]}
symbol=${status_symbols[$status]}

echo "Bat: ${battery_level} ${symbol} ${time}"

