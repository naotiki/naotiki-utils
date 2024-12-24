SRC = $(shell find input -type f  -name "*.mp4")

SRC_FMT=mp4

OUT_FMT=mp4
####PRE_CONF=-c:v:0 hevc_nvenc -hwaccel cuda
PRE_CONF=-hwaccel cuda 
#PRE_CONF=-hwaccel cuda -hwaccel_output_format cuda #-c:v:0 h264_nvenc 
###PRE_CONF=-c:v:0 libvpx

#PRE_CONF=-hwaccel nvdec -c:v vp9_vaapi

CONF=-c:v h264_nvenc -vf scale=-1:720 -r 24 -an -f mp4 #-b:v 0 -cq 18

OUT = $(SRC:input/%.$(SRC_FMT)=output/%.$(OUT_FMT))
INPUT = ./input
OUTPUT = ./output

ffmpeg = docker run --gpus all --rm -v ./:/workspace ffmpeg-nvidia ffmpeg


convert: $(OUT)

$(OUTPUT)/%.$(OUT_FMT): $(INPUT)/%.$(SRC_FMT)
	$(ffmpeg) -y $(PRE_CONF) -i /workspace/$< $(CONF) /workspace/$@

clean:
	rm -rf $(OUTPUT)/*