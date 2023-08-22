./output  < $1 $2
exist=`which firefox`
if [ ! -z "$exist" ]
then firefox $2
fi