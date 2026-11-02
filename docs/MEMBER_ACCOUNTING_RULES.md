# Member Accounting Rules

How every number a member sees is produced. **Rule: the backend calculates, the app displays.** The app
never adds, subtracts, multiplies, divides or rounds money. It shows `MoneyModel.display` and uses
`MoneyModel.poisha` (an exact integer) only to compare with zero.

All amounts are integers in **poisha** (৳1 = 100 poisha) in the backend (`App\Support\Money\Money`,
BIGINT columns); floats are forbidden by architecture tests. Source: `SOMITI_SPEC.md` §1.5, §5, §6.

| Rule | Backend calculates | Mobile displays | Mobile calculates |
|------|--------------------|-----------------|-------------------|
| **Share unit (monthly deposit per share)** | From the single approved rate plan for the month (BR-5); a plan never changes once approved (BR-6). | `rates.share_unit.display` on the Shares page | Nothing |
| **Monthly deposit due** | On the 1st at 00:30: shares held that month × that month's share unit, one due per share lot (BR-2, BR-8). Stored with a copy of the month's rates (BR-9). | `DueModel.amount` | Nothing |
| **Service charge** | Shares × service charge per share for the month; may be 0 (then no due). Income for the society (4111), not savings (BR-3). | Due rows of type service charge | Nothing |
| **Registration fee** | Once per share when the share is acquired, at the fee in force in that month (BR-4). A later fee change never re-charges existing shares (unless the society chose the "difference" policy, which creates a one-time top-up due). | Due rows of type registration | Nothing |
| **Rate changes (৳500 → ৳600)** | Months before the new plan keep their old dues; months from the plan's start use the new rate. Example: 2 shares from July at ৳500, plan ৳600 from October → July–September dues ৳1,000 each, October onward ৳1,200. | Each due shows its own amount | Nothing |
| **Late fee** | Late when unpaid after due day + grace days (BR-10). Fixed amount or a percentage of a base (deposit, deposit + service, or total outstanding), rounded half-up to the poisha, optionally capped; once or monthly until paid. Separate `late_fee` due (BR-11). Never charged on opening arrears. | Due rows of type late fee; the rule on the Shares page | Nothing |
| **Payment allocation** | When staff approve a payment: open dues **oldest month first**; inside a month in the plan's order (default late fee → service charge → registration → deposit). Each due gets min(remaining, outstanding). Σ allocations + advance = payment exactly (BR-13, §6.4). | Payment detail `allocations[]` and `to_advance` | Nothing |
| **Advance** | Remainder after allocation goes to the member's advance (2111). When dues are generated, the advance is applied to open dues oldest first at the **current** rate (default policy `apply_at_current_rate`, BR-14/15): if ৳600 is due and ৳400 is left, ৳400 is applied and ৳200 stays due. | `advance.display` on Home | Nothing |
| **Advance months estimate** | advance ÷ (shares × (share unit + service charge)) at the rate of the month after paid-through, integer division. An estimate only. | "About N more months (estimate)" | Nothing |
| **Outstanding** | Σ outstanding of open dues. | `outstanding.display`; "Pay now" when `pay_now_visible` | Nothing (do not add up due rows) |
| **Paid through** | The latest month M with every due of month ≤ M settled; null when none (§5.5). Never stored. | `paid_through` as a month name | Nothing |
| **Savings** | The member's balance on 2101 from posted journals (deposits settled, plus dividends credited to savings). | `savings.display` on Home | Nothing |
| **Statement** | Opening = charges − payments before `from`; rows by date with a running balance; closing = opening + total charges − total paid. Positive balance = owed. | Rows' `charge`, `paid`, `balance` and the totals | Nothing |
| **Pay online** | Server parses the typed amount exactly (≤ 2 decimals, Bangla digits allowed); nothing is posted until approval. | The amount as typed in the confirmation; afterwards the backend's `amount.display` | Nothing (no parsing to double) |
| **Dividend** | Net profit → legal appropriations (reserve ≥ 15%, cooperative development fund 3%, …) → pool split by share-months with largest remainder so lines sum exactly (BR-20/21). | `DividendModel.amount` | Nothing |
| **Refund** | Staff refund an advance by payment voucher (Dr 2111 / Cr cash), president above a threshold (BR-16). | Lower `advance` on Home | Nothing |
| **Reversal** | Staff reverse an approved payment: mirror journal, allocations undone newest first, dues reopen (BR-17, §5.4). | Payment status `reversed`; dues open again | Nothing |
| **Adjustment / opening arrears** | Go-live import (planned) adds opening dues dated the month before go-live; corrections are new journals, never edits. | Normal due rows | Nothing |

## Display rules

- Show `display` exactly as received — it already has the ৳ sign, grouping and the right digits for the language.
- Colour by sign with `poisha` (e.g. outstanding > 0 → warning colour); never by parsing `display`.
- After a language change, re-request data: `display` and `label` come from the server in the request language.
- A missing amount (`null`) shows "—", never ৳0.

## What the app must not do

Sum due rows into a total, compute "remaining" from amount − paid, estimate dues from rates, convert
`poisha` to `double`, or round anything. Each of these has an authoritative field from the backend.
