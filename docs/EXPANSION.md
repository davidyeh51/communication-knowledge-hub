# 溝通交流知識庫 — 擴充與維護標準手冊 (EXPANSION GUIDE)

本知識庫採用**資料驅動（Data-Driven）＋獨立簡報模組**架構，未來新增任何一本書籍、課程筆記或團隊溝通案例，皆只需依照以下 **3 個標準步驟**即可完成整合，無須改寫首頁主架構。

---

## 步驟一：建立新書／新資料的麥肯錫 10 分鐘簡報

1. 複製 `decks/principles-of-communication.html` 作為範本，於 `decks/` 目錄下建立新檔（例如：`decks/five-levels-of-listening.html`）。
2. 遵循**麥肯錫顧問風格四大守則**：
   - **完全忠於來源**：所有觀點、數據、案例必須取自來源文稿；來源未載明確標註「原文未載」。
   - **金字塔行動標題（Action Title）**：每頁標題皆為一句完整結論，而非名詞章節名。
   - **圖表優先於文字**：核心模型與對比使用原創內嵌 **SVG 向量圖表**，書籍封面與配圖必須重新繪製（儲存於 `assets/images/`，避免外部熱連結與版權風險）。
   - **三段式講者備忘稿（Speaker Notes）**：每頁於 `data-notes-*` 屬性填寫 `① 本頁結論`、`② 補充說明`、`③ 下一頁轉場`，控管於 12–16 頁（每頁 40–50 秒，全長約 10 分鐘）。

---

## 步驟二：註冊至首頁書庫 (`data/library.json`)

在 `data/library.json` 的 `books` 陣列中新增或將既有 `planned` 條目的 `status` 更新為 `"ready"`：

```json
{
  "id": "book-002",
  "slug": "five-levels-of-listening",
  "code": "COMM-02",
  "title": "《溝通的黃金法則》",
  "subtitle": "「聽話」的五個層次：溝通信譽的階梯",
  "author": "約翰・麥斯威爾",
  "sourceMeta": "天下雜誌書摘",
  "category": "listening",
  "categoryLabel": "傾聽與影響力信譽",
  "status": "ready",
  "badge": "完整簡報",
  "readingTime": "10 分鐘導讀",
  "slidesCount": 12,
  "svgCount": 8,
  "coverImage": "assets/images/book-listening-cover.png",
  "deckUrl": "decks/five-levels-of-listening.html",
  "publishedDate": "2026-12-01",
  "coreThesis": "一句話核心主張...",
  "keyPillars": [],
  "teamActions": [],
  "modules": []
}
```

首頁 `index.html` 會自動讀取 `library.json` 並生成對應卡片、篩選分類統計與行動清單。

---

## 步驟三：同步寫入全域搜尋索引 (`data/search-index.json`)

為讓首頁 `Ctrl+K` 全域搜尋能夠精準定位到新簡報的每一頁投影片，在 `data/search-index.json` 追加每頁條目：

```json
{
  "id": "comm02-s01",
  "bookSlug": "five-levels-of-listening",
  "bookTitle": "《溝通的黃金法則》",
  "author": "約翰・麥斯威爾",
  "slideNo": 1,
  "module": "封面與核心主張",
  "actionTitle": "本頁麥肯錫行動結論標題",
  "summary": "摘要與關鍵案例...",
  "keywords": ["關鍵字1", "關鍵字2"],
  "url": "decks/five-levels-of-listening.html#slide-1"
}
```

---

## Supabase 雲端團隊共學擴充說明

- 本站點透過 `assets/js/supabase-sync.js` 串接 Supabase（僅使用公開 `anon/publishable key`，嚴格禁止於前端放置 `service_role key`）。
- 若尚未建立資料表，請將 `supabase/schema.sql` 貼入 Supabase Dashboard 的 **SQL Editor** 執行，即自動建立 `comm_team_notes`、`comm_action_checkins` 與對應的 **RLS 行級安全策略**。
- 新書上架後，只要 `book_slug` 與 `library.json` 一致，團隊共學筆記與行動打卡即自動支援新書篩選與雲端同步，無需修改資料庫結構。
