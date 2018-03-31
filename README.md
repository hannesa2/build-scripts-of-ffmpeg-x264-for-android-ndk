# Build scripts of ffmpeg x264 with Android NDK
ffmpeg build scripts with android ndk (including x264)

### Requirement

* NDK r11
* nasm >= 2.13

You can check your current version with `nasm -v` 

On macOS you will see `Apple 0.98` and to get recent version on macOS `brew install nasm` 

### Setup

Currently it expect NDK location at `~/Development/android-ndk-r11c`

If you want to change it at once run at macOS

`grep -rl NDK= * -R| xargs sed -i '.bak' 's/\~\/Development\/adt\/sdk\/ndk-bundle/point-to-your-NDK/g'`

or on Linux

`grep -rl NDK= * -R| xargs sed -i 's/\~\/Development\/adt\/sdk\/ndk-bundle/point-to-your-NDK/g'`

[Document](https://yesimroy.gitbooks.io/android-note/content/ffmpeg_build_process.html)
