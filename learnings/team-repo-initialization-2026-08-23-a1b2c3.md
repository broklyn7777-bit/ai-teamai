---
title: "团队仓库初始化：结构与最佳实践选型"
author: "01374035"
date: 2026-08-23
tags: [teamai, workflow, best-practice, 初始化]
---

## 背景

为团队搭建 teamai-cli 共享仓库（ai-teamai），需要确定目录结构与初始内容。依据 teamai-cli 源码中的资源模型与官方社区模板 [teamai-hub/template-backend](https://github.com/teamai-hub/template-backend) 的最佳实践完成初始化。

## 解决方案

- **目录模型**：`skills/`（支持 `skills/<namespace>/<skill>/SKILL.md` 命名空间）、`rules/`（递归子目录，如 `common/`、`java/`）、`agents/`、`docs/`、`learnings/`、`hooks/hooks.yaml`、`mcp/mcp.yaml`、`env/env.yaml`、`members/`。
- **初始内容**：直接移植团队已验证的本地资产——全量编码规则（common/java/python/typescript）、四个评审子代理（java/database/security/code reviewer）、代码知识梳理技能（backend-service-spec / cross-tech-stack-spec）。
- **安全默认**：`sharing.hooks.autoApply: false`、`sharing.mcp.autoApply: false`（显式同意），`recall.enabled: true`（知识召回默认开启）。

## 经验总结

- `teamai pull` 对 `rules/` 是**覆盖式同步**：本地存在而团队仓库没有的规则文件会被递归清理。个人规则想保留必须先 `teamai push` 入库。
- skills 与 agents 不会因"本地多出"被删除（只处理 `.removed` tombstone 与显式排除项），所以本地私有技能是安全的。
- CLI 内置技能（`teamai-share-learnings`、`team-wiki-codebase` 等）由 CLI 自动部署，放进团队仓库反而会造成重复。
- teamai-cli 的 MR 提供方仅支持 github / tgit / cnb；Gitee 托管时 clone/pull/直接推送正常，自动建 MR 会失败，需人工推送。
- 未配置 `manifest/roles.yaml` 时，所有命名空间的 skills 和嵌套 rules 全量同步；角色化分发是可选的后续演进。

## 相关 Skills

- backend-service-spec-skill
- teamai-share-learnings
