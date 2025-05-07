.PHONY: docker-torch docker

docker-torch: docker/Dockerfile
	DOCKER_BUILDKIT=0 docker build --shm-size=9.50gb --network=host -f docker/Dockerfile  --build-arg PIP_INSTALL_EXTRAS="torch" .

docker: docker/Dockerfile
	DOCKER_BUILDKIT=0 docker build --shm-size=9.50gb --network=host -f docker/Dockerfile .

run_tests: .venv/bin/activate
	. .venv/bin/activate && python -m unittest discover tests

run_samples_without_docker: .venv/bin/activate
	wget http://www.scikit-video.org/stable/_static/bikes.mp4
	. .venv/bin/activate
	python ./samples/SampleDecode.py -g 0 -e ./bikes.mp4 -r ./tests/test.raw       
	python ./samples/SampleDecodeSw.py -e ./bikes.mp4 -r ./tests/test.raw
	python ./samples/SampleEncodeMultiThread.py 0 848 464 ./tests/test.raw 10
	python ./samples/SampleMeasureVideoQuality.py -g 0 -i ./tests/test.raw -o ./tests/test.raw -w 848 -h 464   
	python ./samples/SamplePyTorch.py 0 ./bikes.mp4 ./tests/out.mp4
	python ./samples/SampleTensorRTResnet.py 0 ./bikes.mp4
	python ./samples/SampleTorchResnet.py  0 ./bikes.mp4     
	python ./samples/SampleDecodeMultiThread.py  0 ./bikes.mp4 10 
	python ./samples/SampleDemuxDecode.py 0 ./tests/test_res_change.h264 ./tests/test.raw
	python ./samples/SampleEncode.py 0 ./tests/test.raw ./tests/output.mp4 848 464              
ifndef DISPLAY 
		echo "skipping rendering samples"
else
		python ./samples/SampleTorchSegmentation.py 0 ./bikes.mp4
		python ./samples/SampleOpenGL.py -g 0 -e ./bikes.mp4        
endif
	# python ./samples/SampleRemap.py 0 ./bikes.mp4 ./tests/remap.npz
	# python ./samples/SampleDecodeRTSP.py 0 rtsp://localhost:8554/mystream rtsp://localhost:8554/mystream # no rtsp stream available for testing

.venv/bin/activate:
	python3.10 -m venv .venv

.venv/bin/stubgen: .venv/bin/activate
	. .venv/bin/activate && pip install mypy

.venv/lib/python3.10/site-packages/PyNvCodec/_PyNvCodec.cpython-310-x86_64-linux-gnu.so: .venv/bin/activate
	. .venv/bin/activate && pip install .

out/PyNvCodec/_PyNvCodec.pyi: .venv/bin/stubgen .venv/lib/python3.10/site-packages/PyNvCodec/_PyNvCodec.cpython-310-x86_64-linux-gnu.so src/PyNvCodec
	.venv/bin/stubgen -mPyNvCodec._PyNvCodec

src/PyNvCodec/__init__.pyi: out/PyNvCodec/_PyNvCodec.pyi
	cp out/PyNvCodec/_PyNvCodec.pyi src/PyNvCodec/__init__.pyi

generate-stubs: src/PyNvCodec/__init__.pyi


# vim:ft=make
#
