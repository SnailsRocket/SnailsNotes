### mavenclean

#### description

> 有时候，我们下载maven依赖的时候，因为网络等问题，导致maven下载失败，这个时候会生成文件后缀为lastUpdated的文件，这种文件分布在mavenrepository的个个文件夹中。手动一个个的删除的话，就太耗时了。怎么说成大胖都是学过Java的人，所以就写了一个工具类来快速删除这种文件。



```java 
import java.io.File;

/**
 * @Author: Xubo
 * @Date: 2019/9/26 14:23
 * maven仓库清理
 */
public class MavenClean {

    private static int emptyDirectoryNum = 0;
    private static int lastUpdateNum = 0;

    private int emptyNum = 0;

    /**
     * 要清理的内容包括
     * 1. 所有的.lastUpdated 结尾的文件
     * 2. 清理之后的所有空文件夹
     */
    public static void main(String[] args) {
        final String mavenRepositoryPath = "D:\\maven_repository";
        File f = new File(mavenRepositoryPath);
//        静态方法里面调用非静态方法，需要先创建一个mavenclean对象，然后通过mavenclean这个对象调用它的非静态方法
        MavenClean clean = new MavenClean();
        //while(clean.emptyNum!=0&&clean.emptyNum!=-1) {
        //这里一次执行清理不完 多次执行直到打印出0
        clean.cleanLastUpdate(f);
        clean.cleanEmptyDirectory(f);
        System.out.println("删除文件 " + lastUpdateNum + "个, 删除空文件夹 " + emptyDirectoryNum + "个");
        System.out.println(clean.emptyNum);
        //}
    }

    /**
     * 删除所有.lastUpdated结尾的文件
     * @param f path
     */
    public void cleanLastUpdate(File f) {
        if (f != null) {
            if (f.getName().endsWith("lastUpdated")) {
                lastUpdateNum++;
                System.out.println("要删除的文件是：" + f.getAbsolutePath());
                f.delete();
            }
//            递归查找
            if (f.isDirectory()) {
                File[] fs = f.listFiles();
                for (File fItem : fs) {
                    cleanLastUpdate(fItem);
                }
            }
        }
    }

    /**
     * 删除所有的空文件夹
     *
     * @param f
     */
    public int cleanEmptyDirectory(File f) {
        if (f != null && f.isDirectory()) {
            File[] fs = f.listFiles();
            if (fs.length == 0) {
                emptyDirectoryNum++;
                emptyNum++;
                System.out.println(f.getAbsolutePath() + " 是空文件夹被删除");
                f.delete();
            } else {
                for (File fc : fs) {
                    cleanEmptyDirectory(fc);
                }
            }
        }
        return emptyNum;
    }
}

```

