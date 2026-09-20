#!/usr/bin/env python3
"""Validate all tenant configs against the JSON schema."""
import json
import sys
import glob
import os

try:
    import yaml
    from jsonschema import validate, ValidationError
except ImportError:
    print("Installing dependencies...")
    os.system("pip install pyyaml jsonschema")
    import yaml
    from jsonschema import validate, ValidationError

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SCHEMA_PATH = os.path.join(REPO_ROOT, "tenants", "schemas", "tenant-config.schema.json")

def load_schema():
    with open(SCHEMA_PATH) as f:
        return json.load(f)

def validate_tenant(schema, filepath):
    with open(filepath) as f:
        config = yaml.safe_load(f)
    try:
        validate(instance=config, schema=schema)
        return True, None
    except ValidationError as e:
        return False, str(e.message)

def main():
    schema = load_schema()
    tenant_files = glob.glob(os.path.join(REPO_ROOT, "tenants", "*", "*.yml"))

    if not tenant_files:
        print("No tenant configs found")
        sys.exit(0)

    failed = 0
    for filepath in sorted(tenant_files):
        tenant_name = os.path.basename(filepath).replace(".yml", "")
        valid, error = validate_tenant(schema, filepath)
        if valid:
            print(f"  ✓ {tenant_name}")
        else:
            print(f"  ✗ {tenant_name}: {error}")
            failed += 1

    if failed > 0:
        print(f"\n{failed} tenant(s) failed validation")
        sys.exit(1)
    else:
        print(f"\nAll {len(tenant_files)} tenant(s) valid")

if __name__ == "__main__":
    main()
