# webcface-windows-package

[WebCFace](https://github.com/na-trium-144/webcface), [webui](https://github.com/na-trium-144/webcface-webui), [tools](https://github.com/na-trium-144/webcface-tools) をWindows用にビルドしてインストーラーを作成するリポジトリです

## Download

[Releases](https://github.com/na-trium-144/webcface-windows-package/releases) からダウンロードしてください。

Visual Studio 2019でx86とx64用にビルドしています。

## Buildするには

```sh
cmake -Bbuild -Ax64 -DARCH=x64 -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
cd build
cpack -G NSIS
```

x86の場合はアーキテクチャは`Win32`にする
