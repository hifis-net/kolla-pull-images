# OpenStack Kolla Pull Images

A simple shell script to pull [OpenStack Kolla](https://opendev.org/openstack/kolla)
container images and push them to a local container registry.

## Usage

### Get the script

```sh
git clone https://github.com/hifis-net/kolla-pull-images.git
cd kolla-pull-images
```

### Specify the OpenStack Kolla release

To specify the desired Kolla release to download, please adjust the following
variable inside `kolla-pull-images.sh`:

```sh
kolla_release="2024.2-ubuntu-jammy"
```

### Run the script

```sh
chmod +x kolla-pull-images.sh
./kolla-pull-images.sh
```
