# セッション終了後、知識はどこへ：クロスセッションMemory Engineering

タスク分解は、複雑なプロジェクトが複数のセッションにまたがることを意味する。セッションが終了するたびにcontext windowはクリアされ、Agentの作業メモリ全体がゼロにリセットされる。次のセッションは白紙の状態から始まる。

メモリメカニズムがなければ、毎回のセッション開始時にプロジェクトの背景、現在の進捗、既に下された設計決定、既に遭遇した落とし穴をAgentに再度説明する必要がある。この繰り返しの情報伝達は時間がかかるだけでなく信頼性も低い。重要な詳細を省略する可能性があり、その省略によりAgentが同じミスを繰り返すことになるからだ。

Skill Cardがこの問題を解決するための中核的な手段だ。各Agentロールには、知っておくべき永続的な情報を記録したSkill Cardが装備される。最小限のSkill Cardは以下の構造を含む：

```
skill: Coder
inputs: [spec.section, test.failures]
outputs: [pr.diff, test.results]
definition_of_done: ["All tests green", "PR description maps to spec entries"]
trust_boundaries: ["Do not change database schema", "Do not modify external API contracts"]
failure_retry: {retries: 2, strategy: "Narrow change surface + request more context"}
escalation: "On consecutive failures, escalate to Reviewer and return to spec for clarification"
```

Skill Cardはセッションをまたいで永続化される。従来のチームにおける暗黙知のキャリアとしての機能を果たす。新しいセッションが始まると、Agentは対応するSkill Cardをロードし、ロール定義、作業の境界、既知の対処戦略、過去の教訓を即座に取得する。何をすべきか、何ができるか、何をしてはいけないかをゼロから理解する必要はない。

ロールレベルのSkill Cardに加えて、プロジェクトレベルの知識永続化も必要だ。各セッション終了時の知識キャプチャは重要なステップである。このセッションでどんな決定がなされたか？ どんな新しい制約が発見されたか？ どんな落とし穴にはまったか？ これらの情報は構造化された方法で記録され、次のセッションへの入力となる必要がある。

効果的なアプローチは、各セッションの終了時に簡単なレトロスペクティブを行うことだ。何が起きたか？ 結果は仕様やテストの期待とどう違ったか？ どの仮定が間違っていたか？ どのSkill Cardや仕様を更新する必要があるか？ これらの問いに対する答えがキャプチャされ、Skill Cardや仕様システムに書き戻される。

Skill Card自体も進化する必要がある。プロジェクトが進むにつれて、Agentのロール境界が変わり、新しい制約が発見され、より良い対処戦略が検証される。Skill Cardは一度書いたら固定の設定ファイルではない。継続的に更新される知識キャリアだ。PRが振る舞いの変更をもたらした場合、対応するSkill Cardも同期して更新されるべきだ。これは知識レベルにおける進化原則の具体的な実践である。

Memory Engineeringの目標は、Agentの100回目のセッションを1回目より効率的にすることだ。人間のチームではこの種の蓄積は自然に起こる。Agent駆動チームでは、明示的にエンジニアリングする必要がある。
