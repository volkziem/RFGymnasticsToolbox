all:
	ffmpeg -i tmp.avi tmp.mp4
	mplayer tmp.mp4 -idle -fixed-vo

show:
	mplayer tmp.mp4 -idle -fixed-vo

clean:
	rm tmp.avi

