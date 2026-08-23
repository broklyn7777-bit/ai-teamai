# Zed 编辑器完全指南 — 全栈 / Java / Python 开发者实用手册

> 生成日期：2026-08-02 | 来源：Zed 官方文档、GitHub 仓库、迁移指南 | 适用版本：v0.197+  
> 平台：Windows / macOS / Linux（本文快捷键以 **Windows** 为准，macOS 用 `Ctrl→Cmd`、`Alt→Opt` 替换即可）

---

1. [核心特点与架构](#1-核心特点与架构)
2. [安装与初始化](#2-安装与初始化)
3. [界面布局与面板系统](#3-界面布局与面板系统)
4. [常用快捷键速查表](#4-常用快捷键速查表)
5. [配置系统详解](#5-配置系统详解)
6. [Java 开发完整配置](#6-java-开发完整配置)
7. [Python 开发完整配置](#7-python-开发完整配置)
8. [任务系统 (Tasks)](#8-任务系统-tasks)
9. [调试器](#9-调试器)
10. [Git 集成](#10-git-集成)
11. [AI 功能](#11-ai-功能)
12. [Vim 模式](#12-vim-模式)
13. [扩展系统](#13-扩展系统)
14. [从 IntelliJ/VS Code 迁移](#14-从-intellijvs-code-迁移)
15. [性能对比与适用场景](#15-性能对比与适用场景)
16. [实战配置模板](#16-实战配置模板)

---

## 1. 核心特点与架构

### 1.1 为什么选择 Zed

| 特性 | Zed | VS Code | IntelliJ IDEA |
|------|-----|---------|---------------|
| **启动速度** | <1s，无需索引 | 2-5s | 30s-15min（索引） |
| **语言** | Rust（GPU 加速渲染） | Electron | JVM |
| **内存占用** | 200-400MB | 500MB-1GB | 1-4GB |
| **协作** | 内置实时协作 + 语音 | 需 Live Share 插件 | 需 Code With Me 插件 |
| **AI** | 内置，多模型支持 | 需 Copilot 插件 | 需 JetBrains AI 插件 |
| **项目模型** | 文件夹即项目，零配置 | .vscode/ 目录 | .idea/ + .iml 复杂模型 |
| **扩展数量** | 较少，专注核心 | 海量 | 海量 |

### 1.2 架构要点

```
┌─────────────────────────────────────────┐
│              Zed Editor                  │
├──────────┬──────────┬──────────┬────────┤
│ 编辑器    │ 终端      │ AI Agent │ Git    │
│ (GPU渲染) │ (内置)    │ (内置)    │ (内置) │
├──────────┴──────────┴──────────┴────────┤
│           Tree-sitter (语法解析)          │
├─────────────────────────────────────────┤
│       LSP (语言服务器协议) 客户端          │
│   jdtls(Java) | typescript-language-     │
│   server | rust-analyzer | ...           │
├─────────────────────────────────────────┤
│       DAP (调试适配器协议) 客户端          │
│   Java Debug | CodeLLDB | Debugpy | ... │
├─────────────────────────────────────────┤
│           协作引擎 (CRDT)                 │
└─────────────────────────────────────────┘
```

**关键概念：**
- **无索引**：打开文件夹即工作，文件搜索和导航即时可用
- **LSP 驱动**：代码智能完全委托给语言服务器（Java → jdtls）
- **Tree-sitter**：语法感知选择、折叠、导航
- **DAP 协议**：跨语言统一调试

### 1.3 Zed 不适合的场景

- 深度 Spring/Jakarta EE 框架感知（IntelliJ 的强项）
- 复杂 JVM 重构（提取接口、上移成员等）
- 需要数据库客户端集成（需外挂 DataGrip/DBeaver）
- 需要应用服务器集成

---

## 2. 安装与初始化

### 2.1 Windows 安装

```powershell
# 方式一：winget
winget install Zed.Zed

# 方式二：官网下载安装包
# https://zed.dev/download
```

### 2.2 启动方式

```powershell
# 打开当前目录
zed .

# 打开指定项目
zed C:\projects\my-java-app

# 新窗口打开
zed -n C:\projects\another-project
```

### 2.3 首次配置清单

1. **选择基础键位映射**：`Ctrl+,` → 搜索 `Base Keymap` → 选择 `JetBrains`（Java 开发者推荐）
2. **安装 Java 扩展**：`Ctrl+Shift+X` → 搜索 `java` → Install
3. **配置 JDK**：确保 `JAVA_HOME` 指向 JDK 21+（jdtls 需要）
4. **配置 AI**（可选）：`Ctrl+,` → AI → Edit Predictions → Configure

---

## 3. 界面布局与面板系统

### 3.1 面板布局

```
┌──────────┬───────────────────────────┬──────────┐
│          │                           │          │
│  左 Dock  │        编辑区域            │  右 Dock  │
│          │    (一个或多个 Pane)        │          │
│ ·项目面板 │                           │ ·Agent   │
│ ·协作面板 │   ┌───────┬───────┐      │ ·通知    │
│ ·Git面板  │   │Pane 1 │Pane 2 │      │          │
│          │   │       │       │      │          │
│          │   └───────┴───────┘      │          │
├──────────┴───────────────────────────┴──────────┤
│                  底部 Dock                        │
│  ·终端  ·调试器  ·诊断  ·搜索                      │
└─────────────────────────────────────────────────┘
```

### 3.2 面板切换快捷键

| 面板 | 快捷键 | 命令 |
|------|--------|------|
| 项目文件树 | `Ctrl+Shift+E` | `project_panel::ToggleFocus` |
| Git 面板 | `Ctrl+Shift+G` | `git_panel::ToggleFocus` |
| 大纲面板 | `Ctrl+Shift+B` | `outline_panel::ToggleFocus` |
| 调试面板 | `Ctrl+Shift+D` | `debug_panel::ToggleFocus` |
| 终端面板 | `Ctrl+`` ` | `terminal_panel::Toggle` |
| Agent 面板 | `Ctrl+Shift+/` | `agent::ToggleFocus` |
| 诊断窗口 | `Ctrl+Shift+M` | `diagnostics::Deploy` |
| 左 Dock 整体 | `Ctrl+B` | `workspace::ToggleLeftDock` |
| 底部 Dock 整体 | `Ctrl+J` | `workspace::ToggleBottomDock` |
| 右 Dock 整体 | `Ctrl+Alt+B` | `workspace::ToggleRightDock` |
| 所有 Dock | `Ctrl+Shift+Y` | `workspace::ToggleAllDocks` |

### 3.3 两种布局模式

- **Agentic 布局**：Agent Panel + Threads Sidebar 在左侧相邻 — 适合 AI 驱动开发
- **Classic 布局**：以编辑器为中心的传统布局

切换方式：标题栏用户菜单 → Panel Layout

---

## 4. 常用快捷键速查表

### 4.1 基础操作（必须记住）

| 操作 | 快捷键 | 备注 |
|------|--------|------|
| **命令面板** | `Ctrl+Shift+P` | 一切功能的入口 |
| **文件搜索** | `Ctrl+P` | 模糊匹配文件名 |
| **符号搜索** | `Ctrl+T` | 项目级符号搜索 |
| **当前文件符号** | `Ctrl+Shift+O` | 文件内方法/类列表 |
| **全文搜索** | `Ctrl+Shift+F` | 项目级文本搜索 |
| **全文替换** | `Ctrl+Shift+H` | 项目级搜索替换 |
| **跳转到行** | `Ctrl+G` | 输入行号 |
| **打开设置** | `Ctrl+,` | 可视化设置编辑器 |
| **打开设置文件** | `Ctrl+Alt+,` | 直接编辑 settings.json |
| **打开键位文件** | `Ctrl+K Ctrl+S` | 键位编辑器 |
| **打开扩展** | `Ctrl+Shift+X` | 扩展管理 |

### 4.2 编辑操作

| 操作 | 快捷键 |
|------|--------|
| 保存 | `Ctrl+S` |
| 另存为 | `Ctrl+Shift+S` |
| 撤销 | `Ctrl+Z` |
| 重做 | `Ctrl+Y` 或 `Ctrl+Shift+Z` |
| 剪切行 | `Ctrl+X`（无选中时） |
| 复制行 | `Shift+Alt+↑/↓` |
| 移动行 | `Alt+↑/↓` |
| 删除行 | `Ctrl+Shift+K` |
| 在下方新行 | `Ctrl+Enter` |
| 在上方新行 | `Ctrl+Shift+Enter` |
| 向上缩进 | `Ctrl+]` |
| 向下缩进 | `Ctrl+[` |
| 格式化 | `Shift+Alt+F` |
| 整理导入 | `Shift+Alt+O` |
| 切换注释 | `Ctrl+/` |
| 块注释 | `Shift+Alt+A` |
| 选择所有匹配 | `Ctrl+Shift+L` |
| 选择下一个匹配 | `Ctrl+D` |

### 4.3 导航操作

| 操作 | 快捷键 |
|------|--------|
| 跳转定义 | `F12` |
| 跳转实现 | `Ctrl+F12` |
| 查找引用 | `Shift+Alt+F12` |
| 重命名符号 | `F2` |
| 前进/后退 | `Alt+→` / `Alt+←` |
| 最近文件 | `Ctrl+Tab` |
| 打开文件历史 | 右键文件 → View File History |
| 下一个诊断 | `F8` |
| 上一个诊断 | `Shift+F8` |
| 转到代码操作 | `Ctrl+.` |
| 显示签名帮助 | `Ctrl+I` |
| 悬停信息 | `Ctrl+K Ctrl+I` |

### 4.4 多光标 & 选择

| 操作 | 快捷键 |
|------|--------|
| 在上方添加光标 | `Ctrl+Alt+↑` |
| 在下方添加光标 | `Ctrl+Alt+↓` |
| 扩大语法选择 | `Shift+Alt+→` |
| 缩小语法选择 | `Shift+Alt+←` |
| 选择 enclosing symbol | `Shift+Alt+E` |

### 4.5 搜索 & 替换（在搜索栏中）

| 操作 | 快捷键 |
|------|--------|
| 聚焦搜索框 | `Ctrl+F` |
| 切换替换 | `Ctrl+H` |
| 全部替换 | `Ctrl+Enter`（替换模式下） |
| 选择所有匹配 | `Alt+Enter` |
| 切换正则 | `Alt+R` |
| 切换大小写 | `Alt+C` |
| 切换全词 | `Alt+W` |
| 切换选区过滤 | `Alt+L` |

### 4.6 面板 & 分屏

| 操作 | 快捷键 |
|------|--------|
| 向右分屏 | `Ctrl+\` |
| 向上分屏 | `Ctrl+K ↑` |
| 向下分屏 | `Ctrl+K ↓` |
| 向左分屏 | `Ctrl+K ←` |
| 向右分屏 | `Ctrl+K →` |
| 切换到窗格 1-9 | `Alt+1` ~ `Alt+9` |
| 切换到最后一个窗格 | `Alt+0` |
| 聚焦左侧窗格 | `Ctrl+K Ctrl+←` |
| 聚焦右侧窗格 | `Ctrl+K Ctrl+→` |
| 交换窗格（左） | `Ctrl+K Shift+←` |
| 交换窗格（右） | `Ctrl+K Shift+→` |
| 关闭活动标签 | `Ctrl+F4` 或 `Ctrl+W` |
| 关闭左侧标签 | `Ctrl+K E` |
| 关闭右侧标签 | `Ctrl+K T` |

### 4.7 代码折叠

| 操作 | 快捷键 |
|------|--------|
| 折叠 | `Ctrl+Shift+[` |
| 展开 | `Ctrl+Shift+]` |
| 递归折叠 | `Ctrl+K Ctrl+[` |
| 递归展开 | `Ctrl+K Ctrl+]` |
| 折叠到级别 1-9 | `Ctrl+K Ctrl+1` ~ `Ctrl+K Ctrl+9` |
| 全部折叠 | `Ctrl+K Ctrl+0` |
| 全部展开 | `Ctrl+K Ctrl+J` |
| 切换折叠 | `Ctrl+K Ctrl+L` |

### 4.8 终端

| 操作 | 快捷键 |
|------|--------|
| 新建终端 | `Ctrl+Shift+`` ` |
| 复制 | `Ctrl+Shift+C` 或 `Ctrl+Insert` |
| 粘贴 | `Ctrl+Shift+V` 或 `Shift+Insert` |
| 清除 | `Ctrl+Shift+L` |
| 切换 Vi 模式 | `Ctrl+Shift+Space` |
| 拆分（右） | `Ctrl+Shift+5` |

---

## 5. 配置系统详解

### 5.1 配置文件位置

| 平台 | settings.json | keymap.json | tasks.json |
|------|--------------|-------------|------------|
| Windows | `%APPDATA%\Zed\settings.json` | `%APPDATA%\Zed\keymap.json` | `%APPDATA%\Zed\tasks.json` |
| macOS | `~/Library/Application Support/Zed/settings.json` | 同目录 `keymap.json` | 同目录 |
| Linux | `~/.config/zed/settings.json` | 同目录 | 同目录 |

### 5.2 项目级配置

在项目根目录创建 `.zed/settings.json`，覆盖全局设置：

```jsonc
// .zed/settings.json
{
  "format_on_save": "on",
  "tab_size": 4,
  "languages": {
    "Java": {
      "tab_size": 4,
      "format_on_save": "on"
    }
  }
}
```

### 5.3 常用设置项速查

```jsonc
{
  // === 编辑器 ===
  "base_keymap": "JetBrains",          // 基础键位：VS Code/JetBrains/Emacs/Sublime
  "vim_mode": false,                    // Vim 模式
  "buffer_font_family": "Zed Mono",    // 编辑器字体
  "buffer_font_size": 14,              // 字号
  "tab_size": 4,                       // Tab 宽度
  "hard_tabs": false,                  // true=用真 Tab，false=用空格
  "format_on_save": "on",             // 保存时格式化
  "soft_wrap": "editor_width",        // 自动换行: none/editor_width/preferred_line_length
  "preferred_line_length": 120,        // 换行/标尺列宽
  "relative_line_numbers": false,      // 相对行号
  "inlay_hints": {                     // 内联提示（参数名、类型）
    "enabled": "on"
  },
  "scrollbar": {
    "show": "auto"
  },
  "minimap": {
    "show": "always"                   // 小地图
  },
  "indent_guides": {
    "enabled": "on"                    // 缩进参考线
  },
  "wrap_guides": [120],               // 换行参考线
  "show_whitespaces": "selection",     // 显示空白字符
  "sticky_scroll": {
    "enabled": true                    // 粘性滚动（方法头固定）
  },
  
  // === 自动保存 ===
  "autosave": "on_focus_change",      // off/on_focus_change/on_window_change/after_delay
  
  // === 自动补全 ===
  "show_completions_on_input": true,
  "completions": {
    "words": true
  },
  
  // === 文件 ===
  "ensure_final_newline_on_save": true,
  "remove_trailing_whitespace_on_save": true,
  
  // === 主题 ===
  "theme": "One Dark",
  
  // === 终端 ===
  "terminal": {
    "font_size": 13,
    "line_height": 1.3,
    "cursor_shape": "block",
    "blinking": "on",
    "copy_on_select": true,
    "max_scroll_history_lines": 10000
  },
  
  // === Git ===
  "git": {
    "inline_blame": {
      "enabled": true
    }
  },
  
  // === 调试器 ===
  "debugger": {
    "dock": "bottom",
    "stepping_granularity": "line",
    "save_breakpoints": true
  }
}
```

---

## 6. Java 开发完整配置

### 6.1 环境要求

- **OpenJDK 21+**（jdtls 运行需要）：`choco install openjdk`
- **项目 JDK**：可以是更低版本（如 JDK 8/11/17），通过 `java_home` 配置指定

### 6.2 安装 Java 扩展

```
Ctrl+Shift+X → 搜索 "java" → Install Zed Java
```

扩展会自动下载并运行 Eclipse JDTLS（Eclipse Java 语言服务器）。

### 6.3 Java LSP 配置

```jsonc
// settings.json 中添加
{
  "lsp": {
    "jdtls": {
      "settings": {
        // ===== 运行环境 =====
        // JDTLS 需要 JDK 21+ 运行，请修改为实际的 JDK 21 安装路径
        // 注意：这是 JDTLS 语言服务器自身的运行 JDK，项目可以使用更低版本
        "java_home": "D:\\soft\\Java\\jdk-21",

        // Lombok 支持：自动下载 lombok.jar 并注册为 Java Agent
        // 开启后 JDTLS 能正确识别 Lombok 生成的 getter/setter/builder 等方法
        "lombok_support": true,

        // 是否自动下载 JDK（如果 java_home 无效时）
        // false = 仅使用本地已安装的 JDK，不自动下载
        "jdk_auto_download": false,

        // JDTLS 堆内存配置
        // 过小会导致大项目索引/补全卡顿，建议至少 1G
        "min_memory": "1G",
        "max_memory": "4G",

        // 检查 JDTLS 扩展更新策略
        // "always" = 每次启动检查 | "once" = 每天一次 | "never" = 不检查
        "check_updates": "always"
      },

      // ===== JDTLS 初始化选项（传递给 Eclipse JDT Language Server） =====
      // 完整参考: https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-language-server
      "initialization_options": {
        "settings": {
          "java": {
            // --- 项目配置 ---
            "configuration": {
              // 构建配置变更时的更新策略
              // "automatic" = 自动更新 | "interactive" = 弹窗确认 | "disabled" = 不更新
              "updateBuildConfiguration": "automatic",

              // 项目可用的 JDK 运行时列表（用于编译级别匹配）
              // name 必须是标准名称: JavaSE-1.8 / JavaSE-11 / JavaSE-17 / JavaSE-21 等
              // 标记 default: true 的作为默认运行时
              "runtimes": [
                {
                  "name": "JavaSE-21",
                  "path": "D:\\soft\\Java\\jdk-21",
                  "default": true
                }
              ],

              // Maven 配置
              "maven": {
                // 自定义 Maven settings.xml 路径（公司内部仓库、代理配置等）
                "userSettings": "D:\\soft\\DEV\\apache-maven-3.9.12\\conf\\settings.xml"
              }
            },

            // --- 保存时动作 ---
            "saveActions": {
              // 保存时自动整理 import（移除未使用的、排序）
              "organizeImports": true
            },

            // --- 引用搜索 ---
            "references": {
              // 搜索结果中包含 getter/setter 等自动生成的访问器方法
              "includeAccessors": true,
              // 当源码不可用时，在搜索结果中包含反编译的类文件
              "includeDecompiledSources": true
            },

            // --- Eclipse 相关 ---
            "eclipse": {
              // 下载依赖的源码（用于跳转进第三方库源码）
              "downloadSources": true
            },

            // --- Maven 行为 ---
            "maven": {
              // 下载依赖源码（配合 eclipse.downloadSources）
              "downloadSources": true,
              // 每次构建时检查 SNAPSHOT 依赖是否有更新
              "updateSnapshots": true
            },

            // --- 自动构建 ---
            "autobuild": {
              // 文件变更时自动增量构建（关闭则需手动触发构建）
              "enabled": true
            },

            // 最大并发构建数（多模块项目时有用）
            "maxConcurrentBuilds": 2,

            // --- 内联提示（Inlay Hints） ---
            "inlayHints": {
              "parameterNames": {
                // 方法调用时显示参数名提示
                // "none" = 关闭 | "literals" = 仅字面量参数 | "all" = 所有参数
                "enabled": "literals"
              }
            },

            // --- 项目导入 ---
            "import": {
              "maven": { "enabled": true },
              "gradle": { "enabled": true },
              // 导入时排除的目录（减少不必要的扫描）
              "exclusions": [
                "**/node_modules/**",
                "**/.metadata/**",
                "**/archetype-resources/**",
                "**/META-INF/maven/**"
              ]
            },

            // --- 代码补全 ---
            "completion": {
              "enabled": true,
              // 静态导入快速成员（在补全中优先显示）
              "favoriteStaticMembers": [
                "org.junit.Assert.*",
                "org.junit.jupiter.api.Assertions.*",
                "org.mockito.Mockito.*",
                "org.mockito.ArgumentMatchers.*",
                "org.apache.commons.lang3.StringUtils.*",
                "com.google.common.collect.Lists.*",
                "com.google.common.collect.Maps.*"
              ],
              // import 排序顺序
              "importOrder": ["java", "javax", "com", "org"],
              // Postfix 补全（如 expr.null → Objects.isNull(expr)）
              "postfix": {
                "enabled": true
              }
            },

            // --- 格式化 ---
            "format": {
              // 启用代码格式化（Shift+Alt+F）
              "enabled": true,
              // 输入时自动格式化（如输入 ; 或 } 后自动格式化当前语句）
              "onType": {
                "enabled": true
              }
            }
          }
        }
      }
    }
  }
}
```

### 6.4 自定义 JDTLS 启动脚本

如果你想完全控制 JDTLS 启动：

1. 创建 `jdtls.bat` 放到 `%PATH%` 中
2. 扩展会检测到并跳过自动下载

### 6.5 Java 调试配置

在项目根目录创建 `.zed/debug.json`：

```jsonc
[
  {
    "adapter": "Java",
    "request": "launch",
    "label": "启动调试器",
    // 如果项目有多个入口，指定主类：
    // "mainClass": "com.mycompany.App",
    "stopOnEntry": true,
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "adapter": "Java",
    "request": "attach",
    "label": "附加到远程进程",
    "hostName": "localhost",
    "port": 5005
  }
]
```

启动调试：`F4`（打开调试配置选择器）→ 选择 "启动调试器"

### 6.6 Java 任务配置

创建 `.zed/tasks.json`（Java 开发者必备）：

```jsonc
[
  // === Maven 项目 ===
  {
    "label": "Maven: 编译",
    "command": "mvn",
    "args": ["compile", "-q"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Maven: 运行",
    "command": "mvn",
    "args": ["spring-boot:run"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Maven: 测试",
    "command": "mvn",
    "args": ["test", "-pl", "$ZED_RELATIVE_DIR"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Maven: 测试当前类",
    "command": "mvn",
    "args": ["test", "-Dtest=$ZED_STEM"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Maven: 打包",
    "command": "mvn",
    "args": ["package", "-DskipTests"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Maven: 清理安装",
    "command": "mvn",
    "args": ["clean", "install", "-DskipTests"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  
  // === Gradle 项目 ===
  {
    "label": "Gradle: 构建",
    "command": "./gradlew",
    "args": ["build"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Gradle: 运行",
    "command": "./gradlew",
    "args": ["bootRun"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Gradle: 测试当前文件",
    "command": "./gradlew",
    "args": ["test", "--tests", "$ZED_STEM"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  
  // === 通用 ===
  {
    "label": "运行当前文件",
    "command": "java",
    "args": ["-cp", "target/classes", "$ZED_RELATIVE_FILE"],
    "cwd": "$ZED_WORKTREE_ROOT"
  }
]
```

**任务操作：**
- 打开任务列表：`Shift+Alt+T`
- 重运行上次任务：`Alt+T`
- 在中心区域运行：`Shift+Alt+R`

### 6.7 任务变量参考

| 变量 | 说明 | 示例 |
|------|------|------|
| `$ZED_FILE` | 当前文件绝对路径 | `C:\project\src\Main.java` |
| `$ZED_FILENAME` | 文件名 | `Main.java` |
| `$ZED_DIRNAME` | 文件所在目录 | `C:\project\src` |
| `$ZED_RELATIVE_FILE` | 相对路径 | `src/Main.java` |
| `$ZED_STEM` | 不含扩展名的文件名 | `Main` |
| `$ZED_WORKTREE_ROOT` | 项目根目录 | `C:\project` |
| `$ZED_ROW` | 当前行号 | `42` |
| `$ZED_COLUMN` | 当前列号 | `15` |
| `$ZED_SYMBOL` | 当前选中符号 | `main > run` |
| `$ZED_SELECTED_TEXT` | 选中的文本 | — |
| `$ZED_LANGUAGE` | 当前语言 | `Java` |


## 7. Python 开发完整配置

### 7.1 环境要求与工具链

| 工具 | 用途 | 安装方式 |
|------|------|----------|
| **Python 3.10+** | 运行环境 | `winget install Python.Python.3.12` |
| **uv** | 超快包管理器（推荐） | `pip install uv` 或 `winget install astral-sh.uv` |
| **pip** | 传统包管理器 | 随 Python 安装 |
| **venv** | 虚拟环境（标准库） | 内置 |
| **conda/miniconda** | 科学计算环境 | `winget install Anaconda.Miniconda3` |
| **poetry** | 依赖管理 + 打包 | `pip install poetry` |

### 7.2 安装 Python 扩展

````
Ctrl+Shift+X → 搜索 "python" → Install Python
````

扩展会自动配置 Pyright 语言服务器和 Debugpy 调试适配器。

### 7.3 Python LSP 配置（Pyright）

```jsonc
// settings.json 中添加
{
  "lsp": {
    "pyright": {
      "settings": {
        "python": {
          // Python 解释器路径（推荐使用虚拟环境）
          "pythonPath": ".venv/Scripts/python.exe",
          // 或使用 uv 管理的虚拟环境
          // "pythonPath": ".venv/.venv/Scripts/python.exe",
          
          // 分析设置
          "analysis": {
            "typeCheckingMode": "basic",  // off/basic/strict
            "autoSearchPaths": true,
            "useLibraryCodeForTypes": true,
            "diagnosticMode": "workspace",  // openFilesOnly/workspace
            
            // 严格检查（可选，适合新项目）
            // "strict": ["src/**"],
            
            // 忽略的目录
            "exclude": [
              "**/node_modules",
              "**/__pycache__",
              "**/.venv",
              "**/.tox",
              "**/dist"
            ]
          }
        }
      }
    }
  }
}
````

### 7.4 格式化器与 Linter 配置

推荐使用 **Ruff**（超快，替代 black + isort + flake8）：

```jsonc
// settings.json 中添加
{
  "languages": {
    "Python": {
      "tab_size": 4,
      "format_on_save": "on",
      "formatter": "language_server",
      "code_actions_on_format": {
        "source.organizeImports": true
      }
    }
  },
  
  // 使用 Ruff 作为格式化器
  "lsp": {
    "ruff": {
      "settings": {
        // Ruff 配置
        "args": [
          "--line-length=120",
          "--target-version=py310"
        ]
      }
    }
  }
}
````

**项目级 Ruff 配置**（`pyproject.toml`）：

```toml
[tool.ruff]
line-length = 120
target-version = "py310"

[tool.ruff.lint]
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "UP",  # pyupgrade
    "B",   # flake8-bugbear
    "C4",  # flake8-comprehensions
    "RUF", # ruff-specific
]
ignore = [
    "E501",  # 行长度由 formatter 处理
]

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
line-ending = "auto"
```

### 7.5 Python 调试配置

在项目根目录创建 `.zed/debug.json`：

```jsonc
[
  {
    "adapter": "Debugpy",
    "request": "launch",
    "label": "调试当前文件",
    "program": "$ZED_FILE",
    "cwd": "$ZED_WORKTREE_ROOT",
    // 使用虚拟环境的 Python
    "python": ".venv/Scripts/python.exe",
    "justMyCode": true,
    "env": {
      "PYTHONPATH": "$ZED_WORKTREE_ROOT/src"
    }
  },
  {
    "adapter": "Debugpy",
    "request": "launch",
    "label": "调试 Python 模块",
    "module": "myapp.cli",
    "cwd": "$ZED_WORKTREE_ROOT",
    "python": ".venv/Scripts/python.exe"
  },
  {
    "adapter": "Debugpy",
    "request": "launch",
    "label": "运行 pytest 调试",
    "module": "pytest",
    "args": ["-xvs", "$ZED_FILE"],
    "cwd": "$ZED_WORKTREE_ROOT",
    "python": ".venv/Scripts/python.exe"
  },
  {
    "adapter": "Debugpy",
    "request": "attach",
    "label": "附加到运行中的进程",
    "connect": {
      "host": "localhost",
      "port": 5678
    },
    "justMyCode": true
  },
  {
    "adapter": "Debugpy",
    "request": "launch",
    "label": "FastAPI 调试",
    "module": "uvicorn",
    "args": ["main:app", "--reload", "--port", "8000"],
    "cwd": "$ZED_WORKTREE_ROOT",
    "python": ".venv/Scripts/python.exe",
    "env": {
      "PYTHONPATH": "$ZED_WORKTREE_ROOT/src"
    }
  }
]
````

启动调试：`F4` → 选择配置

### 7.6 Python 任务配置

创建 `.zed/tasks.json`（Python 开发者必备）：

```jsonc
[
  // === uv（推荐，超快） ===
  {
    "label": "Python: uv 安装依赖",
    "command": "uv",
    "args": ["sync"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Python: uv 添加包",
    "command": "uv",
    "args": ["add", "$ZED_SELECTED_TEXT"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Python: uv run 当前文件",
    "command": "uv",
    "args": ["run", "python", "$ZED_RELATIVE_FILE"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  
  // === pytest ===
  {
    "label": "Python: pytest 全部",
    "command": "uv",
    "args": ["run", "pytest", "-xvs"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Python: pytest 当前文件",
    "command": "uv",
    "args": ["run", "pytest", "-xvs", "$ZED_RELATIVE_FILE"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Python: pytest 当前方法",
    "command": "uv",
    "args": ["run", "pytest", "-xvs", "$ZED_RELATIVE_FILE::$ZED_SYMBOL"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Python: pytest 带覆盖率",
    "command": "uv",
    "args": ["run", "pytest", "--cov=src", "--cov-report=term-missing"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  
  // === 代码质量 ===
  {
    "label": "Python: ruff 格式化",
    "command": "uv",
    "args": ["run", "ruff", "format", "."],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Python: ruff 检查",
    "command": "uv",
    "args": ["run", "ruff", "check", ".", "--fix"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Python: mypy 类型检查",
    "command": "uv",
    "args": ["run", "mypy", "src/"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  
  // === FastAPI / Uvicorn ===
  {
    "label": "Python: FastAPI 开发服务器",
    "command": "uv",
    "args": ["run", "uvicorn", "main:app", "--reload", "--port", "8000"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Python: Uvicorn 生产模式",
    "command": "uv",
    "args": ["run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  
  // === 传统 pip/venv（兼容） ===
  {
    "label": "Python: pip 安装依赖",
    "command": ".venv/Scripts/pip",
    "args": ["install", "-r", "requirements.txt"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Python: 运行当前文件",
    "command": ".venv/Scripts/python",
    "args": ["$ZED_RELATIVE_FILE"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  
  // === 虚拟环境管理 ===
  {
    "label": "Python: 创建 venv",
    "command": "python",
    "args": ["-m", "venv", ".venv"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "label": "Python: 创建 uv venv",
    "command": "uv",
    "args": ["venv", "--python", "3.12"],
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  
  // === 项目管理 ===
  {
    "label": "Python: 导出 requirements",
    "command": "uv",
    "args": ["pip", "freeze", ">", "requirements.txt"],
    "cwd": "$ZED_WORKTREE_ROOT",
    "shell": "system"
  }
]
```

**任务操作：**
- 打开任务列表：`Shift+Alt+T`
- 重运行上次任务：`Alt+T`

### 7.7 Python 项目结构建议

````
my-python-project/
├── .zed/                    # Zed 配置
│   ├── settings.json        # 项目级设置
│   ├── tasks.json           # 任务定义
│   └── debug.json           # 调试配置
├── src/                     # 源代码
│   └── myapp/
│       ├── __init__.py
│       ├── main.py
│       └── ...
├── tests/                   # 测试
│   ├── __init__.py
│   └── test_main.py
├── .venv/                   # 虚拟环境（gitignore）
├── pyproject.toml           # 项目配置（推荐）
├── requirements.txt         # 或传统依赖文件
├── .python-version          # Python 版本（uv 使用）
└── README.md
````

### 7.8 uv 最佳实践

**uv** 是新一代 Python 包管理器，比 pip 快 10-100 倍：

```powershell
# 创建新项目
uv init my-project
cd my-project

# 添加依赖
uv add fastapi uvicorn

# 运行脚本（自动使用项目虚拟环境）
uv run python main.py

# 同步依赖（类似 npm install）
uv sync

# 运行工具
uv run pytest
uv run ruff check .
uv run mypy src/

# 锁定依赖
uv lock

# 升级依赖
uv lock --upgrade
```

**pyproject.toml 配置示例**：

```toml
[project]
name = "my-project"
version = "0.1.0"
description = "My Python project"
requires-python = ">=3.10"
dependencies = [
    "fastapi>=0.100.0",
    "uvicorn>=0.23.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "ruff>=0.1.0",
    "mypy>=1.0",
]

[tool.uv]
dev-dependencies = [
    "pytest>=7.0",
    "ruff>=0.1.0",
    "mypy>=1.0",
    "pre-commit>=3.0",
]
```

### 7.9 Python 常见问题

**Q: Pyright 找不到模块？**

1. 确认虚拟环境已创建且已激活
2. 检查 `settings.json` 中 `pythonPath` 配置正确
3. 在项目根目录创建 `.python-version` 文件指定版本

**Q: 如何在 Zed 终端中激活虚拟环境？**

Zed 终端默认不会自动激活虚拟环境。两种解决方案：

1. **使用 uv run**（推荐）：任务中直接用 `uv run` 执行，无需激活
2. **配置终端自动激活**：在 PowerShell 的 `$PROFILE` 中添加自动检测逻辑

**Q: 调试时断点不生效？**

1. 确认 `debugpy` 已安装：`uv add debugpy`
2. 检查 `.zed/debug.json` 中 Python 路径是否正确
3. 确保使用的是虚拟环境的 Python 解释器

---

## 8. 任务系统 (Tasks)

### 8.1 任务定义位置

| 位置 | 范围 | 打开方式 |
|------|------|----------|
| `~/.config/zed/tasks.json` | 全局 | `zed: open tasks` |
| `.zed/tasks.json` | 项目级 | `zed: open project tasks` |
| 命令面板直接输入 | 一次性 | `Shift+Alt+T` → 输入命令 |

### 8.2 任务完整配置示例

```jsonc
[
  {
    "label": "启动 Spring Boot",
    "command": "mvn",
    "args": ["spring-boot:run", "-Dspring-boot.run.jvmArguments=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"],
    "cwd": "$ZED_WORKTREE_ROOT",
    "env": { "SPRING_PROFILES_ACTIVE": "dev" },
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "always",       // always/no_focus/never
    "hide": "never",          // never/always/on_success
    "save": "all",            // 运行前保存：all/current/none
    "shell": "system"
  }
]
```

### 8.3 任务钩子 (Hooks)

```jsonc
[
  {
    "label": "复制 .env 到新 worktree",
    "command": "cp",
    "args": ["$ZED_MAIN_GIT_WORKTREE/.env", "$ZED_WORKTREE_ROOT/.env"],
    "hooks": ["create_worktree"],
    "reveal": "no_focus",
    "hide": "on_success"
  }
]
```

### 8.4 自定义任务快捷键

```jsonc
// keymap.json
{
  "context": "Workspace",
  "bindings": {
    "alt-m": ["task::Spawn", { "task_name": "Maven: 编译" }],
    "alt-r": ["task::Spawn", { "task_name": "Maven: 运行" }],
    "alt-t": ["task::Spawn", { "task_name": "Maven: 测试当前类" }]
  }
}
```

---

## 9. 调试器

### 9.1 调试操作速查

| 操作 | 快捷键 |
|------|--------|
| 启动调试 | `F4` |
| 继续/暂停 | `F5` |
| 单步跳过 | `F10` |
| 单步进入 | `F11` |
| 单步跳出 | `Shift+F11` |
| 停止调试 | `Shift+F5` |
| 重新运行 | `F5`（调试器停止时） |
| 切换断点 | `F9` |
| 编辑日志断点 | `Shift+F9` |

### 9.2 断点类型

- **普通断点**：点击行号左侧
- **条件断点**：右键断点 → Add Condition
- **日志断点**：右键断点 → Edit Log Breakpoint（命中时输出消息而不暂停）
- **命中次数断点**：右键断点 → Add Hit Count

### 9.3 调试面板

`Ctrl+Shift+D` 打开调试面板，显示：
- 变量列表（局部变量 + Watch）
- 调用栈
- 断点管理
- 调试控制台

### 9.4 调试前自动构建

```jsonc
// .zed/debug.json
[
  {
    "label": "编译并调试",
    "adapter": "Java",
    "request": "launch",
    "mainClass": "com.mycompany.App",
    "build": {
      "command": "mvn",
      "args": ["compile", "-q"]
    }
  }
]
```

---

## 10. Git 集成

### 10.1 Git 操作速查

| 操作 | 快捷键 |
|------|--------|
| 打开 Git 面板 | `Ctrl+Shift+G` |
| 项目 Diff | `Ctrl+G D` |
| 暂存并下一个 | `Alt+Y` |
| 取消暂存并下一个 | `Shift+Alt+Y` |
| 暂存所有 | `Ctrl+Space` |
| 取消暂存所有 | `Ctrl+Shift+Space` |
| 提交 | `Ctrl+Enter` |
| 修改提交 | `Ctrl+Shift+Enter` |
| 生成提交消息（AI） | `Alt+L`（在提交编辑器中） |
| Fetch | `Ctrl+G Ctrl+G` |
| Push | `Ctrl+G ↑` |
| Pull | `Ctrl+G ↓` |
| Pull Rebase | `Ctrl+G Shift+↓` |
| Force Push | `Ctrl+G Shift+↑` |
| 还原文件 | `Ctrl+K Ctrl+R`（在编辑器中） |
| 打开修改文件 | `Alt+G M` |
| Git Blame | `Alt+G B` |

### 10.2 Git 面板功能

- **Changes 标签**：显示工作区变更
- **History 标签**：显示提交历史
- **树形/列表视图**：右键切换
- **Stash 管理**：通过面板溢出菜单
- **分支管理**：`Shift+Alt+B`
- **Worktree 管理**：`Shift+Alt+W`

### 10.3 合并冲突处理

冲突文件会高亮显示：
- **绿色**：当前分支的修改
- **蓝色**：传入分支的修改

每个冲突区域有三个按钮：
- **Use [branch-name]**：保留当前分支
- **Use [other-branch]**：保留传入分支
- **Use Both**：保留两者

---

## 11. AI 功能

### 11.1 AI 功能概览

| 功能 | 说明 | 快捷键 |
|------|------|--------|
| Agent Panel | 与 AI 对话，修改代码 | `Ctrl+Shift+/` |
| 内联助手 | 选中代码后让 AI 修改 | `Ctrl+Enter` |
| 编辑预测 | 打字时的 AI 补全 | `Alt+Tab` 或 `Alt+L` 接受 |
| 生成提交消息 | AI 生成 Git 提交消息 | `Alt+L`（Git 面板中） |

### 11.2 配置 AI 提供商

```jsonc
// 方式一：Zed 托管模型（需要 Zed Pro 账户）
// Ctrl+, → AI → 登录

// 方式二：API Key
// Ctrl+, → AI → Edit Predictions → Configure Providers
// 添加 OpenAI / Anthropic / Google 等 API Key

// 方式三：GitHub Copilot
// Ctrl+, → AI → Edit Predictions → GitHub Copilot → Sign in
```

### 11.3 编辑预测操作

| 操作 | 快捷键 |
|------|--------|
| 接受预测 | `Alt+Tab` 或 `Alt+L` |
| 接受下一个词 | `Alt+K` |
| 接受下一行编辑 | `Alt+J` |
| 下一个预测 | `Alt+]` |
| 上一个预测 | `Alt+[` |
| 显示预测 | `Alt+\` |
| 切换预测菜单 | `Ctrl+Shift+I` |

### 11.4 Agent Panel 操作

| 操作 | 快捷键 |
|------|--------|
| 新建对话 | `Ctrl+N` |
| 切换模型 | `Shift+Alt+/` |
| 切换 Profile | `Shift+Alt+P` |
| 切换模式 | `Shift+Tab` |
| 展开编辑器 | `Shift+Alt+Escape` |
| 添加选中代码到对话 | `Ctrl+Shift+.` |
| 保持 Agent 修改 | `Alt+Y` |
| 拒绝 Agent 修改 | `Ctrl+Alt+Z` |
| 保持所有修改 | `Shift+Alt+Y` |
| 拒绝所有修改 | `Shift+Alt+Z` |
| 打开 Agent Diff | `Ctrl+Shift+R` |

---

## 12. Vim 模式

### 12.1 启用 Vim 模式

```jsonc
// settings.json
{
  "vim_mode": true
}
```

或通过命令面板：`workspace: toggle vim mode`

### 12.2 Vim 特有快捷键

#### LSP 导航

| 操作 | 快捷键 |
|------|--------|
| 跳转定义 | `gd` |
| 跳转声明 | `gD` |
| 跳转类型定义 | `gy` |
| 跳转实现 | `gI` |
| 重命名 | `cd` |
| 查找所有引用 | `gA` |
| 文件内搜索符号 | `gs` |
| 项目内搜索符号 | `gS` |
| 下一个诊断 | `g]` 或 `]d` |
| 上一个诊断 | `g[` 或 `[d` |
| 悬停错误 | `gh` |
| 代码操作 | `g.` |

#### Tree-sitter 导航

| 操作 | 快捷键 |
|------|--------|
| 下一个方法 | `]m` |
| 上一个方法 | `[m` |
| 下一个类 | `]]` |
| 上一个类 | `[[` |
| 选择更大语法节点 | `[x` |
| 选择更小语法节点 | `]x` |

#### 文本对象

| 对象 | 快捷键 |
|------|--------|
| 围绕函数 | `af` |
| 函数内部 | `if` |
| 围绕类 | `ac` |
| 类内部 | `ic` |
| 注释 | `gc` |
| 参数/列表项 | `ia` / `aa` |
| 标签 | `at` / `it` |
| 缩进级别 | `ii` / `ai` |

#### 多光标

| 操作 | 快捷键 |
|------|--------|
| 下一个匹配 | `gl` |
| 上一个匹配 | `gL` |
| 每行末尾加光标 | `gA` |
| 每行开头加光标 | `gI` |
| 选中所有匹配 | `ga` |

#### Surround 操作

| 操作 | 快捷键 |
|------|--------|
| 添加围绕 | `ys` + 对象 + 字符 |
| 修改围绕 | `cs` + 旧字符 + 新字符 |
| 删除围绕 | `ds` + 字符 |

#### Vim 命令

| 命令 | 说明 |
|------|------|
| `:w` | 保存 |
| `:wq` | 保存并关闭 |
| `:q` | 关闭 |
| `:qa` | 关闭所有 |
| `:vs` | 垂直分屏 |
| `:sp` | 水平分屏 |
| `:E` | 打开项目面板 |
| `:G` | 打开 Git 面板 |
| `:A` | 打开 AI 面板 |
| `:D` | 打开调试面板 |
| `:te` | 打开终端 |

---

## 13. 扩展系统

### 13.1 安装扩展

`Ctrl+Shift+X` 打开扩展面板，搜索并安装。

### 13.2 推荐扩展（全栈开发者）

| 扩展 | 用途 |
|------|------|
| **Java** | Java 语言支持（必须） |
| **Python** | Python 语言支持（必须） |
| **Ruff** | Python 格式化/lint（超快） |
| **Lombok** | Lombok 注解支持 |
| **Docker** | Dockerfile 语法高亮 |
| **YAML** | YAML 支持（配置文件） |
| **XML** | XML 支持（pom.xml） |
| **Properties** | .properties 文件支持 |
| **Groovy** | Gradle 构建文件 |
| **Markdown** | 文档编写 |
| **SQL** | SQL 查询 |
| **HTML** | 前端页面 |
| **CSS** | 样式表 |
| **JavaScript** | 前端 JS |
| **TypeScript** | 前端 TS |
| **Vue** / **Svelte** | 前端框架 |
| **Tailwind CSS** | CSS 框架 |
| **TOML** | pyproject.toml 支持 |

### 13.3 自动安装扩展

```jsonc
{
  "auto_install_extensions": {
    "java": true,
    "python": true,
    "ruff": true,
    "docker": true,
    "yaml": true,
    "xml": true,
    "groovy": true,
    "html": true,
    "css": true,
    "javascript": true,
    "typescript": true,
    "vue": true,
    "markdown": true,
    "sql": true,
    "toml": true
  }
}
```

---

## 14. 从 IntelliJ/VS Code 迁移

### 14.1 从 IntelliJ 迁移 — 关键差异

| 概念 | IntelliJ | Zed |
|------|----------|-----|
| **索引** | 打开项目需等待索引（30s-15min） | 无索引，打开即用 |
| **项目模型** | .idea/ + .iml 复杂配置 | 文件夹即项目 |
| **语言智能** | 自研引擎，深度框架感知 | LSP（jdtls），能力稍弱 |
| **框架集成** | Spring/JPA/REST 深度感知 | 无框架感知，靠搜索 |
| **重构** | 丰富（提取接口、上移成员等） | 基础（重命名、提取方法） |
| **构建** | 自动检测 Maven/Gradle | 手动配置 tasks.json |
| **运行配置** | GUI 管理 | JSON 配置 + 终端 |
| **SDK 管理** | 内置管理 | 依赖系统 PATH |
| **数据库** | DataGrip 内置 | 需外挂工具 |

### 14.2 IntelliJ → Zed 快捷键映射（JetBrains 键位）

| 操作 | IntelliJ | Zed (JetBrains) |
|------|----------|-----------------|
| 全局搜索 | `Shift Shift` | `Shift Shift` |
| 命令面板 | `Ctrl+Shift+A` | `Ctrl+Shift+A` |
| 文件搜索 | `Ctrl+Shift+N` | `Ctrl+Shift+O` |
| 类搜索 | `Ctrl+N` | `Ctrl+O` |
| 最近文件 | `Ctrl+E` | `Ctrl+E` |
| 跳转定义 | `Ctrl+B` | `Ctrl+B` |
| 查找用法 | `Alt+F7` | `Alt+F7` |
| 重命名 | `Shift+F6` | `Shift+F6` |
| 格式化 | `Ctrl+Alt+L` | `Ctrl+Alt+L` |
| 项目面板 | `Alt+1` | `Ctrl+Shift+E` |
| 终端 | `Alt+F12` | `Ctrl+`` ` |
| 复制行 | `Ctrl+D` | `Ctrl+D` |
| 删除行 | `Ctrl+Y` | `Ctrl+Shift+K` |
| 上下移动行 | `Shift+Alt+↑/↓` | `Shift+Alt+↑/↓` |
| 扩展/收缩选择 | `Ctrl+W` / `Ctrl+Shift+W` | `Shift+Alt+→/←` |
| 注释 | `Ctrl+/` | `Ctrl+/` |
| 前进/后退 | `Ctrl+Alt+←/→` | `Alt+←/→` |
| 运行 | `Ctrl+R` | `Ctrl+Alt+R`（任务） |
| 调试 | `Ctrl+D` | `Alt+Shift+F9` |
| 断点 | `Ctrl+F8` | `F9` |

### 14.3 从 VS Code 迁移

Zed 默认使用 VS Code 键位映射，大部分快捷键直接兼容。

主要差异：

| 操作 | VS Code | Zed |
|------|---------|-----|
| 打开最近项目 | `Ctrl+R` | `Ctrl+Alt+O` |
| 上下移动行 | `Alt+↑/↓` | `Ctrl+Alt+↑/↓` |
| 分屏 | `Ctrl+\` | `Ctrl+K →` 或 `Ctrl+\` |
| 扩展选择 | `Shift+Alt+→` | `Shift+Alt+→` |

VS Code 设置可自动导入：`Ctrl+Shift+P` → `zed: import vs code settings`

---

## 15. 性能对比与适用场景

### 15.1 性能数据

| 指标 | Zed | VS Code | IntelliJ |
|------|-----|---------|----------|
| 冷启动（10K 文件项目） | <1s | 3-5s | 30s-2min |
| 内存占用（空项目） | ~200MB | ~400MB | ~1GB |
| 内存占用（大项目） | ~400MB | ~1-2GB | 2-4GB |
| 文件搜索延迟 | <50ms | <100ms | <50ms（索引后） |
| 文本输入延迟 | <5ms（GPU渲染） | ~10ms | ~5ms |

### 15.2 适合用 Zed 的场景

- ✅ **快速浏览和编辑代码**：打开即用，无需等待
- ✅ **前端开发**：TypeScript/React/Vue 等 LSP 支持良好
- ✅ **Go/Rust 开发**：语言服务器非常成熟
- ✅ **Python 开发**：Pyright + Ruff 组合体验流畅
- ✅ **轻量 Java 开发**：简单项目、脚本、工具类
- ✅ **AI 辅助编程**：内置 Agent，体验流畅
- ✅ **远程开发**：SSH 远程编辑
- ✅ **实时协作**：多人同时编辑 + 语音
- ✅ **快速脚本编写**：Python、Shell 等
- ✅ **FastAPI/Django 开发**：配合 uv 工具链

### 15.3 不适合用 Zed 的场景

- ❌ **大型 Spring Boot 微服务**：缺少框架感知
- ❌ **复杂重构**：IntelliJ 重构能力远超 Zed
- ❌ **数据库密集开发**：需要外挂 DataGrip
- ❌ **应用服务器调试**：需要外部工具
- ❌ **需要丰富插件生态**：扩展数量远少于 VS Code
- ❌ **PyCharm 深度特性**：Django 模板、数据库可视化管理

### 15.4 推荐工作流

```
日常开发（推荐组合）：
┌─────────────────────────────────┐
│  Zed：代码编辑 + AI 辅助 + Git   │
│  DataGrip/DBeaver：数据库操作     │
│  Postman/Insomnia：API 测试       │
│  Docker Desktop：容器管理         │
│  IntelliJ（备用）：复杂 Java 重构  │
│  PyCharm（备用）：复杂 Python 调试 │
└─────────────────────────────────┘
```

---

## 16. 实战配置模板

### 16.1 完整 settings.json（全栈开发者）

```jsonc
{
  // === 基础 ===
  "base_keymap": "JetBrains",
  "vim_mode": false,
  "theme": "One Dark",
  
  // === 编辑器 ===
  "buffer_font_family": "JetBrains Mono",
  "buffer_font_size": 14,
  "tab_size": 4,
  "hard_tabs": false,
  "format_on_save": "on",
  "soft_wrap": "preferred_line_length",
  "preferred_line_length": 120,
  "relative_line_numbers": false,
  "inlay_hints": { "enabled": "on" },
  "sticky_scroll": { "enabled": true },
  "minimap": { "show": "always" },
  "indent_guides": { "enabled": "on" },
  "wrap_guides": [120],
  "show_whitespaces": "selection",
  "autosave": "on_focus_change",
  "ensure_final_newline_on_save": true,
  "remove_trailing_whitespace_on_save": true,
  
  // === 自动补全 ===
  "show_completions_on_input": true,
  "auto_signature_help": true,
  
  // === 终端 ===
  "terminal": {
    "font_size": 13,
    "line_height": 1.3,
    "cursor_shape": "block",
    "blinking": "on",
    "copy_on_select": true,
    "max_scroll_history_lines": 10000
  },
  
  // === Git ===
  "git": {
    "inline_blame": { "enabled": true }
  },
  
  // === 调试器 ===
  "debugger": {
    "dock": "bottom",
    "stepping_granularity": "line",
    "save_breakpoints": true
  },
  
  // === 语言特定 ===
  "languages": {
    "Java": {
      "tab_size": 4,
      "format_on_save": "on"
    },
    "Python": {
      "tab_size": 4,
      "format_on_save": "on",
      "formatter": "language_server",
      "code_actions_on_format": {
        "source.organizeImports": true
      }
    },
    "JavaScript": {
      "tab_size": 2,
      "format_on_save": "on"
    },
    "TypeScript": {
      "tab_size": 2,
      "format_on_save": "on"
    },
    "JSON": {
      "tab_size": 2
    },
    "YAML": {
      "tab_size": 2
    },
    "XML": {
      "tab_size": 4
    },
    "TOML": {
      "tab_size": 2
    },
    "Markdown": {
      "soft_wrap": "editor_width"
    }
  },
  
  // === Java LSP (JDTLS) ===
  // 完整配置与注释参考第 6.3 节
  // === Python LSP (Pyright) + Ruff ===
  "lsp": {
    "jdtls": {
      "settings": {
        // JDTLS 需要 JDK 21+，请修改为实际的 JDK 21 路径
        "java_home": "D:\\soft\\Java\\jdk-21",
        "lombok_support": true,
        "jdk_auto_download": false,
        "min_memory": "1G",
        "max_memory": "4G",
        "check_updates": "always"
      },
      "initialization_options": {
        "settings": {
          "java": {
            "configuration": {
              "updateBuildConfiguration": "automatic",
              "runtimes": [
                {
                  "name": "JavaSE-21",
                  "path": "D:\\soft\\Java\\jdk-21",
                  "default": true
                }
              ],
              "maven": {
                "userSettings": "D:\\soft\\DEV\\apache-maven-3.9.12\\conf\\settings.xml"
              }
            },
            "saveActions": {
              "organizeImports": true
            },
            "references": {
              "includeAccessors": true,
              "includeDecompiledSources": true
            },
            "eclipse": {
              "downloadSources": true
            },
            "maven": {
              "downloadSources": true,
              "updateSnapshots": true
            },
            "autobuild": {
              "enabled": true
            },
            "maxConcurrentBuilds": 2,
            "inlayHints": {
              "parameterNames": {
                "enabled": "literals"
              }
            },
            "import": {
              "maven": { "enabled": true },
              "gradle": { "enabled": true },
              "exclusions": [
                "**/node_modules/**",
                "**/.metadata/**",
                "**/archetype-resources/**",
                "**/META-INF/maven/**"
              ]
            },
            "completion": {
              "enabled": true,
              "favoriteStaticMembers": [
                "org.junit.Assert.*",
                "org.junit.jupiter.api.Assertions.*",
                "org.mockito.Mockito.*",
                "org.mockito.ArgumentMatchers.*",
                "org.apache.commons.lang3.StringUtils.*",
                "com.google.common.collect.Lists.*",
                "com.google.common.collect.Maps.*"
              ],
              "importOrder": ["java", "javax", "com", "org"],
              "postfix": { "enabled": true }
            },
            "format": {
              "enabled": true,
              "onType": { "enabled": true }
            }
          }
        }
      }
    },
    "pyright": {
      "settings": {
        "python": {
          "pythonPath": ".venv/Scripts/python.exe",
          "analysis": {
            "typeCheckingMode": "basic",
            "autoSearchPaths": true,
            "useLibraryCodeForTypes": true,
            "diagnosticMode": "workspace"
          }
        }
      }
    },
    "ruff": {
      "settings": {
        "args": ["--line-length=120", "--target-version=py310"]
      }
    }
  },
  
  // === 自动安装扩展 ===
  "auto_install_extensions": {
    "java": true,
    "python": true,
    "ruff": true,
    "docker": true,
    "yaml": true,
    "xml": true,
    "groovy": true,
    "html": true,
    "css": true,
    "javascript": true,
    "typescript": true,
    "vue": true,
    "markdown": true,
    "sql": true,
    "properties": true,
    "toml": true
  }
}
```

### 16.2 完整 keymap.json（全栈开发者增强）

```jsonc
[
  // 任务快捷
  {
    "context": "Workspace",
    "bindings": {
      "alt-m": ["task::Spawn", { "task_name": "Maven: 编译" }],
      "ctrl-alt-r": ["task::Spawn", { "task_name": "Maven: 运行" }],
      "ctrl-alt-t": ["task::Spawn", { "task_name": "Maven: 测试当前类" }]
    }
  },
  // 禁用不需要的绑定
  {
    "context": "Workspace",
    "bindings": {
      "ctrl-r": null  // 禁用最近项目，改用其他方式
    }
  },
  // 自定义发送按键序列
  {
    "bindings": {
      // 快速向下移动 5 行
      "ctrl-alt-down": ["workspace::SendKeystrokes", "down down down down down"],
      "ctrl-alt-up": ["workspace::SendKeystrokes", "up up up up up"]
    }
  }
]
```

### 16.3 完整 tasks.json（Maven Spring Boot 项目）

```jsonc
[
  {
    "label": "Maven: 编译",
    "command": "mvn",
    "args": ["compile", "-q"],
    "save": "all"
  },
  {
    "label": "Maven: 运行",
    "command": "mvn",
    "args": ["spring-boot:run"],
    "env": { "SPRING_PROFILES_ACTIVE": "dev" },
    "save": "all"
  },
  {
    "label": "Maven: 调试运行",
    "command": "mvn",
    "args": [
      "spring-boot:run",
      "-Dspring-boot.run.jvmArguments=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"
    ],
    "env": { "SPRING_PROFILES_ACTIVE": "dev" },
    "save": "all"
  },
  {
    "label": "Maven: 测试全部",
    "command": "mvn",
    "args": ["test"],
    "save": "all"
  },
  {
    "label": "Maven: 测试当前类",
    "command": "mvn",
    "args": ["test", "-Dtest=$ZED_STEM"],
    "save": "all"
  },
  {
    "label": "Maven: 测试当前方法",
    "command": "mvn",
    "args": ["test", "-Dtest=$ZED_STEM#$ZED_SYMBOL"],
    "save": "all"
  },
  {
    "label": "Maven: 打包",
    "command": "mvn",
    "args": ["package", "-DskipTests"],
    "save": "all"
  },
  {
    "label": "Maven: 清理安装",
    "command": "mvn",
    "args": ["clean", "install", "-DskipTests"],
    "save": "all"
  },
  {
    "label": "Maven: 依赖树",
    "command": "mvn",
    "args": ["dependency:tree", "-DoutputType=text"],
    "reveal": "always"
  },
  {
    "label": "Git: 拉取并变基",
    "command": "git",
    "args": ["pull", "--rebase"]
  }
]
```

### 16.4 完整 tasks.json（Python FastAPI 项目）

```jsonc
[
  {
    "label": "Python: uv 同步依赖",
    "command": "uv",
    "args": ["sync"],
    "save": "all"
  },
  {
    "label": "Python: 运行当前文件",
    "command": "uv",
    "args": ["run", "python", "$ZED_RELATIVE_FILE"],
    "save": "current"
  },
  {
    "label": "Python: FastAPI 开发服务器",
    "command": "uv",
    "args": ["run", "uvicorn", "main:app", "--reload", "--port", "8000"],
    "save": "all"
  },
  {
    "label": "Python: pytest 全部",
    "command": "uv",
    "args": ["run", "pytest", "-xvs"],
    "save": "all"
  },
  {
    "label": "Python: pytest 当前文件",
    "command": "uv",
    "args": ["run", "pytest", "-xvs", "$ZED_RELATIVE_FILE"],
    "save": "current"
  },
  {
    "label": "Python: pytest 当前方法",
    "command": "uv",
    "args": ["run", "pytest", "-xvs", "$ZED_RELATIVE_FILE::$ZED_SYMBOL"],
    "save": "current"
  },
  {
    "label": "Python: pytest 带覆盖率",
    "command": "uv",
    "args": ["run", "pytest", "--cov=src", "--cov-report=term-missing"],
    "save": "all"
  },
  {
    "label": "Python: ruff 格式化全部",
    "command": "uv",
    "args": ["run", "ruff", "format", "."],
    "save": "all"
  },
  {
    "label": "Python: ruff 检查并修复",
    "command": "uv",
    "args": ["run", "ruff", "check", ".", "--fix"],
    "save": "all"
  },
  {
    "label": "Python: mypy 类型检查",
    "command": "uv",
    "args": ["run", "mypy", "src/"],
    "save": "all"
  }
]
```

### 16.5 完整 debug.json（全栈项目）

```jsonc
[
  // === Java 调试 ===
  {
    "adapter": "Java",
    "request": "launch",
    "label": "Java: 启动调试 - 主类",
    "mainClass": "com.mycompany.Application",
    "stopOnEntry": false,
    "cwd": "$ZED_WORKTREE_ROOT",
    "build": {
      "command": "mvn",
      "args": ["compile", "-q"]
    }
  },
  {
    "adapter": "Java",
    "request": "launch",
    "label": "Java: 启动调试 - 当前文件",
    "stopOnEntry": true,
    "cwd": "$ZED_WORKTREE_ROOT"
  },
  {
    "adapter": "Java",
    "request": "attach",
    "label": "Java: 附加到 Spring Boot (5005)",
    "hostName": "localhost",
    "port": 5005
  },
  
  // === Python 调试 ===
  {
    "adapter": "Debugpy",
    "request": "launch",
    "label": "Python: 调试当前文件",
    "program": "$ZED_FILE",
    "cwd": "$ZED_WORKTREE_ROOT",
    "python": ".venv/Scripts/python.exe",
    "justMyCode": true
  },
  {
    "adapter": "Debugpy",
    "request": "launch",
    "label": "Python: pytest 调试当前文件",
    "module": "pytest",
    "args": ["-xvs", "$ZED_FILE"],
    "cwd": "$ZED_WORKTREE_ROOT",
    "python": ".venv/Scripts/python.exe"
  },
  {
    "adapter": "Debugpy",
    "request": "launch",
    "label": "Python: FastAPI 调试",
    "module": "uvicorn",
    "args": ["main:app", "--reload", "--port", "8000"],
    "cwd": "$ZED_WORKTREE_ROOT",
    "python": ".venv/Scripts/python.exe"
  },
  {
    "adapter": "Debugpy",
    "request": "attach",
    "label": "Python: 附加到运行中的进程",
    "connect": {
      "host": "localhost",
      "port": 5678
    },
    "justMyCode": true
  }
]
```

---

## 附录 A：快捷键总表（按使用频率排序）

### 必须记住的 20 个

| # | 操作 | 快捷键 |
|---|------|--------|
| 1 | 命令面板 | `Ctrl+Shift+P` |
| 2 | 文件搜索 | `Ctrl+P` |
| 3 | 全文搜索 | `Ctrl+Shift+F` |
| 4 | 保存 | `Ctrl+S` |
| 5 | 终端 | `Ctrl+`` ` |
| 6 | 项目面板 | `Ctrl+Shift+E` |
| 7 | Git 面板 | `Ctrl+Shift+G` |
| 8 | 跳转定义 | `F12` |
| 9 | 查找引用 | `Shift+Alt+F12` |
| 10 | 重命名 | `F2` |
| 11 | 前进/后退 | `Alt+→/←` |
| 12 | 代码操作 | `Ctrl+.` |
| 13 | 格式化 | `Shift+Alt+F` |
| 14 | 注释 | `Ctrl+/` |
| 15 | 任务列表 | `Shift+Alt+T` |
| 16 | 重运行任务 | `Alt+T` |
| 17 | 启动调试 | `F4` |
| 18 | 切换断点 | `F9` |
| 19 | Agent 面板 | `Ctrl+Shift+/` |
| 20 | 设置 | `Ctrl+,` |

---

## 附录 B：常见问题

### Q: Java 补全不工作？

1. 确认 JDK 21+ 已安装且 `JAVA_HOME` 正确
2. 确认 Java 扩展已安装
3. 打开命令面板 → `dev: open language server logs` → 查看 jdtls 日志
4. 确认项目根目录有 `pom.xml` 或 `build.gradle`

### Q: Maven 任务在 Windows 上不工作？

Zed Java 扩展的内置任务脚本在 Windows 上可能不兼容。解决方法：
1. 在 `.zed/tasks.json` 中手动定义任务
2. 使用 `.bat` 或 `.ps1` 脚本包装

### Q: 如何导入 VS Code 设置？

`Ctrl+Shift+P` → `zed: import vs code settings`

### Q: 如何导入 IntelliJ 键位？

`Ctrl+,` → 搜索 `Base Keymap` → 选择 `JetBrains`

### Q: Zed 能否完全替代 IntelliJ / PyCharm？

对于全栈开发，**目前不能完全替代**。推荐组合使用：
- Zed：日常编辑、AI 辅助、快速导航、Python 开发
- IntelliJ：复杂 Java 重构、框架调试、深度分析
- PyCharm：复杂 Python 调试、Django 模板、数据库可视化

### Q: Python 补全不工作？

1. 确认 Python 扩展已安装
2. 确认虚拟环境已创建（推荐 `uv venv`）
3. 检查 `settings.json` 中 `pythonPath` 配置正确
4. 打开命令面板 → `dev: open language server logs` → 查看 pyright 日志

### Q: 如何在 Zed 中使用 uv？

1. 安装 uv：`pip install uv` 或 `winget install astral-sh.uv`
2. 创建虚拟环境：`uv venv`
3. 在 `settings.json` 中配置 `pythonPath: ".venv/Scripts/python.exe"`
4. 使用 `uv run` 执行任务，自动使用项目虚拟环境

### Q: Ruff 格式化不生效？

1. 确认 Ruff 扩展已安装
2. 检查 `settings.json` 中 Python 的 `formatter` 设置为 `"language_server"`
3. 确认项目中安装了 ruff：`uv add --dev ruff`
4. 打开命令面板 → `dev: open language server logs` → 查看 ruff 日志

### Q: 如何配置代理？

```jsonc
{
  "proxy": "http://your-proxy:port"
}
```

---

## 附录 C：有用链接

| 资源 | 地址 |
|------|------|
| 官网 | https://zed.dev |
| 文档 | https://zed.dev/docs |
| GitHub | https://github.com/zed-industries/zed |
| Discord | https://discord.com/invite/zedindustries |
| Reddit | https://www.reddit.com/r/ZedEditor |
| **Java 相关** | |
| Java 扩展 | https://github.com/zed-extensions/java |
| JDTLS 文档 | https://github.com/eclipse-jdtls/eclipse.jdt.ls |
| **Python 相关** | |
| Python 扩展 | https://github.com/zed-industries/zed-python |
| Pyright 文档 | https://microsoft.github.io/pyright/ |
| Ruff 官网 | https://docs.astral.sh/ruff/ |
| uv 官网 | https://docs.astral.sh/uv/ |
| Debugpy 文档 | https://github.com/microsoft/debugpy |
| **其他** | |
| 默认键位（Windows） | [GitHub 链接](https://github.com/zed-industries/zed/blob/main/assets/keymaps/default-windows.json) |
