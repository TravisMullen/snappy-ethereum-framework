#!/bin/bash

# snappy-magic-launch - a stub that finds the right multiarch binary and sets all the right
#                       environment variables when launching multiarch snapps
#
# Usage:
#   - copy this stub in the snapp magic-bin/ directory with the name matching the multiarch binary
set -e

verbose=true
platform=`uname -i`
plat_abi=

# map platform to multiarch triplet - manually
case $platform in
  x86_64)
    plat_abi=x86_64-linux-gnu
    ;;
  armv7l)
    plat_abi=arm-linux-gnueabihf
    ;;
  *)
    echo "unknown platform for snappy-magic: $platform. remember to file a bug or better yet: fix it :)"
    ;;
esac

echo SNAP_APP_PATH:  $SNAP_APP_PATH

# workaround that snappy services have bogus SNAP_ vars set; assume PWD is right
echo "$SNAP_APP_PATH" | grep -q SNAP_APP && SNAP_APP_PATH=$PWD
if test -z "$SNAP_APP_PATH"; then
  SNAP_APP_PATH=$PWD
fi

snapp_bin_path=$0
snapp_bin=`basename $snapp_bin_path`
snapp_dir=$SNAP_APP_PATH
snapp_name=`echo $snapp_bin | sed -e 's/\(.*\)[.]\([^.]*\)$/\1/g'`
snapp_org_bin=`echo $snapp_bin | sed -e 's/\(.*\)[.]\([^.]*\)$/\2/g'`
ip_address=`ifconfig eth0 | awk -F':' '/inet addr/&&!/127.0.0.1/{split($2,_," ");print _[1]}'`

$verbose && echo snapp_name: $snapp_name
$verbose && echo snapp_bin: $snapp_bin
$verbose && echo snapp_dir: $snapp_dir
$verbose && echo snapp_org_bin: $snapp_org_bin
$verbose && echo plat_abi: $plat_abi
$verbose && echo ip_address: $ip_address

PATH="$snapp_dir/bin/$plat_abi/:$PATH"
LD_LIBRARY_PATH="$snapp_dir/lib/$plat_abi/:$LD_LIBRARY_PATH"
export PATH LD_LIBRARY_PATH

# make cwd the snapp dir
cd $snapp_dir

# fire up the binary
# exec $snapp_bin "$@" --datadir "$SNAP_APP_DATA_PATH/.ethereum" --ipcpath "$SNAP_APP_DATA_PATH/.ethereum/geth.ipc" --rpc --rpcaddr "$ip_address" --rpcport "8545" --rpccorsdomain "http://$ip_address"
# temporarily write to /root/.ethereum until the introduction of a common "shared"
# directory for all versions of a snap which is expected to happen in 16.xx version.
exec $snapp_bin "$@" --datadir "/root/.ethereum" --ipcpath "/root/.ethereum/geth.ipc" --rpc --rpcaddr "$ip_address" --rpcport "8545" --rpccorsdomain "http://$ip_address"


# never reach this
exit 1

