function Expand-WebArchiveLinux([string]$uri, [string]$runtime)
{
    $tmp = [System.IO.Path]::GetTempPath() + [System.Guid]::NewGuid().ToString() + ".zip"
    Invoke-WebRequest -Uri $uri -OutFile $tmp
    mkdir -p ./runtimes/$runtime/native
    unzip $tmp -d ./runtimes/$runtime/native
    $tmp | Remove-Item
}

function Expand-WebArchiveWindows([string]$uri, [string]$runtime)
{
    $tmp = [System.IO.Path]::GetTempPath() + [System.Guid]::NewGuid().ToString() + ".zip"
    Invoke-WebRequest -Uri $uri -OutFile $tmp
    $tmp | Expand-Archive -DestinationPath ./runtimes/$runtime/native
    $tmp | Remove-Item
}

git submodule update --init --recursive --quiet

$linuxUri   = "https://ci.appveyor.com/api/buildjobs/6wayul6wuod6oa5h/artifacts/artifacts.zip"
$windowsUri = "https://ci.appveyor.com/api/buildjobs/wn4dljrhg1037hr6/artifacts/artifacts.zip"

if ($isLinux)
{
    Expand-WebArchiveLinux $linuxUri "linux-x64"
    Expand-WebArchiveLinux $windowsUri "win-x64"
}
elseif ($isWindows)
{
    Expand-WebArchiveWindows $linuxUri "linux-x64"
    Expand-WebArchiveWindows $windowsUri "win-x64"
}