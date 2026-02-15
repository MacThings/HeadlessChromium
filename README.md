# Headless Chromium
Browse via SSH Tunnel with headless Chromium under Ubuntu/Debian.

Needed Dependencies on the headless Server:

    sudo apt update
    sudo apt install chromium xvfb x11vnc x11-utils dbus-x11 fonts-liberation

Establish a SSH Tunnel between your Working Place and the headless Server:

    ssh -N -f -L 5999:localhost:5900 user@headless.server.ip -p 22

Get the VNC Client for your Working Place here:

[RealVNC Viewer download](https://www.realvnc.com/de/connect/download/viewer/)

Now put the

    vnc.sh

Script onto your headless Server.

Run Chromium headless this way:

    /bin/bash vnc.sh _open

Than start the Real VNC Viewer on the Working Place and connect to this address:

    localhost:5999

Done. Now you should be able to Browse on your headless Server.
