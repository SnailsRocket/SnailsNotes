### maven镜像仓库替换成阿里云镜像仓库

安装好maven后，更新maven仓库的速度特别慢，或有有时候直接出现假死状态。



#### 解决方案

在本地的maven的setting配置文件中添加阿里云镜像文件地址

```xml
  <!-- 阿里镜像仓库 -->
  <mirrors>
    <mirror>
        <id>alimaven</id>
        <name>aliyun maven</name>
        <url>
            http://maven.aliyun.com/nexus/content/groups/public/
        </url>
        <mirrorOf>central</mirrorOf>
    </mirror>
  </mirrors>
```



#### 由于阿里云的maven已经做了https升级和仓库细化，以前的配置(上面的配置已经失效，下面是最新的配置)

```xml
<mirrors>
	<mirror>
		<id>aliyun-public</id>
		<mirrorOf>*</mirrorOf>
		<name>aliyun public</name>
		<url>https://maven.aliyun.com/repository/public</url>
	</mirror>

	<mirror>
		<id>aliyun-central</id>
		<mirrorOf>*</mirrorOf>
		<name>aliyun central</name>
		<url>https://maven.aliyun.com/repository/central</url>
	</mirror>

	<mirror>
		<id>aliyun-spring</id>
		<mirrorOf>*</mirrorOf>
		<name>aliyun spring</name>
		<url>https://maven.aliyun.com/repository/spring</url>
	</mirror>

	<mirror>
		<id>aliyun-spring-plugin</id>
		<mirrorOf>*</mirrorOf>
		<name>aliyun spring-plugin</name>
		<url>https://maven.aliyun.com/repository/spring-plugin</url>
	</mirror>

	<mirror>
		<id>aliyun-apache-snapshots</id>
		<mirrorOf>*</mirrorOf>
		<name>aliyun apache-snapshots</name>
		<url>https://maven.aliyun.com/repository/apache-snapshots</url>
	</mirror>

	<mirror>
		<id>aliyun-google</id>
		<mirrorOf>*</mirrorOf>
		<name>aliyun google</name>
		<url>https://maven.aliyun.com/repository/google</url>
	</mirror>

	<mirror>
		<id>aliyun-gradle-plugin</id>
		<mirrorOf>*</mirrorOf>
		<name>aliyun gradle-plugin</name>
		<url>https://maven.aliyun.com/repository/gradle-plugin</url>
	</mirror>

	<mirror>
		<id>aliyun-jcenter</id>
		<mirrorOf>*</mirrorOf>
		<name>aliyun jcenter</name>
		<url>https://maven.aliyun.com/repository/jcenter</url>
	</mirror>

	<mirror>
		<id>aliyun-releases</id>
		<mirrorOf>*</mirrorOf>
		<name>aliyun releases</name>
		<url>https://maven.aliyun.com/repository/releases</url>
	</mirror>

	<mirror>
		<id>aliyun-snapshots</id>
		<mirrorOf>*</mirrorOf>
		<name>aliyun snapshots</name>
		<url>https://maven.aliyun.com/repository/snapshots</url>
	</mirror>

	<mirror>
		<id>aliyun-grails-core</id>
		<mirrorOf>*</mirrorOf>
		<name>aliyun grails-core</name>
		<url>https://maven.aliyun.com/repository/grails-core</url>
	</mirror>

	<mirror>
		<id>aliyun-mapr-public</id>
		<mirrorOf>*</mirrorOf>
		<name>aliyun mapr-public</name>
		<url>https://maven.aliyun.com/repository/mapr-public</url>
	</mirror>
  </mirrors>
```

