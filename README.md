# Docker Oracle REST Data Services RPM Builder

This project contains a Dockerfile for a container that will build an Oracle REST Data Service RPM package with SystemV script.

## Getting Started

These instructions will tell you how to use this container to build an RPM.

### Prerequisities

You'll need some form of docker that can have a volume mounted where it'll put the RPM. 

[Boot2docker](http://boot2docker.io/) works if you want to test it on your local machine. The following commands once you run boot2docker will get it up an running. It mounts the "/Users" directory in the VM, we'll use this as the output path for the RPM to get it on our hosts directory.  

```
boot2docker init 
boot2docker up 
eval "$(boot2docker shellinit)"
```

For licensing reasons we can't distribute the ORDs zip file. [Download it](http://www.oracle.com/technetwork/developer-tools/rest-data-services/ords-30-downloads-2373781.html) and store it somewhere wget-able before we start.

### Running

Assuming you have a docker instance to communicate with

```shell
docker build -t rpm-builder-ords . && docker run -e "ORDS_ZIP=http://example.com/path/to/zip" -v $(pwd):/rpmbuild rpm-builder-ords 
```

Will cause an RPM to fall out at ```$(pwd)``` named ```ords-3.0.0.121.10.23-1.x86_64.rpm```

You can customise the RPM output directory in the container by setting the ```$RPM_OUTPUT_DIR``` environment variable.

## RPM Details

* The RPM will install to `/opt/ords.3.0.0/`
* The RPM comes with a SystemV script
* The SystemV script will configure ORDs from the `/opt/ords.3.0.0/params/ords_params.properties`. If this file is updated ORDs will be reconfigured when restarted. 
* The config file can have the parameters defined in the [documentation for ORDs](https://docs.oracle.com/cd/E56351_01/doc.30/e56293/config_file.htm#AELIG7204).

## Testing the RPM

There is bundled a [vagrant](https://www.vagrantup.com/) file that starts a CentOS 6 machine, that can be used for testing the RPM.

It has a base image for [VirtualBox](https://www.virtualbox.org/).

## Built With

* [ORDs](http://www.oracle.com/technetwork/developer-tools/rest-data-services) - Great for avoiding connecting to Oracle directly.
* [FPM](https://github.com/jordansissel/fpm) - Makes making RPMs very easy.
* [Docker](https://www.docker.com) - So we can statically link to RedHat compatible binaries even if we're not running on RedHat.

# Find us

##  Docker repository
[ukhomeofficedigital/lev-rpm-builder-ords](https://registry.hub.docker.com/u/ukhomeofficedigital/lev-rpm-builder-ords)

## GitHub
[UKHomeOffice/lev-rpm-builder-ords](https://github.com/UKHomeOffice/lev-rpm-builder-ords)


## Contributing

Feel free to submit pull requests and issues. If it's a particularly large PR, you may wish to discuss it in an issue first.

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/UKHomeOffice/lev-rpm-builder-ords/blob/master/code_of_conduct.md). By participating in this project you agree to abide by its terms.

## Versioning

We use [SemVer](http://semver.org/) for the version tags available See the tags on this repository. 

## Authors

* **Billie Thompson** - *Developer* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/UKHomeOffice/lev-rpm-builder-ords/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/UKHomeOffice/lev-rpm-builder-ords/blob/master/LICENSE.md) file for details

## Acknowledgments

* jordansissel for writing FPM and saving my santity trying to build RPMs
