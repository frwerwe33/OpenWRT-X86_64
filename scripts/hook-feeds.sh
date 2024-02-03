#!/bin/bash
# Set to local feeds
pushd customfeeds/packages
export packages_feed="$(pwd)"
popd
pushd customfeeds/luci
export luci_feed="$(pwd)"
popd
rm -rf config/Config-kernel.in
rm -rf package/kernel/linux/modules/netsupport.mk
cp -r $GITHUB_WORKSPACE/data/Config-kernel.in config/Config-kernel.in
cp -r $GITHUB_WORKSPACE/data/netsupport.mk package/kernel/linux/modules/netsupport.mk
cp -r $GITHUB_WORKSPACE/data/xdp-tools package/network/utils/xdp-tools
sed -i '/src-git packages/d' feeds.conf.default
echo "src-link packages $packages_feed" >> feeds.conf.default
sed -i '/src-git luci/d' feeds.conf.default
echo "src-link luci $luci_feed" >> feeds.conf.default
sed -i "/openwrt-daed/d" "feeds.conf.default"
echo "src-git openwrt-daed https://github.com/xuanranran/openwrt-daed.git" >> "feeds.conf.default"

./scripts/feeds update openwrt-daed
./scripts/feeds install -a -f -p openwrt-daed
# Update feeds
./scripts/feeds clean
./scripts/feeds update -a
