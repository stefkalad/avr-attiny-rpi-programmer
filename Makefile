EXE=tpiflash

CC=gcc
TARGET_RPI_VERSION=4
CFLAGS= -DTARGET_RPI_VERSION=$(TARGET_RPI_VERSION)
LDFLAGS=
OUT_DIR=out
SRC_DIR=src

SOURCES=$(wildcard $(SRC_DIR)/*.c)
OBJECTS=$(SOURCES:$(SRC_DIR)/%.c=$(OUT_DIR)/%.o)

RPI_TPIFLASH_PATH=/home/pi/tpi-flash

all: $(EXE)

$(EXE): $(OBJECTS) | $(OUT_DIR)
	$(CC) $(LDFLAGS) $^ -o $(OUT_DIR)/$@

$(OUT_DIR)/%.o: $(SRC_DIR)/%.c | $(OUT_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

transfer:
	ssh pi@raspberrypi.local 'mkdir -p $(RPI_TPIFLASH_PATH)/$(SRC_DIR)'
	scp -R ./src/* pi@raspberrypi.local:$(RPI_TPIFLASH_PATH)/$(SRC_DIR)
	scp ./Makefile pi@raspberrypi.local:$(RPI_TPIFLASH_PATH)
	ssh pi@raspberrypi.local 'make clean -C $(RPI_TPIFLASH_PATH) && make -C $(RPI_TPIFLASH_PATH)'

run:
	ssh pi@raspberrypi.local 'sudo $(RPI_TPIFLASH_PATH)/$(OUT_DIR)/$(EXE) r 1e9003 2>&1'

clean :
	rm -rf out *~ tpiflash *.bin



