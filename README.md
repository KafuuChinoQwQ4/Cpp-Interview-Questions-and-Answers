# C++ 面经八股

一份面向 C++、后端与 AI 工程面试复习的中文题库，按主题整理常见知识点，并提供较详细的参考答案与带注释的伪代码示例。

## 内容概览

文档共整理 **915 道题**。最初的 555 道题经计算机基础与后端栏目补充后增至 809 道，大模型六栏目再新增 80 道；本轮核对七个图解系列的 162 个栏目页面入口，其中有效技术文章 144 篇，去重后新增 26 道，并补强 86 道已有答案。此前累计核对的 1,010 条面试来源问题单独计量，不与图解文章篇数相加；相同或相近考点优先合并回已有题。题目涵盖：

- C++ 基础、面向对象、内存管理与现代 C++
- 并发与线程安全、性能优化、编译链接与工程实践
- CPU 与数值表示、操作系统与 Linux 内存管理、计算机网络
- 数据库与缓存、消息队列
- 系统设计与分布式、数据结构与算法
- Python、Linux 命令、Git、Docker 与后端进阶架构
- Qt、OpenCV、音视频与 FFmpeg
- Agent、RAG、LLM 工具调用、大模型工程、LangChain 与 AI 编程

适合按章节复习，也可通过 PDF 中的可点击目录跳转。对适合代码说明的题目，文档提供了中文注释伪代码；C++ 标准库名称使用完整的 `std::` 限定。

## 文件

- [Typst 源文件](Cpp-Interview-Questions-and-Answers.typ)：可编辑的原稿，包含题目、答案、目录和参考文献。
- [PDF 版本](Cpp-Interview-Questions-and-Answers.pdf)：适合阅读和打印。

## 重新生成 PDF

安装 [Typst](https://typst.app/) 后，在项目目录运行：

```sh
typst compile "Cpp-Interview-Questions-and-Answers.typ" "Cpp-Interview-Questions-and-Answers.pdf"
```

正文使用 **Noto Sans CJK SC**，代码块使用 **Noto Sans Mono CJK SC**，让中文代码注释保持清晰端正。若本机缺少这些字体，可安装后编译，或在 Typst 源文件中替换字体设置。

## 参考资料

文档末尾列出了 C++ 工作草案、官方手册、IETF RFC、数据库/消息系统与平台文档等技术资料。计算机基础与后端的 14 个栏目入口页、76 篇后端文章正文，以及大模型六栏目的 124 道题目正文均已通过 Windows 原生 Google Chrome 读取；来源问法与题库题目逐项比对，新增答案以独立表述整理。具体行为与 API 细节请结合目标语言标准、库版本和平台文档核对。

本轮补充来源为[图解网络](https://www.xiaolincoding.com/network/)、[图解系统](https://www.xiaolincoding.com/os/)、[图解 MySQL](https://www.xiaolincoding.com/mysql/)、[图解 Redis](https://www.xiaolincoding.com/redis/)、[图解 Agent](https://xiaolinnote.com/agent/)、[图解 Claude Code](https://xiaolinnote.com/claudecode/)及[图解 Codex](https://xiaolinnote.com/codex/)，读取方式同为用户已验证的 Windows 原生 Google Chrome。目录、学习方法、重复旧路径和未成文占位页不计新增题。
