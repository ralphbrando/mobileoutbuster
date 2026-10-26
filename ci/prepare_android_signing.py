"""Prepare only the existing Outbuster upload key; never generate a replacement."""
import base64
import os
from pathlib import Path

required = (
    "OUTBUSTER_KEYSTORE_BASE64", "OUTBUSTER_KEYSTORE_PASSWORD",
    "OUTBUSTER_KEY_ALIAS", "OUTBUSTER_KEY_PASSWORD",
    "GOOGLE_PLAY_SERVICE_ACCOUNT_CREDENTIALS",
)
missing = [name for name in required if not os.environ.get(name)]
if missing:
    raise SystemExit("Missing app-scoped secrets: " + ", ".join(missing))
if os.environ.get("OUTBUSTER_STORE_IDS_CONFIRMED") != "true":
    raise SystemExit("Confirm the existing Play package matches com.outbuster.app, then set OUTBUSTER_STORE_IDS_CONFIRMED=true.")
if 'applicationId "com.outbuster.app"' not in Path("android/app/build.gradle").read_text():
    raise SystemExit("Android package differs from the configured release workflow.")

key_path = Path(os.environ.get("CM_BUILD_DIR", os.getcwd())) / ".outbuster-upload.jks"
key_path.write_bytes(base64.b64decode(os.environ[required[0]], validate=True))
key_path.chmod(0o600)

def prop(value):
    return value.replace("\\", "\\\\").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t").replace(" ", "\\ ")

values = {
    "storeFile": str(key_path),
    "storePassword": os.environ[required[1]],
    "keyAlias": os.environ[required[2]],
    "keyPassword": os.environ[required[3]],
}
properties = Path("android/key.properties")
properties.write_text("\n".join(f"{key}={prop(value)}" for key, value in values.items()) + "\n", encoding="utf-8")
properties.chmod(0o600)
print("Existing Outbuster upload key configured.")
