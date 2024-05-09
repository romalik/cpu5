
struct free_arena_header;

struct arena_header {
	unsigned int type;
	unsigned int size;
	struct free_arena_header *next, *prev;
};


struct free_arena_header {
	struct arena_header a;
	struct free_arena_header *next_free, *prev_free;
};

void main() {
        int a;
    	struct free_arena_header *pah, *ah;
        a += ah->a.size;
        asm("!!!!!!!!!!!!!!!!!!!!!!!\n");
		pah->a.size += ah->a.size;
}
