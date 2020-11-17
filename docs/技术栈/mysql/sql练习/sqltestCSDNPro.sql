-- sql练习 https://blog.csdn.net/fashion2014/article/details/78826299/ CSDN 像风一样的勇士
use druid;
show tables;
select * from student; -- s_id s_name s_birth s_sex
select * from teacher;-- t_id t_name
select * from course; -- course teacher 多对多 c_id c_name t_id
select * from score; -- student course 多对多 s_id c_id s_score
-- 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数
-- 分析：连接查询,需要两张表 分别是 c_id=1 c_id=2 并且c_id=2的表里面score=null的也要查出来,
select 
	s.*,sc.c_id,sc.s_score as 01_score ,sc1.s_score as 02_score
from
	student s 
join 
	score sc 
on 
	s.s_id = sc.s_id and sc.c_id = 1
left join 
	score sc1
on
	s.s_id = sc1.s_id and sc1.c_id = 2
where
	sc.s_score > sc1.s_score;
-- 上面这个sql 会出现一种情况，就是如果2课程没有成绩，那么就不会显示出来，这个就需要
-- 在查c_id=2 的时候把s_score=null 的查出来
-- 注意：在判断null 的时候是用 is 而不是 =
select 
	s.*,sc.c_id,sc.s_score as 01_score ,sc1.s_score as 02_score
from
	student s 
join 
	score sc 
on 
	s.s_id = sc.s_id and sc.c_id = 1
left join 
	score sc1
on
	s.s_id = sc1.s_id and sc1.c_id = 2
where
	sc.s_score > sc1.s_score or sc1.s_score is null;


-- 还有一种写法,不用连接查询也可以写，那为什么要使用连接查询了
-- https://www.itranslater.com/qa/details/2325757413510611968
-- JOIN相比 where 的优势：能够控制join的顺序，扫描表的顺序，层次清晰，容易维护
select a.*,b.s_score as 01_score,c.s_score as 02_score from student a,score b,score c 
			where a.s_id=b.s_id 
			and a.s_id=c.s_id 
			and b.c_id='1' 
			and c.c_id='2' 
			and b.s_score>c.s_score;

-- 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数
-- 分析: 这个里面就比第1题多了一个坑，c_id=1，有两个课程没有分数，连接的时候查不出来，连null都不是
-- 有一种解决方案,就是先连接c_id=2 的表，会将所有有分数的记录查出来，但是这里是判断大于小于，如果是
-- 等于，两方都为null怎么解决
select 
	s.*,sc.c_id,sc1.s_score as 01_score,sc.s_score as 02_score
from
	student s
join 
	score sc
on
	s.s_id = sc.s_id and sc.c_id = 2 or sc.s_score is null
left join
	score sc1
on
	s.s_id = sc1.s_id and sc1.c_id = 1
where 
	sc.s_score > sc1.s_score or sc1.s_score is null;
    
    
-- 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
-- 有一门，两门，那么也需要按照三门成绩算，直接在sum()/3 或者使用avg函数
-- 笔记: where group by having order by
-- where  行级过滤 ，里面的列名称必须是数据库中定义的，在sql中定义
-- 的只能写在having里面 eg: Unknown column 'score' in 'where clause'
-- order by 排序 ASC DESC
-- group by 分组说明
-- having 组级过滤
-- limit 要检索的行数
select 
	s.*,sc.c_id,sc.s_score,sum(s_score)/3 as avg_score
from 
	student s
join
	score sc 
on 
	s.s_id = sc.s_id 
-- where avg_score >= 60
group by 
	s_id
having
	avg_score >= 60;
    

-- 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩 (包括有成绩的和无成绩的)
select 
	s.*,sc.c_id,sc.s_score,sum(s_score)/3 as avg_score
from 
	student s
join
	score sc 
on 
	s.s_id = sc.s_id
-- where avg_score >= 60
group by 
	s_id
having
	avg_score <= 60;
-- 上面这条语句，存在一个问题，如果有student 三门都没有成绩，就只在student表显示，score表中没有记录，连接查询查不出来
-- 上面这个问题不考虑，解决方案就是没有成绩的默认设置为0，或者null
select b.s_id,b.s_name,ROUND(AVG(a.s_score),2) as avg_score from 
	student b 
	left join score a on b.s_id = a.s_id
	GROUP BY b.s_id,b.s_name HAVING avg_score <60
	union
select a.s_id,a.s_name,0 as avg_score from 
	student a 
	where a.s_id not in (
				select distinct s_id from score);


-- 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩，以及所选课程的平均数
-- 分析
select 
	s.s_id,s.s_name,count(c_id) as total,sum(s_score) as sum_score,sum(sc.s_score)/count(c_id) as avg_score
from
	student s
join 
	score sc
on
	s.s_id = sc.s_id
group by 
	s.s_id;


-- 6、查询"李"姓老师的数量
-- 分析：模糊查询
select 
	count(t.t_id) 
from
	teacher t
where 
	t.t_name 
like 
	"李%"
group by t.t_id;

select 
	count(*) 
from
	teacher t
where 
	t.t_name 
like 
	"李%";
-- 上面这两种写法，当数据量大的时候谁的查询效率高，当group by里面字段很多的时候非常影响查询效率


-- 7、查询学过"张三"老师授课的同学的信息 
-- 分析：四张表，中间表示 score course 连接student course 连接teacher ，
-- 优化，连接查询的时候，数据量小的表放在后面，避免全表扫描
-- 笔记：left join ,左表中的数据都显示，不管在连接表中该记录是否存在，
-- 不存在就设置为null，join 只显示符合连接条件的
select 
	s.*,c.c_name,c.t_id,t.t_name
from
	student s
join 
	score sc
on
	s.s_id = sc.s_id
left join 
	course c
on	
	sc.c_id = c.c_id
join
	teacher t
on c.t_id = t.t_id and t.t_name = "张三";


-- 8、查询没学过"张三"老师授课的同学的信息 
-- 分析： != 效率不高，会导致全表扫描，还是四张表
select 
	s.*,c.c_name,c.t_id,t.t_name
from
	student s
join 
	score sc
on
	s.s_id = sc.s_id
left join 
	course c
on	
	sc.c_id = c.c_id
join
	teacher t
on c.t_id = t.t_id and t.t_name != "张三";
-- 上面这个查询出来的是很多条数据，有问题，查询所有s_id 与t_name 的连接信息，获取得到t_name 数组，然后用not in
-- in not in exists not exists 后面跟的都是数组
-- 子查询解决，这个连接查询不好处理
select
	s.*
from
	student s
where 
	s.s_id not in (
		select s1.s_id from student s1 join score sc on s1.s_id = sc.s_id where sc.c_id in (
			select c.c_id from course c join teacher t on c.t_id = t.t_id and t.t_name = "张三"
        )
    );


-- 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
-- 分析：子查询做简单一点
select 
	s.*,sc.c_id
from 
	student s
join 
	score sc
on
	s.s_id = sc.s_id and sc.c_id = 1
where 
	s.s_id 
in (select s1.s_id from student s1 join score sc1 on s1.s_id = sc1.s_id and sc1.c_id = 2 );
-- sql优化,只查student的信息，都不需要用连表查询，当需要其他表的数据的时候才用连接查询，
-- 不需要的话，其他表也可以当过滤条件，不要过分追求join on连接查询，对sql性能有一定影响
select s.* from 
	student s,score sc,score sc1
where
	s.s_id = sc.s_id and s.s_id = sc1.s_id and sc.c_id = 1 and sc1.c_id = 2;

-- 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
select 
	s.*
from
	student s
where
	s.s_id in 
    (select s1.s_id from student s1,score sc where s1.s_id = sc.s_id and sc.c_id = 1) 
and 
	s.s_id 
not in 
    (select s2.s_id from student s2,score sc1 where s2.s_id = sc1.s_id and sc1.c_id = 2);


-- 11、查询没有学全所有课程的同学的信息 
-- 分析:找出count(c_id) < 3
-- 笔记：聚合函数不能写在where里面，只能使用having
select 
	s.* 
from 
	student s
where 
	s.s_id not in (
	select 
		sc.s_id
	from
		score sc
	group by sc.s_id
	having count(sc.c_id)=(select count(*) from course)
);


-- 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息 
-- 分析：至少有一门课，直接使用in
-- 笔记：group_concat 返回一个字符串结果，去重显示
select
	s.*,group_concat
from
	student s,score sc1
where sc1.s_id = s.s_id and sc1.c_id in
    (select sc.c_id from score sc where sc.s_id=1)
group by s.s_id;
	

-- 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息 
-- 分析：方案1、首先选择课程数跟1一样的，然后排除1没上过，其他人上过的，然后排除1，这样会不会有漏选
select 
	s.*
from 
	student s
where 
	s.s_id 
in (select sc.s_id from score sc group by sc.s_id having count(sc.c_id) = 
		(select count(sc1.c_id) from score sc1 where sc1.s_id=1))
and
	s.s_id 
-- 排除课程数目相同，但是课程内容不同的，目前数据库里面的数据不存在这种设想
not in (select sc2.s_id from score sc2 where sc2.c_id not in 
		(select sc3.c_id from score sc3 where sc3.s_id=1))
and 
	s.s_id 
not in ('1');

-- 方案2：
select 
	s.*
from (select sc1.s_id,group_concat(sc1.c_id order by sc1.c_id) as group1 from score sc1 where sc1.s_id > 1 group by sc1.s_id) t1
inner join 
	(select sc2.s_id,group_concat(sc2.c_id order by sc2.c_id) as group2 from score sc2 where sc2.s_id = 1 group by sc2.s_id) t2
on t1.group1 = t2.group2
inner join
	student s 
on t1.s_id = s.s_id;

-- @尤尔小屋的猫 的解法，有一个致命的问题，如果，存在这样一种情况，就是课程数相同，课程内容不同了，
select * 
from Student 
where s_id in(
  select s_id   -- 3、步骤2中得到的学号是满足要求的
  from(select distinct(s_id), count(c_id) number 
       from Score 
       group by s_id)t1 -- 1、学号和所修课程分组的结果t1
       where number=(select count(c_id) number 
                     from Score 
                     group by s_id having s_id=7)  -- 2、改变的地方：使用学号01的课程数3来代替
  and s_id !=7  -- 01 本身排除
);

select * from score;
-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名 
-- 分析：筛选出学过张三的课的学生id，然后 not in
select s.* 
from student s
where s.s_id not in
	((select sc.s_id from score sc where sc.c_id =
	(select c.c_id from course c where c.t_id=
    (select t.t_id from teacher t where t.t_name='张三')) group by sc.s_id));


-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩 
-- 分析： 首先找出两门及以上不及格的同学的学号，然后再拼接信息
select s.*,ROUND(avg(sc1.s_score))
from 
	student s
join
	score sc1
on
	s.s_id = sc1.s_id
where s.s_id in (
select sc.s_id from score sc where sc.s_score < 60 group by sc.s_id 
having count(sc.c_id) >= 2)
group by s.s_id;


-- 16、检索"01"课程分数小于60，按分数降序排列的学生信息
-- 分析：先检索1课程且分数小于60 的s_id，
select 
	s.*,sc.s_score as 01_score
from 
	student s,score sc
where 
	sc.c_id = 1 and s.s_id = sc.s_id and sc.s_score < 60 
group by 
	s.s_id order by sc.s_score desc;


-- 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
select 
	sc.s_score as 1_score,sc1.s_score as 2_score,sc2.s_score as 3_score,avg(sc.s_score) as avgs
from
	score sc,score sc1,score sc2
where sc.c_id = 1 and sc1.c_id = 2 and sc2.c_id=3
group by sc.s_id;
-- 上面这个sql 查出来的2_score 和 3_score 都是有问题的

select * from score where c_id = 2;
select * from score where c_id = 3;

select sc.s_id,
	(select sc1.s_score from score sc1 where sc1.s_id=sc.s_id and sc1.c_id=1) as 语文,
    (select sc2.s_score from score sc2 where sc2.s_id=sc.s_id and sc2.c_id=2) as 数学,
    (select sc3.s_score from score sc3 where sc3.s_id=sc.s_id and sc3.c_id=3) as 英文,
    round(avg(sc.s_score),2) as 平均分
from
	score sc
group by
	sc.s_id
order by 
	平均分 desc;


-- 18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，
-- 最高分，最低分，平均分，及格率，中等率，优良率，优秀率
-- 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
-- 分析：有点存储过程的感觉,这个是比较复杂的，涉及到score 和 course这两张表
select 
	c.c_id,c.c_name,max(sc.s_score) as max_score ,min(sc.s_score) as min_score,avg(sc.s_score) as avg_score
from score sc
join course c
on sc.c_id = c.c_id
group by sc.c_id;
-- 上面这条语句没有写及格率(这个一般可以放到后端去处理)
select 
	c.c_id,c.c_name,max(sc.s_score) as max_score ,min(sc.s_score) as min_score,avg(sc.s_score) as avg_score
from score sc
join course c
on sc.c_id = c.c_id
group by sc.c_id;


-- 19、按各科成绩进行排序，并显示排名


-- 20、查询学生的总成绩并进行排名
select s.*,sum(sc.s_score) as sums
from student s
join score sc
on s.s_id = sc.s_id
group by s.s_id
order by sums DESC;

	
-- 21、查询不同老师所教不同课程平均分从高到低显示 


-- 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩


-- 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比


-- 24、查询学生平均成绩及其名次 


-- 25、查询各科成绩前三名的记录
			-- 1.选出b表比a表成绩大的所有组
			-- 2.选出比当前id成绩大的 小于三个的
            
-- 26、查询每门课程被选修的学生数
select c_id,count(s_id) from score group by c_id;

-- 27、查询出只有两门课程的全部学生的学号和姓名
select s.*,count(sc.c_id) as count_course
from student s
join score sc
on s.s_id = sc.s_id
group by s.s_id
having count(sc.c_id) = 2;

-- 28、查询男生、女生人数 

-- 29、查询名字中含有"风"字的学生信息

-- 30、查询同名同性学生名单，并统计同名人数

-- 31、查询1990年出生的学生名单

-- 32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列 

-- 33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩 

-- 34、查询课程名称为"数学"，且分数低于60的学生姓名和分数 

-- 35、查询所有学生的课程及分数情况； 

-- 36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数； 

-- 37、查询不及格的课程

-- 38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名；

-- 39、求每门课程的学生人数

-- 40、查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩

-- 41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 

-- 42、查询每门功成绩最好的前两名 

-- 43、统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列

-- 44、检索至少选修两门课程的学生学号

-- 45、查询选修了全部课程的学生信

-- 46、查询各学生的年龄
	-- 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一

-- 47、查询本周过生日的学生

-- 48、查询下周过生日的学生


-- 49、查询本月过生日的学生

-- 50、查询下月过生日的学生




