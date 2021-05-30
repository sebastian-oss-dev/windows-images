# Base Windows images for Docker
Especially for companies with a corporate proxy to reach the internet during or after installation of software packages.

## Usage

```powershell
docker login jfrog.example.com/docker-virtual

docker pull jfrog.example.com/docker-virtual/windows/windows-ltsc2019
docker pull jfrog.example.com/docker-virtual/windows/windows-1909

docker logout jfrog.example.com/docker-virtual
```

## Build all

```powershell
$env:registry_url="jfrog.example.com/docker-virtual"
$env:registry_username="<USERID>"
$env:registry_password="<TOKEN>"
$env:image_proxy="myproxy.net:3128"
$env:post_install_proxy=""
$env:image_release=":1.0"
$env:bypass_list='localhost' # Set proxy after installation without proxy is done
$env:post_install_bypass_list='localhost' # Set proxy bypass_lis after installation without proxy is done

./Build_all_images.ps1
```

## Build one

```powershell
docker build --build-arg version=ltsc2019 --pull --rm -f "Dockerfile" -t "jfrog.example.com/docker-virtual/windows/windows-ltsc2019:1.0" "."
```

## Test internet connection

```powershell
docker run -ti jfrog.example.com/docker-virtual/windows/windows-ltsc2019:1.0 powershell -C 'Invoke-WebRequest https://www.google.de -UseBasicParsing'
```