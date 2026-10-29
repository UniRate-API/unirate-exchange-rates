# UniRate Currency Exchange Rates & EU VAT Rates

An open, regularly-updated dataset of **foreign-exchange rates for 885+ currencies**
(fiat **and** cryptocurrency) against **USD, EUR and GBP**, plus **standard EU VAT
rates**. The data is sourced from the free [UniRate API](https://unirateapi.com) — a
free currency exchange-rate and VAT API covering 170+ fiat currencies and major
cryptocurrencies.

- 💱 **885 currencies** × 3 base currencies (USD, EUR, GBP) = long-format FX table
- 🧾 **Standard VAT rate** for every EU member state
- 🔓 **Public domain** (ODC-PDDL) — use it for anything
- 🔁 **Reproducible** — regenerate anytime with the included script and a free API key
- 📦 **Frictionless Data Package** (`datapackage.json`) — load it with any Frictionless tool

## Data

| File | Rows | Description |
|---|---|---|
| [`data/exchange-rates.csv`](data/exchange-rates.csv) | ~2,655 | One row per `(base, currency)` pair for bases USD, EUR, GBP |
| [`data/eu-vat-rates.csv`](data/eu-vat-rates.csv) | ~29 | Standard VAT rate per EU member state |

### `exchange-rates.csv`

| Field | Type | Description |
|---|---|---|
| `date` | date | UTC date the snapshot was generated (ISO-8601) |
| `base` | string | Base currency code — `USD`, `EUR` or `GBP` |
| `currency` | string | Quote currency code (ISO 4217 or crypto ticker) |
| `rate` | number | Value of 1 unit of `base` expressed in `currency` |

### `eu-vat-rates.csv`

| Field | Type | Description |
|---|---|---|
| `date` | date | UTC date the snapshot was generated (ISO-8601) |
| `country_code` | string | Country code (EU VAT convention; `EL` = Greece) |
| `country_name` | string | Country name |
| `vat_rate` | number | Standard VAT rate, percent |

## Source & attribution

All figures come from the **[UniRate API](https://unirateapi.com)**. Exchange rates
are the latest published mid-market rates; VAT rates are the current standard rates per
member state. See the API documentation and grab a free key at
<https://unirateapi.com>.

## Regenerating the data

The dataset is built with nothing but `curl` and `jq` — no package manager, no build
step, no third-party dependencies. Get a free API key at
[unirateapi.com](https://unirateapi.com), then:

```bash
export UNIRATE_API_KEY="your-free-key"
./scripts/update.sh
```

This repository also refreshes itself daily via GitHub Actions
([`.github/workflows/update.yml`](.github/workflows/update.yml)), so the published
figures stay current.

Only UniRate **free-tier** endpoints are used: `GET /api/rates` and `GET /api/vat/rates`.

## License

The data is released under the
[Open Data Commons Public Domain Dedication and License (PDDL) 1.0](http://opendatacommons.org/licenses/pddl/1.0/).
Attribution to [UniRate API](https://unirateapi.com) is appreciated but not required.
