-- ============================================================================
-- 溝通交流知識庫 (Communication & Dialogue Knowledge Hub)
-- Supabase PostgreSQL Schema & Row Level Security (RLS)
-- 安全原則：前端僅使用 anon/publishable key，嚴禁洩漏 service_role key
-- 請於 Supabase Dashboard -> SQL Editor 貼上並執行本腳本
-- ============================================================================

-- 1. 團隊共學筆記與實戰案例表 (comm_team_notes)
CREATE TABLE IF NOT EXISTS public.comm_team_notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  author_name TEXT NOT NULL DEFAULT '團隊成員',
  book_slug TEXT NOT NULL DEFAULT 'principles-of-communication',
  slide_no INTEGER,
  category TEXT NOT NULL DEFAULT '實戰心得'
    CHECK (category IN ('實戰心得', '團隊案例', '一分鐘四問預演', '金句摘錄')),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  tags TEXT[] NOT NULL DEFAULT '{}',
  is_shared BOOLEAN NOT NULL DEFAULT true
);

-- 索引最佳化（加速依書籍時間排序與本人查詢）
CREATE INDEX IF NOT EXISTS idx_comm_team_notes_book_created
  ON public.comm_team_notes (book_slug, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_comm_team_notes_user_id
  ON public.comm_team_notes (user_id);

-- 強制啟用 RLS 行級安全
ALTER TABLE public.comm_team_notes ENABLE ROW LEVEL SECURITY;

-- Policy 1: 僅限已登入團隊成員可讀取「團隊共享筆記」或「自己的私人筆記」
DROP POLICY IF EXISTS "comm_notes_select_shared_or_own" ON public.comm_team_notes;
CREATE POLICY "comm_notes_select_shared_or_own"
  ON public.comm_team_notes
  FOR SELECT
  TO authenticated
  USING (is_shared = true OR (SELECT auth.uid()) = user_id);

-- Policy 2: 僅限已登入本人新增筆記
DROP POLICY IF EXISTS "comm_notes_insert_own" ON public.comm_team_notes;
CREATE POLICY "comm_notes_insert_own"
  ON public.comm_team_notes
  FOR INSERT
  TO authenticated
  WITH CHECK ((SELECT auth.uid()) = user_id);

-- Policy 3: 僅限本人更新自己的筆記
DROP POLICY IF EXISTS "comm_notes_update_own" ON public.comm_team_notes;
CREATE POLICY "comm_notes_update_own"
  ON public.comm_team_notes
  FOR UPDATE
  TO authenticated
  USING ((SELECT auth.uid()) = user_id)
  WITH CHECK ((SELECT auth.uid()) = user_id);

-- Policy 4: 僅限本人刪除自己的筆記
DROP POLICY IF EXISTS "comm_notes_delete_own" ON public.comm_team_notes;
CREATE POLICY "comm_notes_delete_own"
  ON public.comm_team_notes
  FOR DELETE
  TO authenticated
  USING ((SELECT auth.uid()) = user_id);


-- 2. 個人／團隊行動落地打卡表 (comm_action_checkins)
CREATE TABLE IF NOT EXISTS public.comm_action_checkins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  book_slug TEXT NOT NULL,
  action_key TEXT NOT NULL,
  completed BOOLEAN NOT NULL DEFAULT false,
  reflection TEXT DEFAULT '',
  UNIQUE (user_id, book_slug, action_key)
);

CREATE INDEX IF NOT EXISTS idx_comm_action_checkins_user_book
  ON public.comm_action_checkins (user_id, book_slug);

ALTER TABLE public.comm_action_checkins ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "comm_checkins_all_own" ON public.comm_action_checkins;
CREATE POLICY "comm_checkins_all_own"
  ON public.comm_action_checkins
  FOR ALL
  TO authenticated
  USING ((SELECT auth.uid()) = user_id)
  WITH CHECK ((SELECT auth.uid()) = user_id);


-- 3. 自動更新 updated_at 觸發器
CREATE OR REPLACE FUNCTION public.comm_set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_comm_team_notes_updated_at ON public.comm_team_notes;
CREATE TRIGGER trg_comm_team_notes_updated_at
  BEFORE UPDATE ON public.comm_team_notes
  FOR EACH ROW EXECUTE FUNCTION public.comm_set_updated_at();

DROP TRIGGER IF EXISTS trg_comm_action_checkins_updated_at ON public.comm_action_checkins;
CREATE TRIGGER trg_comm_action_checkins_updated_at
  BEFORE UPDATE ON public.comm_action_checkins
  FOR EACH ROW EXECUTE FUNCTION public.comm_set_updated_at();
