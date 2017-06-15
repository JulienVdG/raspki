# RasPKI
a Raspberry Pi2 as an offline PKI

# The PKI

The PKI is implemented with openssl using the easy-rsa script from OpenVPN
There are two environments:
1. SHARED: It contain the keys and certificates for your clients and servers but not the CA key.
2. PRIVATE: It contain the complete PKI with the CA root certificate and private key.

The usage is as follows:
The SHARED environment can be accessed from other computers to fill request and retrieve signed certificates. It can also be used to update the configuration (ie add some specific client or server configuration file).

The PRIVATE environment is only accessed by RasPKI. This is your offline PKI.

There is a wrapper script called `raspki` that invoke easyrsa in either the SHARED or PRIVATE environment.

# How to Build and Install

## Get buildroot

either clone with `--recursive` option
or use `git submodule update --init`

## Configure

You can customize the configuration by populating the `overlay/etc/easy-rsa` directory.
The content on this directory is copied to (or merged with) the SHARED and PRIVATE environment.

## Build step

1. build toolchain: `make -f Makefile.toolchain`

2. build raspki: `make`

## Install

_You need a 2GB minimum SDCard. The following instruction will **ERASE** all normal content present on your SDCard, make sure you are ready to dedicate it to this purpose. However if it contains a previous version of RasPKI your SHARED and PRIVATE environment will not be erased._

_Also be ready to store is safe as it will contain your CA._

Identify your sdcard device (assuming sdb bellow)
```
sudo dd if=output/images/sdcard.img of=/dev/sdb bs=1M
```

# How to Use

_You need a serial adapter connected to your Raspberry Pi2, the screen/keyboard might work but is really not tested (patch welcome)._
_Unplug the network cable from your Raspberry Pi2, it won't work anyway_

* Open a the serial link, place the SDCard in the Raspberry Pi2 and power it up.

  * At boot it will ask for the date as the Raspberry Pi does not have an RTC and we obviously can't use NTP.

  * It will prompt you for a key to open the PRIVATE environment. (At first boot you will have to choose that key).

  * Then it will update the easy-rsa configurations and ask you whether you want to update or not each modified files. The update are done twice, first from the RasPKI distribution (in case you updated it) to the SHARED environment then from the SHARED to the PRIVATE environment.

* Finally you will have to log in as root.

You can now use the `raspki` command to work on your PKI.

* At first use you should run `raspki init` to prepare the 2 environment and build your CA (you will have to chose a passphrase that will then be required for any CA operation).

* The `raspki` commands are:
  * `shared` execute easyrsa in SHARED environment, all remaining parameters are transmitted to easyrsa.
  * `private` execute easyrsa in PRIVATE environment, all remaining parameters are transmitted to easyrsa.
    _Note: The publish feature is enabled by default to any signed certificate will be copied to the SHARED environment_
  * `publish` update the PRIVATE environment index database, generate the CRL and copy the CA certificate, the CRL and the index database to the SHARED environment.
  * `auto` automatically process a certificate for a given type. (see raspki headers in x509-types config files bellow).
  * `list-types` list available types, with (auto) for those usable with the `auto` command.
  * `status` display a summary of all certificates (and types). The columns are \"t req key crt export  ser st  name\":
    * `t`      : `t`=type exist, `a`=exist with auto command
    * `req`    : request     `S`=in SHARED env - `P`= in PRIVATE env
    * `key`    : key         `S`=in SHARED env - `P`= in PRIVATE env
    * `crt`    : certificate `S`=in SHARED env - `P`= in PRIVATE env
    * `export` : `p12`=pkcs12, `p7b`=pkcs7
    * `ser`    : serial number
    * `st`     : revocation status
    * `name`   : base file name
  * `clean` remove all files associated with the given basename provided the certificate is revoked.

* When you are done, don't forget to launch `raspki publish` to update your SHARED environment. Then type `powerdown` and wait for the Raspberry Pi activity LED to stop blinking before removing the SDCard.

# Typical usage

## Generate a server certificate

1. either use `easyrsa gen-req` on your server and import the request to the SHARED environment (in that case the key is on your server already and will not be copied)
1. or directly generate it on RasPKI with: `raspki shared gen-req your-server-common-name`
2. import the request in the PRIVATE environment with: `raspki private import-req your-server-common-name`
3. sign your request with: `raspki private sign server your-server-common-name`

## Generate a client certificate

1. generate a request in the PRIVATE environment with: `raspki private gen-req your-client-common-name`
2. sign your request with: `raspki private sign client your-client-common-name`
3. export your client certificate with it's key: `raspki private export-p12 your-client-common-name`

# Implementation details

## SD Card layout
Once installed your SD Card will have three partitions.
1. The first one in FAT32 contains the Raspberry Pi2 bootloader, the kernel and the full system (as initrd).
2. The second in the SHARED environment, it's and ext4 partition mounted as /mnt/shared.
3. The third is the PRIVATE environment, it's an encrypted volume with an ext4 partition in it mounted as /mnt/private

Notes:
**Important: never mount the PRIVATE partition on any other computer, only on the Raspberry Pi2 running RasPKI with no network cable connected.**
It should probably not be on the same card and be backed up but it's still a lot better than having the CA on an online server...

The image only contains the partition tables and the first FAT32 partition so you can update your RasPKI configuration without destroying your SHARED and PRIVATE environments.

## raspki headers in x509-types config files

raspki comes with an `auto` command, this command simply executes easy-rsa several time to generate, sign, export a given certificate according to the configuration.
This is done by parsing the headers to generate the parameters to the easyrsa command.

Using the headers the x509-types file is no longer generic as the `client` and `server` files provided by easy-rsa but are specific to a certificate.
The file should configure as much parameters as needed to automate the generation of the certificate.

* for a server certificate named `server-name` the header should be
```
##raspki shared --req-cn=your-server-common-name --batch gen-req server-name
##raspki private import-req server-name
##raspki private sign-req server-name server-name
```

You can add any needed easyrsa parameters to each line.
The rest of the file should be similar to the `server` file provided by easyrsa. You can add extra openssl configuration.

* for a client certificate named `client-name` the header should be
```
##raspki private --req-cn=your-client-common-name --batch gen-req client-name
##raspki private sign-req client-name client-name
##raspki private export-p12 client-name
```

## Kernel configuration

This is basically the Raspberry Pi2 defconfig with the network stack disabled and the driver for the [ChaosKey](http://chaoskey.org) enabled.

# Bonus

Generating cryptographic keys relies on good random number generators, so test yours !

## Test the random generator

```
dieharder -a -g 201 -f /dev/hwrng
```
This is _VERY_ slow the Raspberry Pi2 rng has a low bandwidth.
About 2.84e+04 rands/second as reported by dieharder mesured on a Raspberry Pi2 2.

```
dieharder -a -g 201 -f /dev/chaoskey0
```
The ChaosKey is a little faster 6.20e+04 rands/second when connected to a Raspberry Pi2.

To test /dev/random use:
```
dieharder -a -g 500
```
