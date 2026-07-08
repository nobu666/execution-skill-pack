# execution-skill-pack

高性能モデル（Fable 5）の既定挙動を「明示的な指示」に変換し、Opus / Sonnet など他のモデルで再現するためのSkill Pack。2026-07-08にFable 5自身が自環境の診断とあわせて書き出したもの。

## 思想

上位モデルが黙ってやっていることを、下位モデルには文章で命令する。中身は3層:

1. **毎応答で効くべきもの** → output-style（`output-styles/executor.md`）。結論先行・即行動・証拠突合・許可の射程・実データ検証など12条
2. **場面ごとに呼び出す手順** → skills（タスク実行・品質ゲート・環境診断・ワークフローパターン）
3. **隔離すべき独立視点** → agents（コードレビュー・構造レビュー・ファクトチェックの3体）

レビューを本人と別コンテキストに隔離するのが品質再現の要。生成は安いモデル、判定は高いモデルに割り当てる（`docs/model-policy.md`）。

## 構成

```
output-styles/executor.md   行動規範12条（常時適用）
skills/task-execution/      タスク分解・自走と確認の境界・長時間タスク
skills/quality-gate/        提出前の機械的チェックリスト
skills/env-audit/           Claude Code環境のread-only診断手順
skills/workflow-patterns/   並列化・委譲・検証ループの使い分け
agents/reviewer-code.md     コード差分レビュア（read-only, sonnet）
agents/reviewer-structure.md 文章の通し読み構造レビュア（read-only, opus）
agents/fact-checker.md      一次情報裏取り専任（web+read, sonnet）
docs/handoff_prompt.md      Claude Code以外の環境向けコピペ用プロンプト
docs/prompt_templates.md    レビュー依頼・調査委譲・執筆委譲の定型
docs/model-policy.md        モデル・effortの使い分けポリシー
docs/examples.md            失敗→ルール化の実例集
docs/workflows/             領域別ワークフロー（content/software/business/seminar/teaching）
```

## 導入（Claude Code）

現時点の導入方法は下記の手動コピーが正。`plugin.json` はmarketplace配布（1コマンド導入）の下準備で、まだ機能していない。

1. `output-styles/executor.md` を `~/.claude/output-styles/` にコピーし、`/output-style executor` で有効化
2. `skills/` 配下の各ディレクトリを `~/.claude/skills/` にコピー
3. `agents/` 配下を `~/.claude/agents/` にコピー
4. `docs/` はコピーしない（常駐させない）。必要なときにReadする

既に同等のルールをCLAUDE.mdやoutput-styleに持っている環境では、重複させない。二重に入れると常時コンテキストを食い、ドリフトの温床になる。

## 導入（Claude Code以外）

`docs/handoff_prompt.md` をシステムプロンプトまたは最初のメッセージに貼る。Sonnet系に渡すときは同ファイル末尾の注意（重要条の冒頭複製）に従う。

## 効果測定

導入前後で同じタスクを流し、次の3つを比べる: 完了報告のうち証拠つきの割合／レビュー指摘のうち「壊れる具体シナリオ」つきの割合／手戻り回数。

## 公開前の注意

このrepoには個人の作業環境に由来する記述が含まれる。公開する場合は、実名・実パス・内部プロジェクト名の有無に加え、非同梱スキル（docs/workflows/が参照する作者環境のスキル）への依存が説明つきになっているかを先にレビューすること。
