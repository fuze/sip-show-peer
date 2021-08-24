#!/bin/bash

ssp_params () {

    printf "You can enter optional paramters to narrow down your sip show peers results. By default, you will see all results for the $customer pbx if you enter no paramaters...\n\n"
    printf "Enter optional peer name (ex. WKRC-p2434) or extension to grep ssp for $customer. Carriage return otherwise.\n\n"
    read peer

    if [[ -z "$peer" ]]; then
        ssh -x "$USERNAME"@"$call_server" /usr/sbin/sip_show.pl --name "$customer"
    else
        ssh -x "$USERNAME"@"$call_server" /usr/sbin/sip_show.pl --name "$customer" | grep "$peer"
    fi
    
    printf "\n\nEND_OF_RESULTS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~END_OF_RESULTS\n\n"
    printf "Would you like to search again? Enter 'yes' to search again.\n\n"
    read again

    if [[ "$again" == "yes" ]]; then
        ssp_params
    else
        printf "Script has now finished and will exit."
	exit 0
    fi

}


customer="$1"

if [[ "$#" -ne 1 ]]; then
    printf "Usage: $0 [vcx name]"
    exit 1
fi

call_server=$(ssh -x  "$USERNAME"@vap-eng2 tail -n 3 /opt/server-config/trunk/core/etc/asterisk/conf/customers/"$customer"/"$customer"-vars.extensions.conf | head -n 1 | awk -F'=' '{print $2}')

printf "\nPrimary call server of $customer: $call_server\n\n"

ssp_params

