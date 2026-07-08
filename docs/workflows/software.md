# software — ソフトウェア開発ワークフロー

**注: 文中の Plans/・Decisions/・Knowledge/・メモ/ は作者のObsidian Vault（外部脳）の分類。自環境の記録先に読み替えること。**

1. 計画: 小さくない変更はPlan Mode。計画はプロジェクト外（Plans/）に書く
2. ゴール変換: 検証可能なゴールに変換してから着手（task-execution参照）
3. 実装: 外科的に。変更全行が依頼に紐づく
4. レビュー: reviewer-code（正しさ）。公開repoや外部入力を扱うコードは、差分をセキュリティ観点でも別レビュー（SSRF・コマンドインジェクション・パストラバーサル・プロンプトインジェクション・リソース枯渇）。Critical/Highが残ったままpushしない
5. 検証: テスト＋実データでのend-to-end。既存の自動化に触れたら特に
6. 提出: staged状態で見せる。commit/pushは都度明示確認（hookでも強制）。mergeも同様
7. 記録: 選択を伴う判断はDecisions/へ、解決した問題はKnowledge/へ、作業ログはメモ/へ
