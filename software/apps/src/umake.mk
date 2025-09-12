cpu5build -v -Wl -start -Wl 0x0000 -Wl -v -o $APP_BIN_DIR/test_app.bin test_app.c
cpu5build -v -Wl -start -Wl 0x0000 -Wl -v -o $APP_BIN_DIR/app1.bin app1.c
cpu5build -v -Wl -start -Wl 0x0000 -Wl -v -o $APP_BIN_DIR/app2.bin app2.c
cpu5build -v -Wl -start -Wl 0x0000 -Wl -v -o $APP_BIN_DIR/sh.bin sh.c


