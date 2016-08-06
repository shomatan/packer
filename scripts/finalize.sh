echo "--------------------------------------------------------------"
echo "  Clear and erase building packages "
echo "--------------------------------------------------------------"
yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts > /dev/null
yum -y clean all > /dev/null
rm -rf VBoxGuestAdditions_*.iso
rm -rf /tmp/rubygems-*

echo "--------------------------------------------------------------"
echo "  Zero out the free space to save space in the final image "
echo "--------------------------------------------------------------"
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null
rm -f /EMPTY
