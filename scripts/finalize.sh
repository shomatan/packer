
echo "--------------------------------------------------------------"
echo "  Zero out the free space to save space in the final image "
echo "--------------------------------------------------------------"
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null
rm -f /EMPTY
