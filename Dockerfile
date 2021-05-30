ARG version=ltsc2019
FROM mcr.microsoft.com/windows/servercore:$version

ARG proxy=""
ARG post_install_proxy=""
ARG bypass_list='localhost'
ARG post_install_bypass_list='localhost'

COPY Set_up_Proxy.ps1 .

SHELL ["powershell", "-Command"]

RUN if (-not ([string]::IsNullOrEmpty($env:proxy))) { .\Set_up_Proxy.ps1 $env:proxy $env:bypass_list; }

RUN $r = Invoke-WebRequest 'https://www.google.de' -UseBasicParsing; $r.StatusCode;

ENV chocolateyUseWindowsCompression false

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials; \
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco feature disable --name showDownloadProgress

RUN choco config set --name proxyBypassList --value "localhost" # https://github.com/chocolatey/choco/issues/1532
RUN choco install -y --acceptlicense --no-progress pswindowsupdate;
RUN choco install -y --acceptlicense --no-progress adoptopenjdk8;
RUN choco install -y --acceptlicense --no-progress 7zip;
RUN choco install -y --acceptlicense --no-progress python3;
RUN choco install -y --acceptlicense --no-progress git;
RUN choco install -y --acceptlicense --no-progress notepadplusplus;
RUN choco install -y --acceptlicense --no-progress nssm;
RUN choco install -y --acceptlicense --no-progress openssl;
RUN choco install -y --acceptlicense --no-progress sed;
RUN choco install -y --acceptlicense --no-progress curl;

RUN if (-not ([string]::IsNullOrEmpty($env:post_install_proxy))) { .\Set_up_Proxy.ps1 $env:post_install_proxy $env:post_install_bypass_list; }

# https://github.com/sebastian-oss-dev