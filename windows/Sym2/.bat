```batch
@echo off
setlocal

rem Function to handle symlinking
:symlink_items
set "ITEMPATH=%~1"
set "TARGET=%~2"
set "CACHE=%~3"

echo Symlinking new items in "%ITEMPATH%" to "%TARGET%"...
mkdir "%TARGET%" >nul 2>&1
mkdir "%CACHE%" >nul 2>&1

for %%I in ("%ITEMPATH%\*") do (
    rem Create the symlink only if cache doesn't already exist
    mklink /J "%CACHE%\%%~nI" "%%I" >nul 2>&1
    if !errorlevel! == 0 (
        xcopy /E /Y "%%I" "%TARGET%\" >nul 2>&1
        echo [created symlink] "%TARGET%\%%~nI"
    ) else (
        echo [already exists, skipped] "%CACHE%\%%~nI"
    )
)

echo Done!
goto :eof

rem Define paths for movies and shows
set "MOVIE_PATH=Z:\movies"
set "MOVIE_TARGET=Z:\media1\symlinks\blackhole\radarr"
set "MOVIE_CACHE=Z:\media1\symlinks\blackhole\.symlink_cache\movies"

set "SHOW_PATH=Z:\shows"
set "SHOW_TARGET=Z:\media1\symlinks\blackhole\sonarr"
set "SHOW_CACHE=Z:\media1\symlinks\blackhole\.symlink_cache\shows"

rem Call the function for movies and shows
call :symlink_items "%MOVIE_PATH%" "%MOVIE_TARGET%" "%MOVIE_CACHE%"
call :symlink_items "%SHOW_PATH%" "%SHOW_TARGET%" "%SHOW_CACHE%"

endlocal
```
