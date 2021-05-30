$registry_url =             $env:registry_url
$registry_username =        $env:registry_username
$registry_password =        $env:registry_password
$image_proxy =              $env:image_proxy
$image_name =               $env:image_name
$image_release =            $env:image_release
$image_latest_release =     $env:image_latest_release # Needed for JFrog :-)
$post_install_proxy =       $env:post_install_proxy

$array = @("ltsc2019","1909")

echo "`nConfig:`n";
echo "registry_url: '$registry_url'";
echo "registry_username: '$registry_username'";
echo "image_proxy: '$image_proxy'`n";

echo "$registry_password" | docker login -u $registry_username $registry_url --password-stdin 

foreach ($v in $array){
    $version=$v;

    echo "`nBuilding windows:$version";

    docker build --build-arg version=$version --build-arg proxy=$image_proxy --build-arg post_install_proxy=$post_install_proxy --pull --rm -f "Dockerfile" -t "${registry_url}${image_name}${version}${image_release}" "."
    docker push "${registry_url}${image_name}${version}${image_release}"

    if ( -not ([string]::IsNullOrEmpty($image_latest_release))) { 
        docker tag "${registry_url}${image_name}${version}${image_release}" "${registry_url}${image_name}${version}${image_latest_release}"
        docker push "${registry_url}${image_name}${version}${image_latest_release}"
    }
}

docker logout $registry_url

echo "`nDone. Thanks for using this image generator`n";

# https://github.com/sebastian-oss-dev