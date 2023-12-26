# webcface-windows-package

[WebCFace](https://github.com/na-trium-144/webcface), [webui](https://github.com/na-trium-144/webcface-webui), [tools](https://github.com/na-trium-144/webcface-tools) をWindows用にビルドしてインストーラーを作成するリポジトリです

## Download

[Releases](https://github.com/na-trium-144/webcface-windows-package/releases) からダウンロードしてください。

Visual Studio 2019でx86とx64用にビルドしています。

## Buildするには

```sh
cmake -Bbuild -Ax64 -DARCH=x64 -DCMAKE_PREFIX_PATH=path\to\opencv\build\x64\vc16\lib -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=path\to\current\directory\install_debug
cmake --build build --config Debug -t install
cmake -Bbuild -Ax64 -DARCH=x64 -DCMAKE_PREFIX_PATH=path\to\opencv\build\x64\vc16\lib  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=path\to\current\directory\install_release
cmake --build build --config Release -t install
cd build
cpack -G NSIS
```

x86の場合はアーキテクチャは`Win32`にする
