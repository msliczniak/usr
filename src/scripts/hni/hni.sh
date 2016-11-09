#!/bin/sh
PS1=''; PS2=''; export PS1 PS2  # quiet interactive shell invocation

# In case we are not run from an interactive shell, do the following
# to create a new process group.
i=`/bin/ps -jp $$ | /usr/bin/awk 'BEGIN { e = 1 }

NR == 1 {
	for (i = 1; i <= NF; i++) if ($i ~ /[Pp][Gg][Ii][Dd]/) next
	exit
}

NR == 2  {
	print $i
	e = 0
	exit
}

END { exit e }'` || exit 127

case $- in
  *e*)  # second invokation under the control of an interactive shell
	case "$i" in
  	  "$1") # PGID remained the same, bail
		exit 125
		;;
	esac

	set +e  # don't bail on errors immediately
	shift   # remove pid arg
	;;
  *)    # initial invocation
	case "$i" in
  	  $$)   # already in our own process group
		;;
  	  *)    # start an interactive shell to create a process group
		exec /bin/sh -ic '/bin/sh -e "$0" "$@"' "$0" "$i" "$@"
		exit 126
		;;
	esac

	;;
esac

# in a process group and an non-interactive shell, that way kill 0
# hits the entire process group and there is no process monitoring
# or creation of other process groups

# if the 3DS does not notice the new files, just delete the cache:
# Nintendo\ 3DS/Private/00020400/phtcache.bin

# since we use TERM on error and want awk to die with PIPE on error too
trap - 13 15 || exit

# disable color in ffmpeg/ffprobe diagnostics
unset AV_LOG_FORCE_COLOR
AV_LOG_FORCE_NOCOLOR=1; NOCOLOR=1
export AV_LOG_FORCE_NOCOLOR; export NOCOLOR

unset d
unset t

case $# in
  2)
	;;
  *)
	echo 'Usage: hni outdir video' >&2
	exit 2
esac

d="$1"; v="$2"

case "$1" in
  100[A-Z][A-Z][A-Z][0-9][0-9] )
	echo 'hni: outdir cannot begin with "100"' >&2
	exit 2
	;;
  1[0-9][0-9][A-Z][A-Z][A-Z]00 ) 
	echo 'hni: outdir cannot end with "00"' >&2
	exit 2
	;;
  1[0-9][0-9][A-Z][A-Z][A-Z][0-9][0-9] )
	;;
  *)
	echo 'hni: outdir must be of form "1##ABC##"' >&2
	exit 2
	;;
esac

# width can be between 480 and 400, below 400 it starts shrinking on 3ds
# height can be no larger than 240, how ever many lines it is is how many
# are used on 3ds screen
# hieght and with have to be multiples of 16

# do not trust sample_aspect_ratio OR display_aspect_ratio
# JUST ASSUME they are close to 1:1 sample taking into account half
# horizontal SBS and then something like 16:9 just dividonig w by h

# >>> (646.0 / 364) / (5.0 / 3)
# 1.0648351648351648
# >>> (646.0 / 364) / (5.0 / 3) * 240
# 255.56043956043956
# >>> 240 / ((646.0 / 364) / (5.0 / 3))
# 225.38699690402476
# >>> 240 * ((5.0 / 3) / (646.0 / 364))
# 225.38699690402478
# >>> 240 * ((5.0 / 3) * (364.0 / 646))
# 225.38699690402476
# >>> (240 * 5.0 * 364) / (646 * 3)
# 225.38699690402476
# >>> 240 * 5.0 / 3
# 400.0
# >>> 400.0 * 364 / 646
# 225.38699690402476

set - \
`<&- 2>/dev/null ffmpeg -nostdin -v error -i "$2" -an -c:v copy -f nut - | \
  ffprobe -v quiet -show_streams - | \
  awk -F= '
$1 == "width" { w=$2; if (h) exit; next }
$1 == "height" { h=$2; if (w) exit; next }
# w and h need to be divisible by 2 in H.264
END {
	x = h * 400 / w
	if (x < 240) {
		w = 400
		h = int((x + 8) / 16) * 16 
	} else {
		x = w * 240 / h
		h = 240
		w = int((x + 8) / 16) * 16 
	}

	print w,  h
}'`

case "$#" in
  2)
	;;
  *)
	echo 'hni: cannot determine video resolution' >&2
	exit 1
	;;
esac

w="$1"; h="$2"

/bin/mkdir "$d" || exit
t=`/usr/bin/mktemp -d /tmp/hni-XXXXX` || exit

# ignore all signals so that as the cjpegs die they do not kill the clean-up
trap 'trap "" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24'\
' 25 26 27 28 29 30 31; /bin/rmdir "$d" 2>/dev/null; /bin/rm -rf "$t"' 0

echo >"$t"'/j'
/usr/bin/touch -r "$v" "$t"'/j' || exit

#</dev/null ffmpeg -nostats -hide_banner -nostdin \
#  -i "$v" -map 0:v:0 \
#  -r 20 -vf scale="$w":"$h" -pix_fmt rgb48be -c:v rawvideo -f image2pipe \
#  pipe:1 | \
#while { echo 'P6'; echo "$w" "$h"; echo '65535'; /bin/dd count="$b" 2>&-; } | \
#cjpeg 2>&-; do :; done | \
#ffmpeg -hide_banner -v warning -nostats \
#  -c:v mjpeg -f image2pipe -framerate 20 -i pipe:0 \
#  -c:v copy -f nut -write_index 0 pipe:1 | \
#ffmpeg -thread_queue_size 512 -hide_banner -f nut -i pipe:0 -i "$v" \
#  -map 0:v:0 -map 1:a:0 -c:v copy \
#  -flags +global_header -flags +bitexact -bsf remove_extra \
#  -fflags +bitexact \
#  -filter:a dynaudnorm=c=1 -ac 1 -ar 16000 -c:a pcm_s16le \
#  -f segment -segment_time 500 -segment_atclocktime 0 \
#  -segment_start_number 1 -reset_timestamps 1 -segment_time_delta 0 \
#  -segment_format nut -segment_format_options write_index=0 \
#  "$t"'/HNI_%04d' || exit

# -flags:v +qscale -qcomp:v 0 -qblur:v 0 -qdiff:v 2 -global_quality:v 100 1 
# -flags:v +global_header -bsf remove_extra \

# Wish I could avoid the pipe, here is how to test:
# for i in HNI_????.AVI; do
# 	for f in image2pipe s16le; do
# 		ffmpeg -nostats -hide_banner -i "$i" -c copy -f "$f" - | wc
# 	done
# done

# -debug_ts -fdebug ts -v verbose
2>/dev/null </dev/null /usr/bin/nice ffmpeg -hide_banner -nostats \
  -vsync 1 -async 1 -i "$v" \
  -metadata_header_padding 0 \
  -map_metadata -1 -map_chapters -1 -map 0:v:0 -map 0:a:0 \
  -af 'aformat=channel_layouts=mono,dynaudnorm=c=1,'\
'aformat=sample_fmts=s16:sample_rates=16000,asetnsamples=n=1600' \
  -c:a pcm_s16le -frame_size 1600 \
  -vf fps=20,scale="$w":"$h" \
  -c:v mjpeg -qmin:v 1 -qmax:v 1 -q:v 0 \
  -fflags +bitexact -flags:v +bitexact -flags:a +bitexact \
  -f nut -write_index 0 - | \
ffmpeg -hide_banner -v verbose -nostats -f nut -i - -c copy \
  -metadata_header_padding 0 \
  -map 0:a:0 -f segment -segment_time 500 -segment_atclocktime 0 \
  -reference_stream 0:v:0 -reset_timestamps 1 -segment_time_delta 0 \
  -segment_format nut -segment_format_options write_index=0 \
  -segment_start_number 1 -fflags +bitexact "$t"'/%04da' -c copy \
  -map 0:v:0 -f segment -segment_time 50 -segment_atclocktime 0 \
  -reference_stream 0:v:0 -reset_timestamps 1 -segment_time_delta 0 \
  -segment_format nut -segment_format_options write_index=0 \
  -segment_start_number 0 -fflags +bitexact "$t"'/%05dv' 2>&1 >/dev/null | \
/usr/bin/awk '
#AWK
' t="$t" d="$d" || exit

exit 0
