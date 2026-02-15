function _open() {
DISPLAY_NUM=:99
PROFILE_DIR="$HOME/chrome-profile"

export DISPLAY=$DISPLAY_NUM

export XDG_RUNTIME_DIR=/tmp/chrome-runtime
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

eval "$(dbus-launch --sh-syntax)"

Xvfb $DISPLAY_NUM -screen 0 1920x1080x24 &
XVFB_PID=$!

until xdpyinfo -display $DISPLAY_NUM >/dev/null 2>&1; do
    sleep 0.3
done

x11vnc -display $DISPLAY_NUM -forever -shared -nopw -listen 0.0.0.0 &
VNC_PID=$!

mkdir -p "$PROFILE_DIR"

chromium \
  --display=$DISPLAY_NUM \
  #--no-sandbox \
  --disable-setuid-sandbox \
  --user-data-dir="$PROFILE_DIR" \
  --disable-dev-shm-usage \
  --kiosk \
  --disable-gpu &

CHROME_PID=$!

wait $CHROME_PID
}

function _close() {

DISPLAY_NUM=:99
export DISPLAY=$DISPLAY_NUM

echo "Stopping Chromium / VNC / Xvfb on display $DISPLAY_NUM ..."

pkill -f "chromium.*$DISPLAY_NUM" 2>/dev/null || true
pkill -f "chromium --display=$DISPLAY_NUM" 2>/dev/null || true

pkill -f "x11vnc.*$DISPLAY_NUM" 2>/dev/null || true

pkill -f "Xvfb $DISPLAY_NUM" 2>/dev/null || true

pkill -f "dbus-launch" 2>/dev/null || true

RUNTIME_DIR=/tmp/chrome-runtime
if [ -d "$RUNTIME_DIR" ]; then
    rm -rf "$RUNTIME_DIR"
fi

echo "All processes stopped."
}

$1
