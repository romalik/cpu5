cpu5build -v -Wl -start -Wl 0x0000 -Wl -v -o test_app.bin test_app.c

cpu5build -v -Wl -start -Wl 0x0000 -Wl -v -o app1.bin app1.c

cpu5build -v -Wl -start -Wl 0x0000 -Wl -v -o app2.bin app2.c

cpu5build -v -Wl -start -Wl 0x0000 -Wl -v -o sh.bin sh.c

cp sh.bin app1.bin app2.bin test_app.bin ../../fs/
