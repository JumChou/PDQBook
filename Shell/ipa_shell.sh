#!/bin/sh

# shell_dir_path=$(cd `dirname $0`; pwd)
# project_path=${shell_dir_path%/*}
# echo "shell_dir_path=$shell_dir_path"
# echo "project_path=$project_path"

# xcode-select: error: tool ‘xcodebuild’ requires Xcode, 
# but active developer directory ‘/Library/Developer/CommandLineTools’ is a command line tools instance
# sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# ************************* 配置 Start ********************************

# 上传到蒲公英
__PGYER_U_KEY="4xxxxxxxxxxxxxxxxxxxxxxxxxxxxxb"
__PGYER_API_KEY="3xxxxxxxxxxxxxxxxxxxxxxxxxx5"

# 上传到 Fir
__FIR_API_TOKEN="xKKdjdldlodeikK626266skdkkddK"

# 提示符
__LINE_BREAK_LEFT="\n\033[32;1m************"
__LINE_BREAK_RIGHT="***************\033[0m\n"

# 证书
__CODE_SIGN_DISTRIBUTION="iPhone Distribution: WeiHaiSi Health Technology (Beijing) Co.,Ltd."
__CODE_SIGN_DEVELOPMENT="iPhone Developer: Chang Shen (63B2TULE3G)"

# 参数申明
scheme_name="PDQBook"
build_configuration="Debug"
is_xcworkspace=true
export_options_plist_path=""
is_auto_open_folder=true


# 指定Target 添加了多个Target时使用
# echo "\033[36;1m请选择 SCHEME (输入序号, 按回车即可) \033[0m"
# echo "\033[33;1m1. APPxxxxDev \033[0m"
# echo "\033[33;1m2. APPxxxxTest \033[0m"
# echo "\033[33;1m3. APPxxxxRelease \033[0m"
# echo "\033[33;1m4. APPxxxxAppStore \033[0m\n"

# read parameter
# if [[ "${parameter}" == "1" ]]; then
# scheme_name="APPxxxxDev"
# elif [[ "${parameter}" == "2" ]]; then
# scheme_name="APPxxxxTest"
# elif [[ "${parameter}" == "3" ]]; then
# scheme_name="APPxxxxRelease"
# elif [[ "${parameter}" == "4" ]]; then
# scheme_name="APPxxxxAppStore"
# else
# echo "${__LINE_BREAK_LEFT} 您输入参数无效! exit! ${__LINE_BREAK_RIGHT}"
# exit 1
# fi


# 指定打包编译的模式，如：Release, Debug...
echo "\033[36;1m请选择 BUILD_CONFIGURATION (输入序号, 按回车即可) \033[0m"
echo "\033[33;1m1. Debug \033[0m"
echo "\033[33;1m2. Release \033[0m"

read parameter
if [[ "${parameter}" == "1" ]]; then
build_configuration="Debug"
elif [[ "${parameter}" == "2" ]]; then
build_configuration="Release"
else
echo "${__LINE_BREAK_LEFT} 您输入 BUILD_CONFIGURATION 参数无效!!! ${__LINE_BREAK_RIGHT}"
exit 1
fi


# 工程类型(.xcworkspace项目,赋值true; .xcodeproj项目, 赋值false)
echo "\033[36;1m请选择是否是.xcworkspace项目(输入序号, 按回车即可) \033[0m"
echo "\033[33;1m1. 是 \033[0m"
echo "\033[33;1m2. 否 \033[0m"

read parameter
if [[ "${parameter}" == "1" ]]; then
is_xcworkspace=true
elif [[ "${parameter}" == "2" ]]; then
is_xcworkspace=false
else
echo "${__LINE_BREAK_LEFT} 您输入是否是.xcworkspace项目 参数无效!!! ${__LINE_BREAK_RIGHT}"
exit 1
fi


# AdHoc, AppStore, Enterprise, Development
echo "\033[36;1m请选择打包方式(输入序号, 按回车即可) \033[0m"
echo "\033[33;1m1. AppStore \033[0m"
echo "\033[33;1m2. Development \033[0m"
# echo "\033[33;1m3. AdHoc \033[0m"
# echo "\033[33;1m4. Enterprise \033[0m\n"

read parameter
if [[ "${parameter}" == "1" ]]; then
export_options_plist_path="./Shell/AppStoreExportOptions.plist"
elif [[ "${parameter}" == "2" ]]; then
export_options_plist_path="./Shell/DevelopmentExportOptions.plist"
# elif [[ "${parameter}" == "3" ]]; then
# export_options_plist_path="./Shell/AdHocExportOptions.plist"
# elif [[ "${parameter}" == "4" ]]; then
# export_options_plist_path="./Shell/EnterpriseExportOptions.plist"
else
echo "${__LINE_BREAK_LEFT} 您输入的打包方式参数无效!!! ${__LINE_BREAK_RIGHT}"
exit 1
fi


# 选择内测网站 用Fir或者pgyer !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo "\033[36;1m请选择ipa上传平台 (输入序号, 按回车即可) \033[0m"
echo "\033[33;1m1. None \033[0m"
echo "\033[33;1m2. AppStore \033[0m"
# echo "\033[33;1m2. Pgyer \033[0m"
# echo "\033[33;1m3. Fir \033[0m"
# echo "\033[33;1m4. Pgyer and Fir \033[0m\n"
read parameter
__UPLOAD_TYPE_SELECTED="${parameter}"


# 成功出包后是否自动打开文件夹
echo "\033[36;1m成功出包后是否自动打开文件夹(输入序号, 按回车即可) \033[0m"
echo "\033[33;1m1. 是 \033[0m"
echo "\033[33;1m2. 否 \033[0m"

read parameter
if [[ "${parameter}" == "1" ]]; then
is_auto_open_folder=true
elif [[ "${parameter}" == "2" ]]; then
is_auto_open_folder=false
else
echo "${__LINE_BREAK_LEFT} 您输入的成功出包后是否自动打开文件夹 参数错误!!! ${__LINE_BREAK_RIGHT}"
exit 1
fi


# ************************* 自动打包部分 ********************************
# 打包计时
__CONSUME_TIME=0

echo "${__LINE_BREAK_LEFT} Start automatically packaging... ${__LINE_BREAK_RIGHT}"
echo "Use export options plist = ${export_options_plist_path}"

# 回退到工程目录
cd ../
__PROGECT_PATH=`pwd`
echo "Switch into project path = ${__PROGECT_PATH}"

# 获取项目名称
__PROJECT_NAME=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`

# 已经指定Target的Info.plist文件路径
# __CURRENT_INFO_PLIST_NAME="${scheme_name}-Info.plist"
__CURRENT_INFO_PLIST_NAME="Info.plist"
# 获取 Info.plist 路径
__CURRENT_INFO_PLIST_PATH="${__PROJECT_NAME}/${__CURRENT_INFO_PLIST_NAME}"
# 当前的plist文件路径
echo "Info.plist path = ${__CURRENT_INFO_PLIST_PATH}"
# 获取版本号
__BUNDLE_VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${__CURRENT_INFO_PLIST_PATH}`
# 获取编译版本号
__BUNDLE_BUILD_VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${__CURRENT_INFO_PLIST_PATH}`
# 打印版本信息
echo "version=${__BUNDLE_VERSION}, build_version=${__BUNDLE_BUILD_VERSION}"

# 编译生成文件目录
__EXPORT_PATH="./build"
# 指定输出文件目录不存在则创建
if test -d "${__EXPORT_PATH}" ; then
rm -rf ${__EXPORT_PATH}
else
mkdir -pv ${__EXPORT_PATH}
fi

# 归档文件路径
__EXPORT_ARCHIVE_PATH="${__EXPORT_PATH}/${scheme_name}.xcarchive"
# ipa 导出路径
__EXPORT_IPA_PATH="${__EXPORT_PATH}"
# 获取时间 如:201706011145
__CURRENT_DATE="$(date +%Y%m%d_%H%M%S)"
# ipa 名字
__IPA_NAME="${scheme_name}_V${__BUNDLE_BUILD_VERSION}_${__CURRENT_DATE}"
echo "ipa file name = ${__IPA_NAME}"

echo "${__LINE_BREAK_LEFT} Building begin... ${__LINE_BREAK_RIGHT}"
if ${is_xcworkspace}; then
	#echo "${__LINE_BREAK_LEFT} 开始pod ${__LINE_BREAK_RIGHT}"
	#pod install --verbose --no-repo-update
	#echo "${__LINE_BREAK_LEFT} pod完成 ${__LINE_BREAK_RIGHT}"

	# step 1. Clean
	xcodebuild clean  -workspace ${__PROJECT_NAME}.xcworkspace \
	-scheme ${scheme_name} \
	-configuration ${build_configuration}
	
	# 声明code_sign变量
	__code_sign_identity="${__CODE_SIGN_DISTRIBUTION}"

	if [[ ${build_configuration} == "Debug" ]]; then
	echo "build configuration = xcworkspace-Debug"
	__code_sign_identity="${__CODE_SIGN_DEVELOPMENT}"

	elif [[ ${build_configuration} == "Release" ]]; then
	echo "build configuration = xcworkspace-Release"
	__code_sign_identity="${__CODE_SIGN_DISTRIBUTION}"
	fi

	echo "${__LINE_BREAK_LEFT} CODE_SIGN_IDENTITY = ${__code_sign_identity} ${__LINE_BREAK_RIGHT}"
	# step 2. Archive
	xcodebuild archive  -workspace ${__PROJECT_NAME}.xcworkspace \
	-scheme ${scheme_name} \
	-configuration ${build_configuration} \
	-archivePath ${__EXPORT_ARCHIVE_PATH} \
	CFBundleVersion=${__BUNDLE_BUILD_VERSION} \
	-destination generic/platform=ios \
	CODE_SIGN_IDENTITY="${__code_sign_identity}"

else
	# step 1. Clean
	xcodebuild clean  -project ${__PROJECT_NAME}.xcodeproj \
	-scheme ${scheme_name} \
	-configuration ${build_configuration} \
	-alltargets

	# 声明code_sign变量
	__code_sign_identity="${__CODE_SIGN_DISTRIBUTION}"

	if [[ ${build_configuration} == "Debug" ]] ; then
	echo "build configuration = xcodeproj-Debug"
	__code_sign_identity="${__CODE_SIGN_DEVELOPMENT}"

	elif [[ ${build_configuration} == "Release" ]]; then
	echo "build configuration = xcodeproj-Release"
	fi

	echo "${__LINE_BREAK_LEFT} CODE_SIGN_IDENTITY = ${__code_sign_identity} ${__LINE_BREAK_RIGHT}"
	# step 2. Archive
	xcodebuild archive  -project ${__PROJECT_NAME}.xcodeproj \
	-scheme ${scheme_name} \
	-configuration ${build_configuration} \
	-archivePath ${__EXPORT_ARCHIVE_PATH} \
	CFBundleVersion=${__BUNDLE_BUILD_VERSION} \
	-destination generic/platform=ios \
	CODE_SIGN_IDENTITY="${__code_sign_identity}"
fi


# 检查是否构建成功
# xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if test -d "${__EXPORT_ARCHIVE_PATH}" ; then
echo "${__LINE_BREAK_LEFT} Build Success!!! ${__LINE_BREAK_RIGHT}"
else
echo "${__LINE_BREAK_LEFT} Build Failed!!! ${__LINE_BREAK_RIGHT}"
exit 1
fi


echo "${__LINE_BREAK_LEFT} Export Exporting ipa... ${__LINE_BREAK_RIGHT}"
xcodebuild -exportArchive -archivePath ${__EXPORT_ARCHIVE_PATH} \
-exportPath ${__EXPORT_IPA_PATH} \
-destination generic/platform=ios \
-exportOptionsPlist "${export_options_plist_path}" \
-allowProvisioningUpdates

# 修改ipa文件名称
mv ${__EXPORT_IPA_PATH}/${scheme_name}.ipa ${__EXPORT_IPA_PATH}/${__IPA_NAME}.ipa
# 检查文件是否存在
if test -f "${__EXPORT_IPA_PATH}/${__IPA_NAME}.ipa" ; then
echo "${__LINE_BREAK_LEFT} Export ${__IPA_NAME}.ipa Success!!! ${__LINE_BREAK_RIGHT}"

	if [[ "${__UPLOAD_TYPE_SELECTED}" == "2" ]] ; then
	echo "${__LINE_BREAK_LEFT} Upload to AppStore... ${__LINE_BREAK_RIGHT}"
	#验证并上传到App Store
	# 将-u 后面的XXX替换成自己的AppleID的账号，-p后面的XXX替换成自己的密码
	altoolPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
	"$altoolPath" --validate-app -f ${__EXPORT_IPA_PATH}/${__IPA_NAME}.ipa -u job@wehealthsystem.com -p q1w2e3r4t5ON -t ios --output-format xml
	"$altoolPath" --upload-app -f ${__EXPORT_IPA_PATH}/${__IPA_NAME}.ipa -u job@wehealthsystem.com -p q1w2e3r4t5ON -t ios --output-format xml
	echo "${__LINE_BREAK_LEFT} Upload Session Finished${__LINE_BREAK_RIGHT}"
	fi

# if [[ "${__UPLOAD_TYPE_SELECTED}" == "1" ]] ; then
# echo "${__LINE_BREAK_LEFT} 您选择了不上传到内测网站 ${__LINE_BREAK_RIGHT}"
# elif [[ "${__UPLOAD_TYPE_SELECTED}" == "2" ]]; then

# curl -F "file=@${__EXPORT_IPA_PATH}/${__IPA_NAME}.ipa" \
# -F "uKey=$__PGYER_U_KEY" \
# -F "_api_key=$__PGYER_API_KEY" \
# "http://www.pgyer.com/apiv1/app/upload"

# echo "${__LINE_BREAK_LEFT} 上传 ${__IPA_NAME}.ipa 包 到 pgyer 成功 🎉 🎉 🎉 ${__LINE_BREAK_RIGHT}"
# elif [[ "${__UPLOAD_TYPE_SELECTED}" == "3" ]]; then

# fir login -T ${__FIR_API_TOKEN}
# fir publish "${__EXPORT_IPA_PATH}/${__IPA_NAME}.ipa"

# echo "${__LINE_BREAK_LEFT} 上传 ${__IPA_NAME}.ipa 包 到 fir 成功 🎉 🎉 🎉 ${__LINE_BREAK_RIGHT}"
# elif [[ "${__UPLOAD_TYPE_SELECTED}" == "4" ]]; then

# fir login -T ${__FIR_API_TOKEN}
# fir publish "${__EXPORT_IPA_PATH}/${__IPA_NAME}.ipa"

# echo "${__LINE_BREAK_LEFT} 上传 ${__IPA_NAME}.ipa 包 到 fir 成功 🎉 🎉 🎉 ${__LINE_BREAK_RIGHT}"

# curl -F "file=@{${__EXPORT_IPA_PATH}/${__IPA_NAME}.ipa}" \
# -F "uKey=$__PGYER_U_KEY" \
# -F "_api_key=$__PGYER_API_KEY" \
# "http://www.pgyer.com/apiv1/app/upload"

# echo "${__LINE_BREAK_LEFT} 上传 ${__IPA_NAME}.ipa 包 到 pgyer 成功 🎉 🎉 🎉 ${__LINE_BREAK_RIGHT}"
# else
# echo "${__LINE_BREAK_LEFT} 您输入 上传内测网站 参数无效!!! ${__LINE_BREAK_RIGHT}"
# exit 1
# fi

# 自动打开文件夹
if ${is_auto_open_folder}; then
open ${__EXPORT_IPA_PATH}
fi

fi

# 输出打包总用时
# echo "${__LINE_BREAK_LEFT} Shell archive cost:${SECONDS}s ${__LINE_BREAK_RIGHT}"







