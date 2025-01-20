#!/bin/bash
# 封装选择菜单的函数（选项）
select_option() {
    # 定义枚举项
    options=("视频" "音频" "Quit")
    # 使用 select 命令来创建一个简单的菜单
    PS3="$1"
    select opt in "${options[@]}"; do
        case $opt in
            "视频")
                echo 1
                break
                ;;
            "音频")
                echo 2
                break
                ;;
            "Quit")
                echo 3
                break
                ;;
            *)
                echo 4
                ;;
        esac
    done
}
# 封装选择菜单的函数（视频格式）
select_vedio_format() {
    # 定义枚举项
    options=("mp4(H.264/AAC)" 
    "mkv(H.264, H.265, VP9)"
    "avi(DivX, XviD, MJPEG)" 
    "mov(H.264, ProRes, HEVC)"
    "flv(Flash Video)"
    "webm(VP8, VP9)"
    "wmv(Windows Media Video)"
    "mpg(MPEG-1, MPEG-2)"
    "mpeg(MPEG-1, MPEG-2)"
    "3gp(3GPP)"
    "ogv(Theora)" 
    "Quit")
    # 使用 select 命令来创建一个简单的菜单
    PS3="$1"
    select opt in "${options[@]}"; do
        case $opt in
        "mp4(H.264/AAC)") 
            echo "mp4"
            break;;
        "mkv(H.264, H.265, VP9)")
            echo "mkv"
            break;;
        "avi(DivX, XviD, MJPEG)")
            echo "avi"
            break;;
        "mov(H.264, ProRes, HEVC)")
            echo "mov"
            break;;
        "flv(Flash Video)")
            echo "flv"
            break;;
        "webm(VP8, VP9)")
            echo "webm"
            break;;
        "wmv(Windows Media Video)")
            echo "wmv"
            break;;
        "mpg(MPEG-1, MPEG-2)")
            echo "mpg"
            break;;
        "mpeg(MPEG-1, MPEG-2)")
            echo "mpeg"
            break;;
        "3gp(3GPP)")
            echo "3gp"
            break;;
        "ogv(Theora)")
            echo "ogv"
            break;;
        "Quit")
            echo "0"
            break
            ;;
        *)
            echo "1"
            ;;
        esac
    done
}
# 封装选择菜单的函数（音频格式）
select_music_format() {
    # 定义枚举项
    options=("mp3(MPEG-1 Audio Layer 3)"
    "aac(Advanced Audio Codec)"
    "ogg(Ogg Vorbis)"
    "flac(Free Lossless Audio Codec)"
    "wav(Waveform Audio)"
    "m4a(Apple Audio)"
    "alac(Apple Lossless Audio Codec)"
    "wma(Windows Media Audio)"
    "opus(Opus)"
    "Quit")
    
    # 使用 select 命令来创建一个简单的菜单
    PS3="$1"
    select opt in "${options[@]}"; do
        case $opt in
            "mp3(MPEG-1 Audio Layer 3)")
                echo "mp3"
                break;;
            "aac(Advanced Audio Codec)")
                echo "aac"
                break;;
            "ogg(Ogg Vorbis)")
                echo "ogg"
                break;;
            "flac(Free Lossless Audio Codec)")
                echo "flac"
                break;;
            "wav(Waveform Audio)")
                echo "wav"
                break;;
            "m4a(Apple Audio)")
                echo "m4a"
                break;;
            "alac(Apple Lossless Audio Codec)")
                echo "alac"
                break;;
            "wma(Windows Media Audio)")
                echo "wma"
                break;;
            "opus(Opus)")
                echo "opus"
                break;;
            "Quit")
                echo "0"
                break;;
            *)
                echo "无效选择，请重新选择一个有效的选项。"
                ;;
        esac
    done
}

# 调用函数并传入菜单提示信息
selected_source=$(select_option "请选择输入文件类型：")
selected_target=$(select_option "请选择输出文件类型：")
selected_source_format=""
selected_target_format=""

# 验证输入项，并获取
if [[ $selected_target -eq 3 || $selected_target -eq 4 || $selected_source -eq 3 || $selected_source -eq 4 ]]; then
    echo "haha"
    exit 0
elif [[ $selected_source -gt $selected_target ]]; then
    echo "音频无法转视频"
    exit 0
else
    if [[ $selected_source -eq 1 ]]; then
        selected_source_format=$(select_vedio_format "请选择“输入视频”格式：")
        if [[ $selected_target -eq 1 ]]; then
            selected_target_format=$(select_vedio_format "请选择“输出视频”格式：")
        elif [[ $selected_target -eq 2 ]]; then
            selected_target_format=$(select_music_format "请选择“输出音频”格式：")
        fi
    elif [[ $selected_source -eq 2 ]]; then
        selected_source_format=$(select_music_format "请选择“输入音频”格式：")
        if [[ $selected_target -eq 2 ]]; then
            selected_target_format=$(select_music_format "请选择“输出音频”格式：")
        fi
    fi
fi
echo "请输入 源文件所在位置"
read source_path
echo "请输入 输出文件所在位置（若原文件不存在则会创建，不输入则默认源文件路径）"
read target_path
if [ -z "$source_path" ];then
    source_path=$(pwd)
elif [ -z "$target_path" ];then
    target_path=$source_path
elif [ ! -d "$target_path" ];then
    mkdir $target_path
fi
# 屏蔽重命名逻辑，解决可能造成文件丢失的bug
# for file in "$source_path"/*.$selected_source_format; do
#     # 确保是文件而不是目录
#     if [ -f "$file" ]; then
#         # 提取文件名并去掉路径
#         filename=$(basename "$file")
#         # 去掉文件名中的空格
#         new_filename=$(echo "$filename" | tr -d ' ')
#         # 如果文件名发生了变化，重命名文件
#         if [ "$filename" != "$new_filename" ]; then
#             mv "$file" "$target_directory/$new_filename"
#         fi
#     fi
# done

# 再次遍历文件夹，过滤出所有 selected_source_format 后缀的文件
success_count=0
faild_count=0
for file in "$source_path"/*.$selected_source_format; do
    # 确保是文件而不是目录
    if [ -f "$file" ]; then
        (( success_count++ ))
        input_file_name="$(basename "$file")"
        output_file_name="$(basename "$file" .$selected_source_format)"
        echo "转换：$input_file_name"
        
        if [[ $selected_source -eq 1 && $selected_target -eq 1 ]];then
            # 视频->视频
            ffmpeg -i "$input_file_name" -c:v copy -c:a copy "$output_file_name.$selected_target_format" > ffmpeg_output.log 2>&1
        elif [[ $selected_source -eq 2 && $selected_target -eq 2 ]];then
            # 音频 -> 音频
            ffmpeg -i "$input_file_name" -c copy "$output_file_name.$selected_target_format" > ffmpeg_output.log 2>&1
        elif [[ $selected_source -eq 1 && $selected_target -eq 2 ]];then
            # 视频 -> 音频
            if [[ $selected_target_format == "mp3" ]];then
                ffmpeg -i "$input_file_name" -vn -acodec mp3 "$output_file_name.$selected_target_format" > ffmpeg_output.log 2>&1
            elif [[ $selected_target_format == "wav" ]];then
                ffmpeg -i "$input_file_name" -vn -acodec pcm_s16le "$output_file_name.$selected_target_format" > ffmpeg_output.log 2>&1
            elif [[ $selected_target_format == "aac"
            || $selected_target_format == "ogg"
            || $selected_target_format == "m4a" ]];then
                ffmpeg -i "$input_file_name"  -vn -acodec copy "$output_file_name.$selected_target_format" > ffmpeg_output.log 2>&1
            elif [[ $selected_target_format == "flac" ]];then
                ffmpeg -i "$input_file_name" -vn -acodec flac "$output_file_name.$selected_target_format" > ffmpeg_output.log 2>&1
            elif [[ $selected_target_format == "m4a" ]];then
                ffmpeg -i "$input_file_name" -vn -c:a alac "$output_file_name.$selected_target_format" > ffmpeg_output.log 2>&1
            elif [[ $selected_target_format == "wma" ]];then
                ffmpeg -i "$input_file_name" -vn -acodec wmav2 -ab 128k "$output_file_name.$selected_target_format" > ffmpeg_output.log 2>&1
            elif [[ $selected_target_format == "opus" ]];then
                ffmpeg -i "$input_file_name" -vn -c:a libopus "$output_file_name.$selected_target_format" > ffmpeg_output.log 2>&1
            fi
        fi
    else
        (( faild_count++ ))
    fi
done
echo "转换结束，成功[$success_count]个，失败[$faild_count]个"