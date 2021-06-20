#!/bin/bash



# set variables
output=$HOME/system_info.txt

ip=$(ip addr | grep inet | tail -2 | head -1)

disk=$(df -H | head -2)

cpu=$(lscpu | grep CPU)


# set lists
commands=(
  'date'
  'uname -a'
  'hostname -s'
)

#
# Beginning of the Script

echo "System Audit Script" >> $output
echo "" >> $output

for x in {0..2} ;
do
  results=$(${commands[$x]})
  echo "Results of "${commands[$x]}" command:" >> $output
  echo $results >> $output
  echo "" >> $output
done

# Machine Type
echo "Machine Type Info:" >> $output
echo -e "$MACHTYPE \n" >> $output

# IP Address
echo -e "IP Info:" >> $output
echo -e "$ip \n" >> $output

# Memory usage
echo -e "\nMemory Info:" >> $output
free >> $output

# CPU usage
echo -e "\nCPU Info:" >> $output
lscpu | grep CPU >> $output

# Display Disk usage
echo -e "\nDisk Usage:" >> $output
df -H | head -2 >> $output

#Display how is logged in
echo -e "\nWho is logged in: \n $(who -a) \n" >> $output
#echo -e "\nSUID Files:" >> $output

# Display DNS
echo "DNS Servers: " >> $output
cat /etc/resolv.conf >> $output


# List top 10 processes
echo -e "\nTop 10 Processes" >> $output
ps aux --sort -%mem | awk {'print $1, $2, $3, $4, $11'} | head >> $output


