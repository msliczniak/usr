# edit to refect where mozjpeg is installed on your system
CJPEG="$HOME"'/usr/mozjpeg/bin/cjpeg'

# AVI is about 1% smaller than jpegtran optimized ffmpeg -q 3 but looks better
# at mozjpeg 82% quality.
# 3DS cannot display progressive jpgs.
# overshoot looks abjectly worse in usual case to my eyes at least in mozjpeg
# v3.0 - it does look better for black on white, but most film scenes are not
#like that.
COPTS='-qual 82 -noovershoot -baseline'

# There is a bug in OSX where there is a small but non-negligible chance
# that taskgated will crash with a SEGV. Since cjpeg is exec-ed so many times
# it's likely to happen for a movie. To work around this, retry once.
cjpeg() {
	"$CJPEG" $COPTS "$1" >'../o/'"$1" || "$CJPEG" $COPTS "$1" >'../o/'"$1"
}

# no need to exit, default for TERM
bail() {
	kill 0
	#exit 1
}

# gnu tail does not take the old fashioned  option: /usr/bin/tail +141c
exif() {
	{ /bin/rm "$t"'/o/0' && \
	  /bin/dd bs=20 skip=1 count=0 2<&- && \
	  /bin/cat "$t"'/j' - >"$t"'/o/0'; } <"$t"'/o/0' || bail
}

jfif0() {
	case $1 in
	  \*0)
		bail
		;;
	esac

	for i; do
		cjpeg "$i" || bail
	done
}

jfif() {
	case $1 in
	  \*?)
		return
		;;
	esac

	for i; do
		cjpeg "$i" || bail
	done
}

jp0() {
	cd "$t"'/i'"$2" || bail

	jfif0 *"$1"

	case "$2" in
	  0)
		# Can libavformat/avformat.h side_data handle exif instead?
		exif
		;;
	esac
}

jpg() {
	cd "$t"'/i'"$2" || bail

	jfif *"$1"
}

v() {
	/bin/mkdir -p "$t"'/i'"$2" "$t"'/o' || bail

	</dev/null ffmpeg -hide_banner -nostats -f nut -i "$t/$1$2v" \
	  -c copy -start_number "$2"'000' -bsf:v mjpeg2jpeg \
 	  -metadata_header_padding 0 \
	  -f image2 "$t"'/i'"$2"'/%d' || bail
	/bin/rm "$t/$1$2v" || bail

	jp0 0 "$2" &
	jpg 1 "$2" &
	jpg 2 "$2" &
	jpg 3 "$2" &
	jpg 4 "$2" &
	jpg 5 "$2" &
	jpg 6 "$2" &
	jpg 7 "$2" &
	jpg 8 "$2" &
	jpg 9 "$2" &

	wait || bail
	/bin/rm -r "$t"'/i'"$2" || bail
}

a() {
	</dev/null ffmpeg -hide_banner -f nut -i "$t/$1"'a' \
	  -thread_queue_size 512 -metadata_header_padding 0 \
	  -framerate 20 -f image2 -start_number 0 -i "$t"'/o/%d' \
	  -c copy -map 1:v -map 0:a \
	  -fflags +bitexact "$d/"'HNI_'"$1"'.AVI' || bail
	/bin/rm -r "$t/$1"'a' "$t"'/o' || bail
}
