# Base Windows images for Docker
Especially for companies with a corporate proxy to reach the internet during or after installation of software packages.

## Usage

```powershell
docker login

docker pull sebastianoss/windows:windows-ltsc2019
docker pull sebastianoss/windows:windows-1909

docker logout
```

## Fully loaded
Atm the image is fully loaded with basic software. Please have a look at https://github.com/sebastian-oss-dev/windows-images/blob/master/Dockerfile

## Github
https://github.com/sebastian-oss-dev/windows-images

## Test internet connection

```powershell
docker run -ti jfrog.example.com/docker-virtual/windows/windows-ltsc2019:1.0 powershell -C 'Invoke-WebRequest https://www.google.de -UseBasicParsing'
```