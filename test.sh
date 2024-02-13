#!/bin/bash

while true
do
    powershell -command "$Pos = [System.Windows.Forms.Cursor]::Position; $Pos.X += 1; $Pos.Y += 1; [System.Windows.Forms.Cursor]::Position = $Pos;"

    sleep 120
done
