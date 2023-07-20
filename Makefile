EXE=tpiflash

CC=gcc
CFLAGS=
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

transfer: tpiflash
	ssh pi@raspberrypi.local 'mkdir -p $(RPI_TPIFLASH_PATH)/$(SRC_DIR)'
	scp -R ./src/* pi@raspberrypi.local:$(RPI_TPIFLASH_PATH)/$(SRC_DIR)
	scp ./Makefile pi@raspberrypi.local:$(RPI_TPIFLASH_PATH)
	ssh pi@raspberrypi.local 'make clean -C $(RPI_TPIFLASH_PATH) && make -C $(RPI_TPIFLASH_PATH)'

clean :
	rm -rf out *~ tpiflash *.bin



