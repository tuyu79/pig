#!/usr/bin/env python3
"""解析 SQL 文件并导出表结构到 Excel"""

import re
from pathlib import Path

def parse_sql_file(sql_path, db_name="pig"):
    """解析 SQL 文件"""
    content = Path(sql_path).read_text(encoding='utf-8')

    tables = []

    # 分割每个表
    parts = content.split('-- ----------------------------')

    for part in parts:
        # 找 CREATE TABLE 语句
        create_match = re.search(r'CREATE TABLE.*?`(\w+)`\s*\((.*?)\)\s*ENGINE=', part, re.DOTALL)
        if not create_match:
            continue

        table_name = create_match.group(1)
        columns_str = create_match.group(2)

        # 获取表注释
        table_comment = ""
        comment_match = re.search(r"COMMENT='([^']*)'", part)
        if comment_match:
            table_comment = comment_match.group(1)

        # 解析列
        columns = []
        for line in columns_str.split('\n'):
            line = line.strip()
            if not line or line.startswith('PRIMARY') or line.startswith('KEY') or line.startswith('UNIQUE') or line.startswith('CONSTRAINT'):
                continue

            # 匹配列定义: `col_name` type DEFAULT xxx COMMENT 'xxx' NOT NULL
            col_match = re.match(r'`(\w+)`\s+([^\s`]+(?:\([^\)]+\))?)', line)
            if col_match:
                col_name = col_match.group(1)
                col_type = col_match.group(2)

                # 获取注释
                comment = ""
                if "COMMENT '" in line:
                    cmt_match = re.search(r"COMMENT '([^']*)'", line)
                    if cmt_match:
                        comment = cmt_match.group(1)

                # 获取默认值
                default = ""
                if "DEFAULT " in line:
                    # 支持 DEFAULT 'value', DEFAULT 0, DEFAULT CURRENT_TIMESTAMP 等
                    default_match = re.search(r"DEFAULT\s+('[^']*'|\w+(?:\([^\)]*\))?)", line)
                    if default_match:
                        default = default_match.group(1).strip()
                        # 清理引号
                        if default.startswith("'") and default.endswith("'"):
                            default = default[1:-1]

                # 检查是否可为空
                nullable = "是" if "NOT NULL" not in line and "PRIMARY KEY" not in line else "否"

                # 检查是否主键
                pk = '是' if f'PRIMARY KEY (`{col_name}`)' in columns_str else ''

                columns.append({
                    'name': col_name,
                    'type': col_type,
                    'pk': pk,
                    'nullable': nullable,
                    'default': default,
                    'comment': comment
                })

        if columns:
            tables.append({
                'name': table_name,
                'comment': table_comment,
                'columns': columns,
                'db': db_name
            })

    return tables

def write_csv(tables, output_path):
    """写入 CSV 文件"""
    import csv

    with open(output_path, 'w', newline='', encoding='utf-8-sig') as f:
        writer = csv.writer(f)

        current_db = None

        for table in tables:
            # 如果数据库变了，写入数据库名
            if table['db'] != current_db:
                current_db = table['db']
                writer.writerow([])
                writer.writerow(['数据库', current_db])

            writer.writerow([])
            writer.writerow(['表名', table['name'], '表说明', table['comment']])
            writer.writerow(['字段名', '字段类型', '主键', '可为空', '默认值', '说明'])

            for col in table['columns']:
                writer.writerow([col['name'], col['type'], col['pk'], col['nullable'], col['default'], col['comment']])

def main():
    base_path = "/Users/abel/Workspace/05_ProjectAssets/03_Auth/01_KnowledgeBase/00_ReferenceProjects/pig/db"
    output_file = "/Users/abel/Workspace/05_ProjectAssets/03_Auth/01_KnowledgeBase/01_TechNotes/01_BE/00_Reference/pig表结构.csv"

    all_tables = []

    # 处理 pig.sql
    sql_file = f"{base_path}/pig.sql"
    print(f"读取文件: {sql_file}")
    tables = parse_sql_file(sql_file, "pig")
    print(f"找到 {len(tables)} 个表")
    all_tables.extend(tables)

    # 处理 pig_config.sql
    sql_file = f"{base_path}/pig_config.sql"
    print(f"\n读取文件: {sql_file}")
    tables = parse_sql_file(sql_file, "pig_config")
    print(f"找到 {len(tables)} 个表")
    all_tables.extend(tables)

    print(f"\n总共 {len(all_tables)} 个表")

    write_csv(all_tables, output_file)
    print(f"\n已导出到: {output_file}")

if __name__ == "__main__":
    main()
