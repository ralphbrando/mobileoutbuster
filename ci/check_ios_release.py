"""Refuse signing until the existing store identity and app-scoped secrets are set."""
import os
from pathlib import Path

required = (
    "APP_STORE_CONNECT_PRIVATE_KEY", "APP_STORE_CONNECT_KEY_IDENTIFIER",
    "APP_STORE_CONNECT_ISSUER_ID", "CERTIFICATE_PRIVATE_KEY",
)
missing = [name for name in required if not os.environ.get(name)]
if missing:
    raise SystemExit("Missing app-scoped secrets: " + ", ".join(missing))
if os.environ.get("OUTBUSTER_STORE_IDS_CONFIRMED") != "true":
    raise SystemExit("Confirm Apple app 6447878468 uses bundle com.outbuster.app, then set OUTBUSTER_STORE_IDS_CONFIRMED=true.")
if "PRODUCT_BUNDLE_IDENTIFIER = com.outbuster.app;" not in Path("ios/Runner.xcodeproj/project.pbxproj").read_text():
    raise SystemExit("iOS bundle differs from the configured release workflow.")
print("Outbuster App Store identity and secret names checked.")
