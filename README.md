# textwrap.mbt

MoonBit 文本换行与排版工具集：底层提供 Unicode **UAX #14** 换行点计算，上层提供 [textwrap](https://github.com/mgeisler/textwrap) 风格的段落包装、填充、缩进与省略号截断。宽度测量复用 [moonbit-community/unicodewidth](https://github.com/moonbit-community/unicodewidth.mbt)（UAX #11），定位为 moonbit-community 现有 Unicode 栈（`bidi` / `unicodewidth` / `displaytext`）之上缺失的整段排版层。

> **状态：骨架阶段（skeleton）。** 公共 API 已定型，UAX #14 完整状态机与表生成器开发中，见下方路线图。

## 模块结构

| 模块 | 说明 | 发布名 |
| --- | --- | --- |
| `linebreak/` | UAX #14 换行点计算，表由 UCD `LineBreak.txt`（Unicode 16.0.0）生成 | `GuoXBQ-Q/linebreak` |
| `textwrap/` | 段落包装层：`wrap` / `fill` / `indent` / `truncate` | `GuoXBQ-Q/textwrap` |

本仓库使用 `moon.work` 工作区（monorepo），两个模块独立发布到 mooncakes.io。

## 快速开始

```bash
moon check                        # 类型检查
moon test                         # 运行全部测试
moon run linebreak/examples/basic # 换行点示例
moon run textwrap/examples/demo   # 包装层示例
```

### 使用示例

```moonbit
// 换行点计算（UAX #14）
for (pos, kind) in @linebreak.linebreaks(text) {
  // kind is Mandatory / Allowed
}

// 段落包装（宽度感知，支持 CJK）
let lines = @textwrap.wrap("The quick brown fox jumps", width=24)
let block = @textwrap.fill("中文 混排 文本", width=12, cjk=true)
let short = @textwrap.truncate(long_text, width=20)
```

## 路线图

- [x] 工作区骨架与公共 API 设计
- [x] 强制换行（LB4/LB5：BK / LF / CR，CRLF 保持整体）
- [ ] `tools/gen`：UCD `LineBreak.txt` → MoonBit 断行类别表与状态机表生成器
- [ ] UAX #14 完整 pair-table 状态机（`Allowed` 换行机会）
- [ ] UCD `LineBreakTest.txt` 官方一致性测试全量通过
- [ ] 字素安全的断词与截断（依赖 `kawaz/grapheme`）
- [ ] 长单词强制断行；连字符断词（hyphenation，stretch goal）
- [ ] 三平台 CI（已配置）与发布到 mooncakes.io

## 移植来源与致谢

- [unicode-linebreak](https://github.com/axelf4/unicode-linebreak)（Apache-2.0）：UAX #14 算法与状态机表设计来源
- [textwrap](https://github.com/mgeisler/textwrap)（MIT）：包装层 API 与断行策略参考
- [moonbit-community/unicodewidth](https://github.com/moonbit-community/unicodewidth.mbt)（Apache-2.0）：UAX #11 宽度测量（运行时依赖）
- [kawaz/grapheme](https://github.com/kawaz/grapheme.mbt)（MIT）：UAX #29 字素分段（计划依赖）
- [UCD](https://www.unicode.org/)（Unicode License）：`LineBreak.txt` 与 `LineBreakTest.txt` 数据文件

## 许可证

Apache-2.0（见 [LICENSE](LICENSE)）。

## 模块命名

模块发布名为 `GuoXBQ-Q/linebreak` 与 `GuoXBQ-Q/textwrap`，与 GitHub 仓库 `GuoXBQ-Q/textwrap.mbt` 对应；`moon.mod` 的 `name`、`repository` 字段和各 `moon.pkg` 的 import 路径均使用同一 owner。
