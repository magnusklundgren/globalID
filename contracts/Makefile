all:
	sudo docker build -t hest . && sudo rm -rf .qtum/ && sudo docker run -it --rm -v `pwd`:/dapp -p 9888:9888 -p 9899:9899 -p 3889:3889 --name hest hest
