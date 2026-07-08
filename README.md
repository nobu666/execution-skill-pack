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
hooks/confirm-master-push.sh master/mainへのgit pushを確認制にするPreToolUse hook
hooks/confirm-merge.sh      gh pr mergeを確認制にするPreToolUse hook
plugin.json                 marketplace配布の下準備（現状未機能。下記参照）
docs/handoff_prompt.md      Claude Code以外の環境向けコピペ用プロンプト
docs/prompt_templates.md    レビュー依頼・調査委譲・執筆委譲の定型
docs/model-policy.md        モデル・effortの使い分けポリシー
docs/examples.md            失敗→ルール化の実例集
docs/workflows/             領域別ワークフロー（content/software/business/seminar/teaching）
```

## 導入（Claude Code）

現時点の導入方法は下記の手動コピーが正。`plugin.json` はmarketplace配布（1コマンド導入）の下準備で、まだ機能していない（詳細は下記「plugin化の現状」）。

1. `output-styles/executor.md` を `~/.claude/output-styles/` にコピーし、`/config` の Output style メニューから `executor` を選ぶ（`/output-style` はv2.1.91で削除済み。全プロジェクトに効かせたいときは `~/.claude/settings.json` に `"outputStyle": "executor"` を直接書く）
2. `skills/` 配下の各ディレクトリを `~/.claude/skills/` にコピー
3. `agents/` 配下を `~/.claude/agents/` にコピー。frontmatterの `model:` は自環境で使える値（`sonnet` / `opus` / フルモデルID / `inherit`）に書き換える。Opusが使えない環境では `reviewer-structure` を `sonnet` に下げてよい（判定精度は落ちる）
4. `hooks/` 配下を `~/.claude/hooks/` にコピーし、`~/.claude/settings.json` の `hooks.PreToolUse` に `matcher: "Bash"` でそれぞれ登録する（コピーしただけでは効かない。登録例は `docs/examples.md` 実例1を参照）
5. `docs/` はコピーしないが、repo自体は削除せず手元に残す（agentのdescriptionが `docs/model-policy.md` 等を指すため、コピー後もReadで参照できるようにする）

既に同等のルールをCLAUDE.mdやoutput-styleに持っている環境では、重複させない。二重に入れると常時コンテキストを食い、ドリフトの温床になる。部分導入（例: agentsだけ入れずCLAUDE.mdの手順3から呼ぶ場合)は、呼び先の同名agentが無い環境として各skillの読み替え注記に従う。

**導入環境のCLAUDE.md等の固有規約と、本Packの内容が矛盾したら固有規約が勝つ。** 特に executor.md の確認境界（条6）やquality-gateの報告フォーマットは、既存の運用ルールがあればそちらを優先し、本Packからは上乗せできる部分だけを足す。

## plugin化の現状

公式仕様では plugin マニフェストは repo直下ではなく `.claude-plugin/plugin.json` に置く必要があり、`/plugin marketplace add` によるmarketplace配布には別途 `.claude-plugin/marketplace.json` を持つmarketplace定義が要る。現状の `plugin.json` はどちらの要件も満たしておらず、1コマンド導入はまだ機能しない。`skills/` `agents/` `output-styles/` のrepo直下配置自体は仕様どおりで、plugin化時もそのまま流用できる。

## 導入（Claude Code以外）

`docs/handoff_prompt.md` をシステムプロンプトまたは最初のメッセージに貼る。Sonnet系に渡すときは同ファイル末尾の注意（重要条の冒頭複製）に従う。

## 効果測定

導入前後で同じタスクを流し、次の3つを比べる: 完了報告のうち証拠つきの割合／レビュー指摘のうち「壊れる具体シナリオ」つきの割合／手戻り回数。

## 公開前の注意

このrepoには個人の作業環境に由来する記述が含まれる。公開する場合は、実名・実パス・内部プロジェクト名の有無に加え、非同梱スキル（docs/workflows/が参照する作者環境のスキル）への依存が説明つきになっているかを先にレビューすること。
