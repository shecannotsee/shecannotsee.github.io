# 《Building with the Claude API》中文导读

课程公开页目前能拿到的内容，主要是完整目录、课程概述，以及页面内嵌的一份课程笔记，并不是每节视频的逐字稿。本文按课程原结构整理公开内容，并结合最新官方文档补全成一版适合入门阅读的中文说明。

## 课程地图

这门课公开页显示一共 `84` 节、约 `8.1` 小时、`10` 个 quiz，核心分 7 大块：

1. Getting started with Claude
2. Prompt engineering & evaluation
3. Tool use with Claude
4. Retrieval augmented generation
5. Model Context Protocol (MCP)
6. Claude Code & Computer Use
7. Agents and workflows

## 核心概念

Claude API 可以先按一个简单模型来理解：

系统接收“上下文”，再生成“下一步最合理的回复”。

这里的“上下文”可以是：

- 文字消息
- 多轮对话历史
- system prompt
- 图片
- PDF
- 文件
- 工具定义
- 检索出来的文档片段
- MCP 接进来的工具或资源

整门课主要围绕 4 件事展开：

- 怎么正确喂上下文
- 怎么让输出更稳定
- 怎么让 Claude 调工具、查资料、处理文件
- 怎么把它变成 workflow 或 agent

## 1. Claude API 入门

最基本的调用先记住 3 个字段：

- `model`
- `max_tokens`
- `messages`

最小心智模型：

- `messages` 是对话内容。
- `system` 是“你用什么方式回答”。
- `model` 是“你选择由哪个模型处理任务”。

最基本请求长这样：

```python
from anthropic import Anthropic

client = Anthropic()

resp = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    system="You are a patient teacher.",
    messages=[
        {"role": "user", "content": "用最简单的话解释什么是 API。"}
    ],
)

print(resp.content[0].text)
```

入门部分的重点包括：

- API key 只能放在你自己的服务端，不能直接放前端。
- Claude API 是“无状态”的。它不会替你记聊天记录。
- 你想要多轮对话，就自己维护 `messages` 数组，并且每次把完整历史再发给它。
- `system prompt` 控制“回答风格和行为”，不是数据库。
- `temperature` 控制随机性。低温更稳，高温更发散。
- `streaming` 是边生成边返回，提升用户体感。
- 你可以用“预填 assistant 回复 + stop sequence”控制输出开头和结束。
- 课程里用这个办法做结构化输出；但按 2026-03-30 官方文档，如果要保证 JSON 严格符合 schema，现在更适合用 `Structured Outputs`，不要只依赖 prompt 技巧。

这些参数可以这样理解：

- `system`：像给员工岗位说明书。
- `messages`：像把聊天记录和任务单一起递过去。
- `temperature`：像“保守一些”还是“更发散一些”。
- `stream=True`：像对方边打字边回，不是憋到最后一次性发。

## 2. Prompt Engineering 和 Prompt Evaluation

这一部分的重要性在于，它强调了一个很实际的问题：

Prompt 工作不是“一次写完”就结束，而是“写 prompt -> 测 -> 改 -> 再测”的迭代过程。

课程的核心思想：

- Prompt engineering = 想办法把 prompt 写清楚。
- Prompt evaluation = 用测试集客观验证 prompt 好不好。

标准评测流程：

- 先定义成功标准。
- 准备测试集。
- 跑 prompt。
- 打分。
- 改 prompt。
- 再跑一轮。

成功标准要满足：

- 具体
- 可衡量
- 跟业务有关

课程里讲了两类 grader：

- Model-based grading：再叫一个模型来判卷。
- Code-based grading：用代码规则打分，比如 JSON 能不能 parse、Python 能不能过 AST、正则对不对。

Prompt 写法上，课程反复强调 4 招：

- Clear and direct：第一句就说清楚你要它干什么。
- Be specific：把长度、格式、步骤、限制条件写清楚。
- XML tags：用 `<instructions>`、`<context>`、`<examples>` 把 prompt 分区。
- Examples：给 1 个或多个例子，让它照着学。

这一部分可以概括为：

- 模型不是笨，它只是不会猜你脑子里没写出来的要求。
- 你写得越像产品需求文档，它通常答得越稳。
- 你不给测试集，就不知道 prompt 到底好没好。

## 3. Tool Use：让 Claude 具备外部执行能力

Claude 默认主要依赖已有知识作答。要让它处理实时信息、调用外部能力或执行操作，就需要给它接入工具。

工具调用的基本流程：

- 你把工具定义发给 Claude。
- Claude 判断要不要用。
- 如果要用，它返回 `tool_use`。
- 你在自己这边真的执行工具。
- 你把结果以 `tool_result` 发回去。
- Claude 再基于结果回答用户。

这里需要掌握 5 个核心概念：

- 工具函数本身：你自己写的业务能力。
- 工具 schema：告诉 Claude 这个工具叫什么、干什么、参数长什么样。
- `stop_reason = "tool_use"`：表示 Claude 想调工具。
- `tool_result`：把执行结果返回给模型。
- 多轮 tool loop：Claude 可能连续调多个工具，不是只调一次。

课程还强调了几条工具设计原则：

- 工具描述要非常详细。
- 少做一堆碎工具，多做几个抽象但有用的工具。
- 工具参数 schema 要准确，不然 Claude 很容易乱填。
- 一个 agent 最好有少量通用工具，而不是几十个奇怪小工具。

课程还讲了这些具体方向：

- 多工具联动
- 并行工具调用
- 用工具做结构化数据提取
- Text Editor Tool
- Web Search Tool

结合 2026-03-30 官方文档，还需要注意这些更新：

- Web Search 是官方 server tool，可以拿实时网页结果，而且自带 citation。
- Text Editor Tool 是官方定义工具，适合读写文本文件。
- Code Execution Tool 现在能力更强，已经不只是“跑 Python”，还支持更完整的容器执行能力。

Tool use 的分工可以概括为：

- Claude 决定“该做什么”
- 你负责“真的去做”
- 然后把结果返回给 Claude

## 4. RAG：通过检索补充上下文

RAG = Retrieval Augmented Generation。

它解决的问题很简单：

- 资料可能太长，不能整本直接放进上下文。
- 即使能放进去，成本、延迟和干扰项也可能偏高。
- 所以通常会先检索最相关的片段，再把这些片段交给 Claude。

课程里的 RAG 流程包括：

- 切块 chunking
- 做 embeddings
- 建检索索引
- 用户提问
- 检索相关 chunk
- 把 chunk + 问题发给 Claude
- Claude 生成答案

课程特别强调 5 个要点：

- Chunking 很关键。切得烂，后面全烂。
- Embedding 是“语义相似度检索”。
- BM25 是“关键词检索”。
- 最稳的是 hybrid search：语义检索 + 关键词检索一起上。
- 先检索，再 rerank，会更准。

这一块的课程进阶点有两个：

- Reranking：先粗检索，再让模型重新排相关性。
- Contextual retrieval：给 chunk 加一点上下文，再做 embedding，减少“切块后丢语境”。

补充一点：

- 按当前 Anthropic 文档，Anthropic 自己不提供 embedding model，官方示例现在推荐外部 embedding 提供方，例如 Voyage AI。

可以简化理解为：

- 向量检索擅长“意思像”
- BM25 擅长“关键词真出现了”
- 两者混合，通常比单独用一个强

## 5. Claude 的高级能力：Thinking、图片、PDF、引用、缓存、文件

这一部分讨论的是 Claude 在纯文本对话之外的能力。

需要了解的内容包括：

- Extended Thinking / Adaptive Thinking
  - 课程讲的是 extended thinking。
  - 但按 2026-03-30 官方文档，Claude Opus 4.6 和 Sonnet 4.6 更推荐 `adaptive thinking`，手动 `thinking: {type: "enabled", budget_tokens: N}` 已经被标成将来会移除。
  - 核心思想不变：复杂任务给它更多“思考预算”，通常更准，但更慢、更贵。

- Vision
  - Claude 可以看图、比较图、数图里东西、读图表。
  - 重点不在于“能看图”，而在于提问是否足够具体。

- PDF support
  - Claude 不只是抽 PDF 文字，它还能看图表、表格和视觉布局。
  - 本质上，PDF 能力很大程度建立在 vision 能力上。

- Citations
  - Claude 可以给你“这句话依据文档哪一段”。
  - 这对报告、问答、知识库很重要。
  - 官方文档还特别提到：`cited_text` 不计入输出 token，某些场景会更省。

- Prompt caching
  - 如果 system、tools、长文档前缀经常重复，不要每次都重新算一遍。
  - Prompt caching 可以省钱、省延迟。
  - 当前文档里有两种方式：自动缓存和显式缓存断点。
  - 默认 cache 生命周期是 5 分钟，也有 1 小时方案。

- Files API
  - 文件先上传一次，后面靠 `file_id` 反复引用。
  - 这样不用每次都把大文件重新附在请求里。

- Code execution
  - 把 Claude 放进沙箱容器里跑代码、分析文件、生成结果。
  - 很适合数据分析、文件处理、自动生成图表。

这一部分可以归纳为：

- 图片/PDF/文件是“输入形式”
- citations/cache 是“可靠性和效率增强”
- thinking/code execution 是“推理和执行能力增强”

## 6. MCP：为 AI 接入标准化外部能力

MCP = Model Context Protocol。

可以把它类比为：

- USB-C 之于电脑
- MCP 之于 AI 应用

它要解决的问题是：

- 如果每接一个外部工具都要你手写一套接法，很累。
- MCP 用一个统一协议，把工具、资源、prompt 都标准化暴露出来。

课程里讲的 MCP 核心角色：

- MCP Server：把工具、资源、prompt 暴露出来
- MCP Client：连接 server，并把这些能力带进应用
- Inspector：调试 MCP server 的工具

课程最重要的概念区分：

- Tools 服务模型：Claude 决定什么时候调
- Resources 服务应用：应用自己决定何时读
- Prompts 服务用户：用户触发预定义流程

这是理解 MCP 分工的关键一句。

结合 2026-03-30 官方文档，还需要注意：

- Anthropic 现在有 `MCP connector`，可以直接在 Messages API 里连远程 MCP server。
- 当前 beta header 是 `mcp-client-2025-11-20`。
- 旧的 `mcp-client-2025-04-04` 已弃用。
- 目前 connector 主要支持的是 tool calls，不是整个 MCP 全家桶都完整透传。

MCP 的意义可以概括为：

- 不需要再为每个系统单独设计一套“Claude 如何接入”的方法。

## 7. Claude Code 与 Computer Use

这一部分主要展示 Anthropic 是如何把 Claude 落到具体产品形态里的。

Claude Code 是什么：

- 一个 agentic coding tool
- 能读代码库
- 能改文件
- 能跑命令
- 能和 git、MCP、IDE 联动

这一部分强调的是：

- Claude 不只是“写一段代码”
- 它可以像工程师一样做整段流程：看仓库、改代码、运行、修 bug、提交

课程里还讲了几个更工程化的话题：

- 用 MCP 给 Claude Code 加额外能力
- 用多个 Claude 并行处理任务
- 用 git worktree 规避并行改同一套文件造成冲突
- 自动调试生产错误，例如拉日志、分析、自动修复

Computer Use 是另一条线：

- Claude 看屏幕截图
- 发出鼠标键盘动作
- 你在环境里执行这些动作
- 再把新截图和结果返回给它
- 如此循环，直到任务完成

这就是所谓 agent loop。

这一部分的重点不在于“看起来很强”，而在于：

- 它靠的是截图 -> 判断 -> 动作 -> 新截图 的闭环
- 不是魔法
- 也不是百分百稳定
- 登录场景和网页场景尤其要注意 prompt injection 风险

## 8. Workflows 和 Agents：什么时候适合固定流程，什么时候适合放权

这是整门课里最容易被讲得抽象，但实际上最需要落到工程判断的一部分。

课程的核心结论比较明确：

- 已知步骤时，用 workflow。
- 不知道步骤时，才考虑 agent。

为什么？

- Workflow 更稳
- 更容易测
- 更容易 debug
- 更容易控成本
- 更容易上线

课程讲了 3 种经典 workflow：

- Parallelization
  - 一个复杂任务拆成多个子任务并行做
  - 最后再汇总
  - 适合多角度分析、多个候选方案对比

- Chaining
  - 上一步输出喂下一步
  - 适合长流程任务，比如“找资料 -> 总结 -> 写稿 -> 再润色”

- Routing
  - 先分类，再走不同处理管道
  - 适合“不同类型输入，应该走不同 prompt 或工具”的场景

然后课程再讲 agents：

- agent 适合任务路径不确定的场景
- 它的核心不是“更高级”，而是“更灵活”
- 但灵活通常意味着更难测、更难控、更不稳定

课程最后还特别强调两个 agent 设计原则：

- 工具要抽象、通用，不要碎
- agent 要持续做 environment inspection，也就是不断检查环境状态和动作结果

课程整体立场相对克制：

- 能用 workflow 解决，就优先不用 agent
- 用户最终需要的是可用性，而不是展示感

## 建议记住的 12 句话

- Claude API 最核心就是 `messages.create()`。
- API 本身不记忆，多轮对话要你自己带历史。
- `system` 管行为风格，不是知识库。
- 低 `temperature` 更稳，高 `temperature` 更发散。
- 要好用，不是只写 prompt，要做 eval。
- 好 prompt 的核心是清楚、具体、结构化、有例子。
- tool use 是 Claude 负责决策、应用负责执行，再把结果返回模型。
- RAG 不是让模型记住全部资料，而是先找相关片段再回答。
- 语义检索和关键词检索混合通常更稳。
- MCP 是给 AI 接外部能力的标准协议。
- 已知步骤优先 workflow，未知步骤再考虑 agent。
- 真正可上线的系统，重点永远是稳定、可测、可控。

## 建议的练习顺序

1. 先做一个最简单的单轮 Messages API 调用。
2. 再做一个多轮聊天，把历史自己存起来。
3. 再做一个固定 JSON 输出。
4. 再给这个 prompt 做一个小测试集和自动评分。
5. 再接一个简单工具，比如天气或时间。
6. 再做一个最小 RAG。
7. 最后再碰 MCP、Claude Code、Computer Use、agents。

## 参考链接

- 课程页：<https://anthropic.skilljar.com/claude-with-the-anthropic-api>
- Models overview：<https://docs.anthropic.com/en/docs/models-overview>
- Messages API：<https://docs.anthropic.com/en/api/messages>
- Prompt engineering overview：<https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview>
- Use XML tags：<https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags>
- Multishot prompting：<https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/multishot-prompting>
- Define success criteria：<https://docs.anthropic.com/en/docs/test-and-evaluate/define-success>
- Increase output consistency：<https://docs.anthropic.com/en/docs/test-and-evaluate/strengthen-guardrails/increase-consistency>
- Tool use overview：<https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/overview>
- Implement tool use：<https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/implement-tool-use>
- Web search tool：<https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/web-search-tool>
- Text editor tool：<https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/text-editor-tool>
- Code execution tool：<https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/code-execution-tool>
- Message Batches：<https://docs.anthropic.com/en/api/creating-message-batches>
- Embeddings：<https://docs.anthropic.com/en/docs/build-with-claude/embeddings>
- Extended thinking：<https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking>
- Vision：<https://docs.anthropic.com/en/docs/build-with-claude/vision>
- PDF support：<https://docs.anthropic.com/en/docs/build-with-claude/pdf-support>
- Citations：<https://docs.anthropic.com/en/docs/build-with-claude/citations>
- Prompt caching：<https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching>
- Files API：<https://docs.anthropic.com/en/docs/build-with-claude/files>
- What is MCP：<https://docs.anthropic.com/en/docs/mcp>
- MCP connector：<https://docs.anthropic.com/en/docs/agents-and-tools/mcp-connector>
- Claude Code overview：<https://docs.anthropic.com/en/docs/claude-code/overview>
- Claude Code MCP：<https://docs.anthropic.com/en/docs/claude-code/mcp>
- Computer use：<https://docs.anthropic.com/en/docs/agents-and-tools/computer-use>
