---
title: 机器学习-4
date: 2023-06-11 09:06:07
categories:
	- 机器学习
tags: 
	- 机器学习
	- 集成模型
	- 随机森林
	- Bagging
	- Boosting
	- 层次聚类
---
# 集成模型
## Bagging
多个弱模型取均值
## Boosting
多个弱模型累加，且后一模型是在前一模型的基础上生成的，是一种迭代思路。
## stacking

## 几种方法的主要区别
![机器学习-4-1](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-1.png)
# 随机森林
## 训练样本的随机化
- 有放回的
## 特征选择的随机化
- 简单随机采样
- 信息熵法
![机器学习-4-2](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-2.png)
- Bagging包括随机森林，随机森林隶属于Bagging
- 鲁棒性如何解释？对极端数据（噪声，扰动）的处理能力，能一定程度上可以应对数据异常数据。
- 为什么要集成学习？一个单一模型很容易过拟合
# GBDT（Boosting）
- bagging用来解决过拟合，有可能会欠拟合。boosting解决欠拟合，有可能会过拟合。
- 将前一阶段的残差作为下一阶段的因变量
- 累加求最终预测值
# XGBoost（Boosting）
- 目标函数可以用泰勒展开
- 与原本boosting的区别，XGboost加入了正则化，传统boosting只用了一阶导，XGboost作了泰勒展开，有二阶导
Boost中目标函数不一定是多项式，直接求导比较难。
![机器学习-4-3](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-3.png)
- XGboost
	以泰勒展开将非多项式目标函数转化为多项式。
![机器学习-4-4](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-4.png)
# 叠加式训练
- 递推的内容

![机器学习-4-5](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-5.png)
- 二元交叉商
![机器学习-4-6](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-6.png)
- 目标函数的解释
![机器学习-4-7](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-7.png)
# 垃圾邮件分类（典型分类问题）
## 贝叶斯
![机器学习-4-8](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-8.png)
![机器学习-4-9](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-9.png)
## 似然（词频统计）
![机器学习-4-10](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-10.png)
## 先验概率
![机器学习-4-11](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-11.png)
# 目的（做出判断）
通过条件概率来进行比较
![机器学习-4-12](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-12.png)
分母为固定常数，便于比较
![机器学习-4-13](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-13.png)
- 避免概率为0的情况——加1平滑
![机器学习-4-14](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-14.png)
## 最大问题：
- 不能保证特征间的独立性，未考虑到特征间的相关性，只是根据样本出现的次数，进行基于概率的训练。只是强调某个x是某个y的条件。
- 只能用原始特征，不能加工或提取新特征。
- 为什么要+1平滑，防止出现概率为0的情况。
## 优点：
贝叶斯不容易过拟合——异常值、缺失值概率极低，基本可以视为被舍弃了，所以受异常值影响比较低。
# 层次聚类
## 树形图
![机器学习-4-15](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-15.png)
## 凝聚聚类（自下而上）

## 分裂聚类（自上而下）

## MST（最小生成树）
![机器学习-4-16](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-16.png)
![机器学习-4-17](https://aucnm0202-1318327891.cos.ap-shanghai.myqcloud.com/blogpic/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0-4-17.png)