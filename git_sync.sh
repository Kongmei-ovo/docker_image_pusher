#!/bin/bash

# 定义颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}   飞牛NAS Git 自动化提交工具           ${NC}"
echo -e "${YELLOW}========================================${NC}"

# 1. 拉取远程最新版本
echo -e "${GREEN}[1/4] 正在拉取远程更新 (Pull)...${NC}"
git pull
if [ $? -ne 0 ]; then
    echo -e "${RED}[错误] 拉取失败，请检查网络或冲突。${NC}"
    exit 1
fi

# 2. 确认修改
echo ""
read -p "确认已完成修改并准备提交吗？(y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "操作已取消。"
    exit 0
fi

# 3. 添加更改
echo -e "${GREEN}[2/4] 正在添加更改 (Add)...${NC}"
git add .

# 4. 提交更改
echo ""
read -p "请输入本次修改的说明 (Commit Message): " msg
if [ -z "$msg" ]; then
    msg="Update by FnOS Auto-script"
fi

echo -e "${GREEN}[3/4] 正在提交更改 (Commit)...${NC}"
git commit -m "$msg"
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}[提示] 没有检测到任何变化，无需提交。${NC}"
    exit 0
fi

# 5. 推送到远程
echo ""
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "${GREEN}[4/4] 正在推送到 GitHub 分支: $BRANCH (Push)...${NC}"
git push origin $BRANCH

if [ $? -eq 0 ]; then
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${GREEN}   恭喜！推送成功！${NC}"
    echo -e "${YELLOW}========================================${NC}"
else
    echo -e "${RED}[错误] 推送失败。${NC}"
fi
