# Lionsbaseball

MATLAB tools for baseball biomechanics analysis using Hawk-Eye motion capture data.

Hawk-Eyeモーションキャプチャデータを用いた野球バイオメカニクス解析ツール集。

---

## batter_movie.m

Creates 3D stick figure animations of batting motion using Hawk-Eye data (JSON).

バッターのスティックピクチャ作成

### Usage
1. Run `batter_movie.m` in MATLAB
2. Select a Hawk-Eye JSON file
3. Enter parameters:
   - Horizontal angle (view from 1B side: 90, from 3B side: -90)
   - Elevation angle (from above: 90)
   - Duration (max 2 seconds)
4. Animation video is generated automatically

---

## pitcher biomechanics 2025

### HalkEyeJSON_Motion2025_1.m

Batch-processes Hawk-Eye 3D motion capture JSON files to compute a comprehensive set of **pitching biomechanics metrics** (60 variables per pitch).

Hawk-Eye JSONファイルからピッチングバイオメカニクスを一括解析するスクリプト（1投球あたり60変数）。

### Processing Pipeline

1. **Data Extraction** — Identifies pitcher (300 fps skeleton), detects runner presence, extracts metadata (name, throwing hand, play ID)
2. **Joint Mapping** — Extracts 3D coordinates for 26 joints per frame, auto-mirrored for RHP/LHP
3. **Signal Filtering** — 5th-order Butterworth low-pass filter (zero-phase via `filtfilt`)
4. **Joint Angles** — Hip, knee, ankle, elbow, pelvis/thorax rotation, shoulder int/ext rotation, trunk tilt, lower leg angle
5. **Angular Velocity** — Peak angular velocities for pelvis, thorax, and upper arm
6. **Event Detection** — Max knee lift, movement initiation, pelvis/thorax rotation onset, foot contact, max external rotation (MER), ball release
7. **Ball Trajectory** — Travel distance and 3D curvature (horizontal/vertical decomposition)
8. **Pelvis Velocity** — Peak resultant and Y-direction speed of midHip

### Output (60 variables per pitch)

| # | Variables | Description |
|---|---|---|
| 1–4 | Play ID, DateTime, Pitcher name | Metadata |
| 5 | Pitch speed | km/h |
| 6–17 | Event timings | sec (relative to ball release) |
| 18–29 | Angles at foot contact | Elbow height, MER, stride, pelvis height, joint angles |
| 30–43 | Angles at ball release | Pelvis, thorax, knee, arm slot (azimuth/elevation/slot) |
| 44–46 | Peak speeds & max separation | Pelvis speed, thorax-pelvis separation |
| 47–52 | Peak angular velocities & timings | Pelvis, thorax, upper arm |
| 53–56 | Ball trajectory | Travel distance, 3D/horizontal/vertical curvature |
| 57–60 | Context | Runner on 1B/2B/3B, date |

