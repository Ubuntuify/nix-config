#
# Melinoe is a system with only 8GB of RAM, which requires a swapfile to be declared
# for optimal performance (and OOM conditions).
#
{
  # Set "zswap" (in-swap compression) paramaters in kernel.
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.zpool=zsmalloc"
    "zswap.max_pool_percent=50"
  ];

  swapDevices = [
  ];
}
