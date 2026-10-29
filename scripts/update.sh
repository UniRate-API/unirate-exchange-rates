#!/usr/bin/env bash
# Regenerate the dataset CSVs from the UniRate API (https://unirateapi.com).
#
# Uses only `curl` + `jq` — zero package-manager dependencies, zero build step.
# Reads the API key from the UNIRATE_API_KEY environment variable (never hard-coded).
# All endpoints used are UniRate free-tier: /api/rates and /api/vat/rates.
#
#   UNIRATE_API_KEY=... ./scripts/update.sh
#
set -euo pipefail

: "${UNIRATE_API_KEY:?Set UNIRATE_API_KEY (get a free key at https://unirateapi.com)}"
BASE="${UNIRATE_BASE_URL:-https://api.unirateapi.com}"
ACCEPT='Accept: application/json'
DATA_DIR="$(cd "$(dirname "$0")/.." && pwd)/data"
TODAY="$(date -u +%F)"

mkdir -p "$DATA_DIR"

fetch() { curl -fsS -H "$ACCEPT" "$1"; }

echo "Generating exchange-rates.csv (bases: USD EUR GBP) ..."
{
  echo "date,base,currency,rate"
  for b in USD EUR GBP; do
    fetch "${BASE}/api/rates?api_key=${UNIRATE_API_KEY}&from=${b}" \
      | jq -r --arg d "$TODAY" --arg b "$b" \
          '.rates | to_entries | sort_by(.key)[] | [$d, $b, .key, (.value|tostring)] | @csv'
  done
} > "$DATA_DIR/exchange-rates.csv"

echo "Generating eu-vat-rates.csv ..."
{
  echo "date,country_code,country_name,vat_rate"
  fetch "${BASE}/api/vat/rates?api_key=${UNIRATE_API_KEY}" \
    | jq -r --arg d "$TODAY" \
        '.vat_rates | to_entries | sort_by(.key)[] | .value
         | [$d, .country_code, .country_name, (.vat_rate|tostring)] | @csv'
} > "$DATA_DIR/eu-vat-rates.csv"

echo "Done. Rows:"
for f in exchange-rates eu-vat-rates; do
  printf '  %-18s %s data rows\n' "$f.csv" "$(($(wc -l < "$DATA_DIR/$f.csv") - 1))"
done
