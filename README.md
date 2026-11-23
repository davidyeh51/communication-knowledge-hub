# 溝通交流知識庫 (Communication & Dialogue Knowledge Hub)

> 對象：**自己、團隊成員** ｜ 架構：**麥肯錫顧問結構化簡報 ✕ 原創 SVG 圖解 ✕ 全域關鍵字檢索 ✕ 可擴充多書門戶 ✕ Supabase BaaS**

🌐 **線上網址 (GitHub Pages)**：https://davidyeh51.github.io/communication-knowledge-hub/

---

## 核心特色

1. **可持續擴充的多書門戶架構**：
   - 首頁 `index.html` 完全由 `data/library.json` 與 `data/search-index.json` 驅動，已內建旗艦書目《溝通的原則》並預留後續書目擴充插槽（詳見 [docs/EXPANSION.md](docs/EXPANSION.md)）。
2. **全域關鍵字即時檢索 (`Ctrl+K`)**：
   - 支援跨書籍、跨頁碼多關鍵字即時篩選、熱門概念快選與關鍵字高亮，點擊即精準跳轉至目標簡報的指定頁碼（`#slide-N`）。
3. **麥肯錫 10 分鐘完整簡報（首部旗艦書目：《溝通的原則》熊浩親述）**：
   - 嚴格忠於來源原文，全套 **15 頁 16:9 簡報**（每頁 40 秒節奏，內建 10 分鐘倒數計時器）。
   - 每頁皆具「金字塔行動結論標題 (Action Title)」、原創手繪 **13+ 張向量 SVG 模型圖解**、**重新繪製的典藏書籍封面與主題插圖**，以及三段式講者備忘稿抽屜（按 `N` 展開）。
4. **個人與團隊共學面板 ✕ Supabase 整合**：
   - 內建「重要發言前一分鐘四問」互動預演器、團隊落地行動打卡與共學案例筆記。
   - 嚴格遵循純前端安全規範：僅使用公開 `anon key`，後端採用 PostgreSQL **Row Level Security (RLS)** 控管權限（建表腳本見 [supabase/schema.sql](supabase/schema.sql)）；未登入時亦自動降級為本機暫存，零阻礙使用。

---

## 專案目錄結構

```text
communication-knowledge-hub/
├── index.html                           # 知識庫首頁門戶
├── decks/
│   └── principles-of-communication.html # 《溝通的原則》15 頁麥肯錫 10 分鐘完整簡報
├── data/
│   ├── library.json                     # 書庫與分類單一真相來源
│   └── search-index.json                # 全域深度檢索索引
├── assets/
│   ├── css/ (portal.css, deck.css)
│   ├── js/  (portal.js, deck.js, supabase-sync.js)
│   └── images/                          # 重新繪製的原創封面與主題插畫
├── supabase/
│   └── schema.sql                       # Supabase PostgreSQL 建表 + RLS 行級安全腳本
└── docs/
    └── EXPANSION.md                     # 新增書籍與簡報標準擴充手冊
```

---

## Supabase 雲端同步啟用方式

1. 登入您的 Supabase 專案 Dashboard → **SQL Editor**。
2. 貼上並執行 [`supabase/schema.sql`](supabase/schema.sql)，建立 `comm_team_notes` 與 `comm_action_checkins` 兩張資料表與完整 RLS 安全策略。
3. 於網頁右上角點擊「團隊登入 / Supabase」註冊或登入帳號，即可與團隊成員共享案例並跨裝置同步。
