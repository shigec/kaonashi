from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base

# TODO:環境変数に置き換える
DATABASE = 'mysql://%s:%s@%s/%s?charset=utf8' % (
    "kaonashi",
    "kaonashi4649",
    "kaonashi-master-db-dev.cvxvuy4x5nz1.us-west-2.rds.amazonaws.com",
    "sample",
)

# echo=True 実行時にSQLが出力される
ENGINE = create_engine(DATABASE, encoding="utf-8", echo=True)

# 各Modelで継承が必要
Base = declarative_base()