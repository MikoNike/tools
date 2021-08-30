package main

import (
	"flag"
	"fmt"
	"github.com/aliyun/aliyun-oss-go-sdk/oss"
	"os"
)

func inIt(osspath string, localfile string, bucketname string)  {

	// 创建OSSClient实例。
	// yourEndpoint填写Bucket所在地域对应的Endpoint。以华东1（杭州）为例，Endpoint填写为https://oss-cn-hangzhou.aliyuncs.com。
	// 阿里云账号AccessKey拥有所有API的访问权限，风险很高。强烈建议您创建并使用RAM用户进行API访问或日常运维，请登录RAM控制台创建RAM用户。
	client, err := oss.New("https://oss-cn-hangzhou.aliyuncs.com", "", "")
	if err != nil {
		fmt.Println("Error:", err)
		os.Exit(-1)
	}
	// 填写Bucket名称。bglog-all
	bucketName := bucketname
	// 填写Object完整路径。Object完整路径中不能包含Bucket名称。
	objectName := osspath
	// 填写本地文件的完整路径。如果未指定本地路径，则默认从示例程序所属项目对应本地路径中上传文件。
	locaFilename := localfile

	// 获取存储空间。
	bucket, err := client.Bucket(bucketName)
	if err != nil {
		fmt.Println("Error:", err)
		os.Exit(-1)
	}
	// 将本地文件分片，且分片数量指定为3。
	chunks, err := oss.SplitFileByPartNum(locaFilename, 3)
	fd, err := os.Open(locaFilename)
	defer fd.Close()

	// 设置存储类型为标准存储。
	storageType := oss.ObjectStorageClass(oss.StorageStandard)

	// 步骤1：初始化一个分片上传事件，并指定存储类型为标准存储。
	imur, err := bucket.InitiateMultipartUpload(objectName, storageType)
	// 步骤2：上传分片。
	var parts []oss.UploadPart
	for _, chunk := range chunks {
		fd.Seek(chunk.Offset, os.SEEK_SET)
		// 调用UploadPart方法上传每个分片。
		part, err := bucket.UploadPart(imur, fd, chunk.Size, chunk.Number)
		if err != nil {
			fmt.Println("Error:", err)
			os.Exit(-1)
		}
		parts = append(parts, part)
	}

	// 指定Object的读写权限为公共读，默认为继承Bucket的读写权限。
	objectAcl := oss.ObjectACL(oss.ACLPublicRead)

	// 步骤3：完成分片上传，指定文件读写权限为公共读。
	cmur, err := bucket.CompleteMultipartUpload(imur, parts, objectAcl)
	if err != nil {
		fmt.Println("Error:", err)
		os.Exit(-1)
	}
	fmt.Println("cmur:", cmur)
}

func main() {
	var osspath string
	var localfile string
	var bucketname string
	flag.StringVar(&osspath, "d", "default", "oss目录/+文件 ")
	flag.StringVar(&localfile, "f", "default", "本地文件绝对路径")
	flag.StringVar(&bucketname, "b", "game-data-backup", "默认存储桶 game-data-backup")
	flag.Parse()
	if osspath == "default" {
		fmt.Println("参数错误 使用--help 查看")

	}else {
		inIt(osspath, localfile, bucketname)
	}
}
