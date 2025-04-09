# mkspiffs
Tool to build and unpack [SPIFFS](https://github.com/pellepl/spiffs) images.

## Settings for ESP8266-RTOS-SDK 4MB Flash

### Sdkconfig
```
  CONFIG_PARTITION_TABLE_CUSTOM=y
  CONFIG_PARTITION_TABLE_CUSTOM_FILENAME="partitions.csv"
  CONFIG_PARTITION_TABLE_OFFSET=0x8000
  CONFIG_PARTITION_TABLE_FILENAME="partitions.csv"
  CONFIG_SPIFFS_MAX_PARTITIONS=3
  CONFIG_SPIFFS_CACHE=y
  CONFIG_SPIFFS_CACHE_WR=y
  CONFIG_SPIFFS_PAGE_CHECK=y
  CONFIG_SPIFFS_GC_MAX_RUNS=10
  CONFIG_SPIFFS_PAGE_SIZE=256
  CONFIG_SPIFFS_OBJ_NAME_LEN=32
  CONFIG_SPIFFS_USE_MAGIC=y
  CONFIG_SPIFFS_USE_MAGIC_LENGTH=y
  CONFIG_SPIFFS_META_LENGTH=4
  CONFIG_SPIFFS_USE_MTIME=y
```

### partitions.csv
```csv
# Name               , Type, SubType, Offset  , Size    , Flags
# 24 KB for NVS
nvs                  , data, nvs    , 0x9000  , 0x6000  , 
# 4 KB for PHY
phy_init             , data, phy    , 0xf000  , 0x1000  , 
# 1 MB for app
factory              , app , factory, 0x10000 , 0x100000, 
# ~2.93 MB for SPIFFS
spiffs               , data, spiffs , 0x110000, 0x2F0000, 
```
### Build and flash
```
	mkspiffs -p 256 -c spiffs_data/ -s 0x2F0000 spiffs.bin
	$(IDF_PATH)/components/esptool_py/esptool/esptool.py --chip esp8266 --port /dev/ttyUSB0 --baud 115200 write_flash 0x110000 spiffs.bin
```

## Usage

```

   mkspiffs  {-c <pack_dir>|-u <dest_dir>|-l|-i} [-d <0-5>] [-b <number>]
             [-p <number>] [-s <number>] [--] [--version] [-h]
             <image_file>


Where: 

   -c <pack_dir>,  --create <pack_dir>
     (OR required)  create spiffs image from a directory
         -- OR --
   -u <dest_dir>,  --unpack <dest_dir>
     (OR required)  unpack spiffs image to a directory
         -- OR --
   -l,  --list
     (OR required)  list files in spiffs image
         -- OR --
   -i,  --visualize
     (OR required)  visualize spiffs image


   -d <0-5>,  --debug <0-5>
     Debug level. 0 means no debug output.

   -b <number>,  --block <number>
     fs block size, in bytes

   -p <number>,  --page <number>
     fs page size, in bytes

   -s <number>,  --size <number>
     fs image size, in bytes

   --,  --ignore_rest
     Ignores the rest of the labeled arguments following this flag.

   --version
     Displays version information and exits.

   -h,  --help
     Displays usage information and exits.

   <image_file>
     (required)  spiffs image file


```
## Build


 [![Build status](http://img.shields.io/travis/igrr/mkspiffs.svg)](https://travis-ci.org/igrr/mkspiffs)


You need gcc (≥4.8) or clang(≥600.0.57), and make. On Windows, use MinGW.

Run:
```bash
$ git submodule update --init
$ make dist
```

## SPIFFS configuration

Some SPIFFS options which are set at mkspiffs build time affect the format of the generated filesystem image. Make sure such options are set to the same values when builing mkspiffs and when building the application which uses SPIFFS.

These options include:

  - SPIFFS_OBJ_NAME_LEN
  - SPIFFS_OBJ_META_LEN
  - SPIFFS_USE_MAGIC
  - SPIFFS_USE_MAGIC_LENGTH
  - SPIFFS_ALIGNED_OBJECT_INDEX_TABLES
  - possibly others

To see the default values of these options, check `include/spiffs_config.h` file in this repository.

To override some options at build time, pass extra `CPPFLAGS` to `make`. You can also set `BUILD_CONFIG_NAME` variable to distinguish the built binary:

```bash
$ make clean
$ make dist CPPFLAGS="-DSPIFFS_OBJ_META_LEN=4" BUILD_CONFIG_NAME=-custom
```

To check which options were set when building mkspiffs, use `--version` command:

```
$ mkspiffs --version
mkspiffs ver. 0.2.2
Build configuration name: custom
SPIFFS ver. 0.3.7-5-gf5e26c4
Extra build flags: -DSPIFFS_OBJ_META_LEN=4
SPIFFS configuration:
  SPIFFS_OBJ_NAME_LEN: 32
  SPIFFS_OBJ_META_LEN: 4
  SPIFFS_USE_MAGIC: 1
  SPIFFS_USE_MAGIC_LENGTH: 1
  SPIFFS_ALIGNED_OBJECT_INDEX_TABLES: 0
```


## License

MIT

## To do

- [ ] Add more debug output and print SPIFFS debug output
- [ ] Error handling
- [ ] Code cleanup
