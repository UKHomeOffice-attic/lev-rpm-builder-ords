# rpm-builder-ords
Ords RPM Builder

```shell
docker build -t rpm-builder-ords . && docker run -v $(pwd):/rpmbuild rpm-builder-ords 
```

RPMs will fall out named ```ords-3.0.0.121.10.23-1.x86_64.rpm```
