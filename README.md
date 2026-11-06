# Clinic Token Queue — MVP v0.1 (Demo)

Single-file web app: `index.html` (no dependencies, works offline, system fonts only).
Built from the TikTok-demo concept: reception issues tokens, the doctor calls the next
patient from a phone, and a TV in the waiting area instantly shows the number with a
voice announcement.

Demo clinic: **Dr Qaiser Iqbal** · Room: **Doctor's Room** (both changeable in Settings).

---

## How to run the demo (2 minutes)

You need ONE device with a modern browser (Chrome/Edge on the clinic PC, or a phone) —
the demo syncs between **tabs of the same browser**.

1. Open `index.html` in the browser.
   - Double-clicking the file works, or serve the folder:
     `python3 -m http.server 8765` then open `http://localhost:8765/`
2. You land on the **Call** view.
3. Open the TV display: tap **"Open the TV display"** (Call view or More tab).
   A second tab opens with `?view=tv#tv` — the `#tv` on its own also opens the
   TV view, if you ever share or type the TV link separately.
   - On the TV tab, **tap the screen once** ("Tap to enable sound") — browsers only
     allow sound after one tap. This enables the ding + TV voice announcements.
4. Arrange the two tabs side by side (or drag the TV tab to a second screen/TV).
5. Go to the **Tokens** tab → type an optional patient name → **New Token** a few times
   (tokens 1, 2, 3…). Use **Print slip** if you want the paper token.
6. Back on the **Call** tab → press **Call next**.
   - The TV tab instantly flashes the new number with a ting-tong chime, and shows the
     patient's name under the room name (when a name was entered).
   - With "Say the call on this device too" ticked, this device speaks the
     token **and the patient name** (when a name was entered), e.g.:
     *"ٹوکن نمبر 1، Ahmed Khan۔ براہ کرم Doctor's Room میں تشریف لے جائیں۔"* +
     *"Token number 1, Ahmed Khan. Please proceed to the Doctor's Room."*
     Without a name it just calls the number, as before.
7. Try **Call again**, **Done**, **No-show**, calling a specific number, and tapping a
   waiting patient in the **Queue** tab.

Everything is remembered in the browser (localStorage), so a refresh keeps the queue.
A new calendar day automatically starts a fresh queue; **More → Start new day / Reset**
(two-tap confirm) does the same manually.

---

## What works now (v0.1)

- **Call view** — current patient card, Call next / Call again / Done / No-show,
  call-a-specific-number, waiting list with one-tap call, "say it on this device" option.
- **Tokens view** — sequential token issuing with optional patient name, today's
  stats, and a print-friendly 58mm-style token slip (browser print dialog).
- **Queue view** — all of today's tokens with status chips; tap a waiting/no-show
  token to call it.
- **TV view** (`?view=tv` or `#tv`) — deep-blue full-screen display like the video:
  NOW SERVING / اب باری, big number + room, the current patient's name under the
  room name, LAST CALLED / پچھلے نمبر (last 5), waiting count, live clock,
  flash + ting-tong chime on every call, and a small status pill in the footer —
  **● Live · Last update HH:MM:SS** once it is receiving state, otherwise
  "Waiting for calls…" (with a one-line hint if no state arrives at all).
- **Voice announcements** — Urdu / English / Both (Settings), on the phone and
  optionally on the TV (toggle in Settings; TV needs the one-time tap first).
  The patient name is spoken too when the token has one.
- **Ting-tong chime** — a two-tone chime (high → low, about a second) plays
  BEFORE every announcement, on the TV and on the phone when "say it on this
  device" is on, so the voice never talks over it. If calls come in rapid
  succession, only the newest call is announced. Toggle in Settings
  ("Ting-tong chime before each announcement"), on by default.
- **Settings** — clinic name, doctor/room name, language, TV voice toggle,
  day reset, and Supabase config fields (URL + anon key) saved for the next step.
- **Same-device sync** — localStorage + BroadcastChannel (+ storage-event
  fallback) keeps every open tab in sync instantly; a 1-second localStorage
  polling fallback also applies newer state in browsers where tab events
  don't arrive.

---

## Live sync across devices (Supabase) — phone ⇄ TV on different devices

Without a cloud config, sync is same-device tabs only. To make the phone and
the TV sync over the internet (this is the mode a real clinic uses):

1. Create a free project at [supabase.com](https://supabase.com) (any name,
   e.g. `clinic-token`).
2. In the project: **SQL Editor → New query**, paste the contents of
   `supabase-setup.sql` (repository root) and **Run**.
3. In the project: **Settings → API** — copy the **Project URL** and the
   **anon public key**.
4. On the **phone**: open the app link → **More → Cloud sync (Supabase)** →
   paste URL + anon key, keep Clinic code `dr-qaiser` (or pick your own),
   tap **Save cloud settings**. The status line should say *Live mode*.
5. On the **TV's browser**: open the same app link once (the normal view, not
   the TV link), enter the **same** URL + key + clinic code the same way,
   then open the TV display from that browser. One-time setup per device.
6. From now on: every token/call on the phone reaches the TV within about
   2 seconds, with the flash, ting-tong and (if enabled) the voice.

## Known limitations of the demo

- Without the Supabase config above, sync is **same browser, same device
  only** (tabs) — a TV on a different device will NOT update on its own.
- Live mode is designed for ONE controlling device (the doctor's phone) plus
  any number of displays. The anon key is shared by design in this demo
  mode; per-clinic logins come with the sellable version.
- Printing uses the browser's print dialog; there is no direct Bluetooth printing yet.
- Urdu speech quality depends on the device having an Urdu TTS voice; without one it
  falls back silently (English still plays in "Both" mode).
- Done / No-show act on the patient currently at the desk (the big number).
- **Troubleshooting — TV tab not updating?** On `file://`, some mobile browsers
  do not share localStorage / BroadcastChannel between tabs, so the TV tab may
  never see the calls: it keeps showing "Waiting for calls…" and, after a few
  seconds, a small hint line. Open both screens from the **same link**, and
  prefer an **online (http/https) link** — hosting the file online is the
  recommended setup and syncs reliably.

## What comes next

1. **Bluetooth ESC/POS printer app** — one-tap token-slip printing on 58mm thermal
   printers without the print dialog.
2. Per-clinic accounts for selling to multiple clinics (Phase 3 of the plan),
   reports (patients/day, no-shows, average wait), and an offline local-Wi-Fi mode.
