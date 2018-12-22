#!/system/bin/sh

awk 2>&1
AWKCOMMEXIST=$?

if [ "$AWKCOMMEXIST" != 127 ]; then
	clear
	echo -ne "\033[1k\033[1k\r"

	# Check configuration files.

	cat ./batt_info_refresh > /dev/null 2>&1
	INFOREFILEEXIST=$?

	cat ./batt_config > /dev/null 2>&1
	CONFIGEXIST=$?

	# Create configuration files.

	if [ "$CONFIGEXIST" != 0 ]; then
		echo -n > ./batt_config
		CONFIGEXISTT="Configuration does not exist, create it."
	else
		CONFIGEXISTT="Configuration exists."
	fi

	if [ "$INFOREFILEEXIST" != 0 ]; then
		echo "0.2" > ./batt_info_refresh
		INFOREFRESH=0.2
		INFOREFILEEXISTT="Information refresh file not exist, create a file."
	else
		INFOREFRESH=`cat ./batt_info_refresh`
		INFOREFILEEXISTT="Information refresh file exist."
	fi

	# Setting variables.

	SYSPOWPATH=/sys/class/power_supply
	BATTPATH=/battery
	BMSPATH=/bms
	UNKNOWN=/unknown
	TEMPOF=/temp
	TEMPNOWOF=/batt_temp_now
	STATUSOF=/status
	CHARGTYPEOF=/charge_type
	CURRENTNOWOF=/current_now
	VOLTAGENOWOF=/voltage_now
	CAPACITYRAWOF=/capacity_raw
	
	EFFT=`echo -ne "\033[32mEFF\033[39m"`
	NULT=`echo -ne "\033[31mNUL\033[39m"`

	NULL=null
	EXCEP=exception

	# Check if the directory exists.

	ls $SYSPOWPATH$BATTPATH > /dev/null 2>&1
	BATTPATHEXIST=$?
	ls $SYSPOWPATH$BMSPATH > /dev/null 2>&1
	BMSPATHEXIST=$?

	if [ "$BATTPATHEXIST" == 0 ]; then
		BATTERYPATH=$BATTPATH
	elif [ "$BMSPATHEXIST" == 0 ]; then
		BATTERYPATH=$BMSPATH
	else
		BATTERYPATH=$UNKNOWN
	fi

	ls $SYSPOWPATH$BATTERYPATH > /dev/null 2>&1
	BATTERYPATHEXIST=$?

	# Check if the battery information file exists.

	cat $SYSPOWPATH$BATTERYPATH$TEMPOF > /dev/null 2>&1
	TEMPOFEXIST=$?
	cat $SYSPOWPATH$BATTERYPATH$TEMPNOWOF > /dev/null 2>&1
	TEMPNOWOFEXIST=$?
	cat $SYSPOWPATH$BATTERYPATH$STATUSOF > /dev/null 2>&1
	STATUSOFEXIST=$?
	cat $SYSPOWPATH$BATTERYPATH$CHARGTYPEOF > /dev/null 2>&1
	CHARGETYPEOFEXIST=$?
	cat $SYSPOWPATH$BATTERYPATH$CURRENTNOWOF > /dev/null 2>&1
	CURRENTNOWOFEXIST=$?
	cat $SYSPOWPATH$BATTERYPATH$VOLTAGENOWOF > /dev/null 2>&1
	VOLTAGENOWOFEXIST=$?
	cat $SYSPOWPATH$BATTERYPATH$CAPACITYRAWOF > /dev/null 2>&1
	CAPACITYRAWOFEXIST=$?

	# Check the configuration.

	grep 'TEMPFILE=' ./batt_config > /dev/null 2>&1
	TEMPVALEXIST=$?
	grep 'STATUSFILE=' ./batt_config > /dev/null 2>&1
	STATUSVALEXIST=$?
	grep 'CHARGETYPEFILE=' ./batt_config > /dev/null 2>&1
	CHARGETYPEVALEXIST=$?
	grep 'CURRENTFILE=' ./batt_config > /dev/null 2>&1
	CURRENTVALEXIST=$?
	grep 'VOLTAGEFILE=' ./batt_config > /dev/null 2>&1
	VOLTAGEVALEXIST=$?
	grep 'CAPACITYFILE=' ./batt_config > /dev/null 2>&1
	CAPACITYVALEXIST=$?
	grep 'DEBUGMODE=' ./batt_config > /dev/null 2>&1
	DEBUGVALEXIST=$?
	grep 'CURRENTFORMAT=' ./batt_config > /dev/null 2>&1
	CURRENTFORMATVALEXIST=$?

	# Set the configuration.

	if [ "$TEMPVALEXIST" != 0 ]; then
		if [ "$TEMPOFEXIST" == 0 ]; then
			echo "TEMPFILE=$TEMPOF" >> ./batt_config
		elif [ "$TEMPNOWOFEXIST" == 0 ]; then
			echo "TEMPFILE=$TEMPNOWOF" >> ./batt_config
		else
			echo "TEMPFILE=$UNKNOWN" >> ./batt_config
		fi
	fi

	if [ "$STATUSVALEXIST" != 0 ]; then
		if [ "$STATUSOFEXIST" == 0 ]; then
			echo "STATUSFILE=$STATUSOF" >> ./batt_config
		else
			echo "STATUSFILE=$UNKNOWN" >> ./batt_config
		fi
	fi

	if [ "$CHARGETYPEVALEXIST" != 0 ]; then
		if [ "$CHARGETYPEOFEXIST" == 0 ]; then
			echo "CHARGETYPEFILE=$CHARGTYPEOF" >> ./batt_config
		else
			echo "CHARGETYPEFILE=$UNKNOWN" >> ./batt_config
		fi
	fi

	if [ "$CURRENTVALEXIST" != 0 ]; then
		if [ "$CURRENTNOWOFEXIST" == 0 ]; then
			echo "CURRENTFILE=$CURRENTNOWOF" >> ./batt_config
		else
			echo "CURRENTFILE=$UNKNOWN" >> ./batt_config
		fi
	fi

	if [ "$VOLTAGEVALEXIST" != 0 ]; then
		if [ "$VOLTAGENOWOFEXIST" == 0 ]; then
			echo "VOLTAGEFILE=$VOLTAGENOWOF" >> ./batt_config
		else
			echo "VOLTAGEFILE=$UNKNOWN" >> ./batt_config
		fi
	fi

	if [ "$CAPACITYVALEXIST" != 0 ]; then
		if [ "$CAPACITYRAWOFEXIST" == 0 ]; then
			echo "CAPACITYFILE=$CAPACITYRAWOF" >> ./batt_config
		else
			echo "CAPACITYFILE=$UNKNOWN" >> ./batt_config
		fi
	fi

	# Read the configuration.

	TEMPVAL=`grep 'TEMPFILE=' ./batt_config | awk 'BEGIN {FS="="}''{print $2}'`
	STATUSVAL=`grep 'STATUSFILE=' ./batt_config | awk 'BEGIN {FS="="}''{print $2}'`
	CHARGETYPEVAL=`grep 'CHARGETYPEFILE=' ./batt_config | awk 'BEGIN {FS="="}''{print $2}'`
	CURRENTVAL=`grep 'CURRENTFILE=' ./batt_config | awk 'BEGIN {FS="="}''{print $2}'`
	VOLTAGEVAL=`grep 'VOLTAGEFILE=' ./batt_config | awk 'BEGIN {FS="="}''{print $2}'`
	CAPACITYVAL=`grep 'CAPACITYFILE=' ./batt_config | awk 'BEGIN {FS="="}''{print $2}'`
	DEBUGVAL=`grep 'DEBUGMODE=' ./batt_config | awk 'BEGIN {FS="="}''{print $2}'`

	cat $SYSPOWPATH$BATTERYPATH$TEMPVAL > /dev/null 2>&1
	TEMPVALEFF=$?
	cat $SYSPOWPATH$BATTERYPATH$STATUSVAL > /dev/null 2>&1
	STATUSVALEFF=$?
	cat $SYSPOWPATH$BATTERYPATH$CHARGETYPEVAL > /dev/null 2>&1
	CHARGETYPEVALEFF=$?
	cat $SYSPOWPATH$BATTERYPATH$CURRENTVAL > /dev/null 2>&1
	CURRENTVALEFF=$?
	cat $SYSPOWPATH$BATTERYPATH$VOLTAGEVAL > /dev/null 2>&1
	VOLTAGEVALEFF=$?
	cat $SYSPOWPATH$BATTERYPATH$CAPACITYVAL > /dev/null 2>&1
	CAPACITYVALEFF=$?

	if [ "$CURRENTFORMATVALEXIST" != 0 ]; then
		BATTSTATUS=`cat $SYSPOWPATH$BATTERYPATH$STATUSVAL`
		BATTCURRENT=`cat $SYSPOWPATH$BATTERYPATH$CURRENTVAL`
		if [ "$BATTSTATUS" == Charging ]; then
			echo "Please stop charging to determine the current supply method."
			until [ "$BATTSTATUS" == Discharging ]
			do
				BATTSTATUS=`cat $SYSPOWPATH$BATTERYPATH$STATUSVAL`
				sleep $INFOREFRESH
			done
			sleep 1.5
			BATTCURRENT=`cat $SYSPOWPATH$BATTERYPATH$CURRENTVAL`
		fi
		if [ "$BATTCURRENT" -ge 0 ]; then
			echo "CURRENTFORMAT=REVERSEMUA" >> ./batt_config
		elif [ "$BATTCURRENT" -le 0 ]; then
			echo "CURRENTFORMAT=MUA" >> ./batt_config
		else
			echo "CURRENTFORMAT=NULL" >> ./batt_config
		fi
	fi

	CURRENTFORMATVAL=`grep 'CURRENTFORMAT=' ./batt_config | awk 'BEGIN {FS="="}''{print $2}'`

	if [ $TEMPVALEFF == 0 ]; then
		TEMPVALEFFT=$EFFT
	else
		TEMPVALEFFT=$NULT
	fi
	
	if [ $STATUSVALEFF == 0 ]; then
		STATUSVALEFFT=$EFFT
	else
		STATUSVALEFFT=$NULT
	fi
	
	if [ $CHARGETYPEVALEFF == 0 ]; then
		CHARGETYPEVALEFFT=$EFFT
	else
		CHARGETYPEVALEFFT=$NULT
	fi
	
	if [ $CURRENTVALEFF == 0 ]; then
		CURRENTVALEFFT=$EFFT
	else
		CURRENTVALEFFT=$NULT
	fi
	
	if [ $VOLTAGEVALEFF == 0 ]; then
		VOLTAGEVALEFFT=$EFFT
	else
		VOLTAGEVALEFFT=$NULT
	fi
	
	if [ $CAPACITYVALEFF == 0 ]; then
		CAPACITYVALEFFT=$EFFT
	else
		CAPACITYVALEFFT=$NULT
	fi
	
	clear
	echo -ne "\033[1k\033[1k\r"
	
	# Debug information printing.

	if [ "$DEBUGVALEXIST" == 0 ]; then
		if [ "$DEBUGVAL" == "ON" ]; then
			echo "debug info: ""refresh rate "$INFOREFRESH" s, "$INFOREFILEEXISTT
			echo $CONFIGEXISTT
			echo TMP: $TEMPVALEFFT", "STAT: $STATUSVALEFFT", "CHGTYP: $CHARGETYPEVALEFFT", "CUR: $CURRENTVALEFFT", "V: $VOLTAGEVALEFFT", "CAP: $CAPACITYVALEFFT
		fi
	fi

	# Battery information printing.

	if [ "$BATTERYPATHEXIST" == 0 ]; then

		echo "Battery status: "

		while :
		do
			if [ "$TEMPVALEFF" == 0 ]; then
				BATTTEMP=`cat $SYSPOWPATH$BATTERYPATH$TEMPVAL`
				expr "$BATTTEMP" + 1 > /dev/null 2>&1
				BATTTEMPNONEXCEP=$?
				if [ $BATTTEMPNONEXCEP == 0 ]; then
					BATTTEMPC=$(($BATTTEMP/10))
				else
					BATTTEMPC=$EXCEP
				fi
			else
				BATTTEMPC=$NULL
			fi


			if [ "$STATUSVALEFF" == 0 ]; then
				BATTSTATUS=`cat $SYSPOWPATH$BATTERYPATH$STATUSVAL`
				if [ -z "$BATTSTATUS" ];then
					BATTSTATUS=$EXCEP
				fi
			else
				BATTSTATUS=$NULL
			fi


			if [ "$CHARGETYPEVALEFF" == 0 ]; then
				BATTCHARGETYPE=`cat $SYSPOWPATH$BATTERYPATH$CHARGETYPEVAL`
				if [ -z "$BATTCHARGETYPE" ];then
					BATTCHARGETYPE=$EXCEP
				fi
			else
				BATTCHARGETYPE=$NULL
			fi


			if [ "$CURRENTVALEFF" == 0 ]; then
				BATTCURRENT=`cat $SYSPOWPATH$BATTERYPATH$CURRENTVAL`
				expr "$BATTCURRENT" + 1 > /dev/null 2>&1
				BATTCURRENTNONEXCEP=$?
			else
				BATTCURRENT=$NULL
			fi


			if [ -n "$CURRENTFORMATVAL" ] && [ "$BATTCURRENT" != "$NULL" ]; then
				if [ $BATTCURRENTNONEXCEP == 0 ]; then
					if [ "$CURRENTFORMATVAL" == "REVERSEMUA" ]; then
						BATTCURRENTMA=$((-($BATTCURRENT/1000)))
					elif [ "$CURRENTFORMATVAL" == "MUA" ]; then
						BATTCURRENTMA=$(($BATTCURRENT/1000))
					elif [ "$CURRENTFORMATVAL" == "REVERSEMA" ]; then
						BATTCURRENTMA=$((-($BATTCURRENT)))
					elif [ "$CURRENTFORMATVAL" == "MA" ]; then
						BATTCURRENTMA=$BATTCURRENT
					else
						BATTCURRENTMA=$BATTCURRENT
					fi
				else
					BATTCURRENTMA=$EXCEP
				fi
			else
				BATTCURRENTMA=$BATTCURRENT
			fi



			if [ "$VOLTAGEVALEFF" == 0 ]; then
				BATTVOLTAGE=`cat $SYSPOWPATH$BATTERYPATH$VOLTAGEVAL` 
				expr "$BATTVOLTAGE" + 1 > /dev/null 2>&1
				BATTVOLTAGENONEXCEP=$?
				if [ $BATTVOLTAGENONEXCEP == 0 ]; then
					BATTVOLTAGEMV=$(($BATTVOLTAGE/1000))
				else
					BATTVOLTAGEMV=$EXCEP
				fi
			else
				BATTVOLTAGEMV=$NULL
			fi


			if [ "$CAPACITYVALEFF" == 0 ]; then
				BATTCAPACITY=`cat $SYSPOWPATH$BATTERYPATH$CAPACITYVAL`
				expr "$BATTCAPACITY" + 1 > /dev/null 2>&1
				BATTCAPACITYNONEXCEP=$?
				if [ $BATTCAPACITYNONEXCEP != 0 ];then
					BATTCAPACITY=$EXCEP
				fi
			else
				BATTCAPACITY=$NULL
			fi



			if [ "$BATTTEMPC" == $NULL ] || [ "$BATTTEMPC" == $EXCEP ]; then
				BATTTEMPCC=`echo -ne "\033[31m$BATTTEMPC C°\033[39m"`
			elif [ "$BATTTEMPC" -ge 45 ]; then
				BATTTEMPCC=`echo -ne "\033[31m$BATTTEMPC C°\033[39m"`
			elif [ "$BATTTEMPC" -le 44 ]; then
				BATTTEMPCC=`echo -ne "\033[32m$BATTTEMPC C°\033[39m"`
			else
				BATTTEMPCC=`echo -n "$BATTTEMPC C°"`
			fi


			if [ "$BATTSTATUS" == $NULL ] || [ "$BATTSTATUS" == $EXCEP ]; then
				BATTCURRENTMAC=`echo -ne "\033[31m$BATTCURRENTMA"" mA""\033[39m"`
			elif [ "$BATTSTATUS" == "Full" ]; then
				BATTCURRENTMAC=`echo -ne "\033[36m$BATTCURRENTMA"" mA""\033[39m"`
			elif [ "$BATTSTATUS" == "Charging" ]; then
				BATTCURRENTMAC=`echo -ne "\033[32m$BATTCURRENTMA"" mA""\033[39m"`
			elif [ "$BATTSTATUS" == "Discharging" ]; then
				BATTCURRENTMAC=`echo -ne "\033[31m$BATTCURRENTMA"" mA""\033[39m"`
			else
				BATTCURRENTMAC=`echo -n $BATTCURRENTMA" mA"`
			fi


			if [ "$BATTCAPACITY" == $NULL ] || [ "$BATTCAPACITY" == $EXCEP ]; then
				BATTCAPACITYC=`echo -ne "\033[31m$BATTCAPACITY""%""\033[39m"`
			elif [ "$BATTCAPACITY" -le "30" ] && [ "$BATTCAPACITY" -ge "16" ]; then
				BATTCAPACITYC=`echo -ne "\033[33m$BATTCAPACITY""%""\033[39m"`
			elif [ "$BATTCAPACITY" -le "15" ]; then
				BATTCAPACITYC=`echo -ne "\033[31m$BATTCAPACITY""%""\033[39m"`
			elif [ "$BATTCAPACITY" -ge "80" ] && [ "$BATTCAPACITY" -ge "89" ]; then
				BATTCAPACITYC=`echo -ne "\033[32m$BATTCAPACITY""%""\033[39m"`
			elif [ "$BATTCAPACITY" -ge "90" ]; then
				BATTCAPACITYC=`echo -ne "\033[36m$BATTCAPACITY""%""\033[39m"`
			else
				BATTCAPACITYC=`echo -ne "\033[34m$BATTCAPACITY""%""\033[39m"`
			fi


			if [ "$BATTVOLTAGEMV" == $NULL ] || [ "$BATTVOLTAGEMV" == $EXCEP ]; then
				BATTVOLTAGEMVC=`echo -ne "\033[31m$BATTVOLTAGEMV"" mV""\033[39m"`
			elif [ "$BATTVOLTAGEMV" -le "3599" ]; then
				BATTVOLTAGEMVC=`echo -ne "\033[31m$BATTVOLTAGEMV"" mV""\033[39m"`
			elif [ "$BATTVOLTAGEMV" -ge "3600" ] && [ "$BATTVOLTAGEMV" -le "3749" ]; then
				BATTVOLTAGEMVC=`echo -ne "\033[33m$BATTVOLTAGEMV"" mV""\033[39m"`
			elif [ "$BATTVOLTAGEMV" -ge "3750" ] && [ "$BATTVOLTAGEMV" -le "4199" ]; then
				BATTVOLTAGEMVC=`echo -ne "\033[32m$BATTVOLTAGEMV"" mV""\033[39m"`
			elif [ "$BATTVOLTAGEMV" -ge "4200" ] ; then
				BATTVOLTAGEMVC=`echo -ne "\033[36m$BATTVOLTAGEMV"" mV""\033[39m"`
			else
				BATTVOLTAGEMVC=`echo -n "$BATTVOLTAGEMV"" mV"`
			fi


			echo -ne "\033[25l\033[1k\033[1k\r"$BATTCAPACITYC" | "$BATTVOLTAGEMVC" | "$BATTCURRENTMAC" | "$BATTTEMPCC"  "
			sleep $INFOREFRESH
		done

	else
		echo "Error, No permissions or directory does not exist."
	fi
else
	clear
	echo -ne "\033[1k\033[1k\r"
	echo "Error, the following instruction set is missing: awk, please execute through termux or install busybox on the system (need to be installed by root user)."
fi
