cpu5build -v -Wl -start -Wl 0xA000 -Wl -v -o test_app.bin test_app.c

cpu5build -v -Wl -start -Wl 0xA000 -Wl -v -o app1.bin app1.c

cpu5build -v -Wl -start -Wl 0xA000 -Wl -v -o app2.bin app2.c

cp app1.bin app2.bin test_app.bin ../../fs/