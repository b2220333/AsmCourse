#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#pragma inline

typedef struct ITEM_ {
    char name[10];
    int in_price;
    int out_price;
    int in_num;
    int out_num;
    int profit;
} ITEM;
extern void cal();
extern void calRank();
char *SHOP_NAME_1 = "shop1";
char *SHOP_NAME_2 = "shop2";
ITEM items[6] = {{"PEN$", 45, 56, 60, 35}, {"BOOK$", 12, 30, 25, 15}, {"BAG$", 20, 40, 30, 20},
                 {"PEN$", 35, 50, 30, 24}, {"BOOK$", 12, 28, 20, 15},  {"BAG$", 18, 42, 32, 20}};
char in_char = 1;
char in_item[11];
char in[11];
ITEM *p_item;
int len = 1;
int i;

void printf_(char *out) {
    int i = 0;
    while (out[i] != '$') {
        putchar(*(out + i++));
    }
}

void scanf_(char *in) {
    scanf("%s", in);
    getchar();
    len = strlen(in);
    in[len] = '$';
    in[len + 1] = 0;
}

void show_item(ITEM *item) {
    printf_(item->name);
    printf(",%d,%d,%d,%d\n", item->out_price, item->in_num, item->out_num, item->profit);
}

int feat_1() {
    printf("Please input item name:");
    scanf_(in);
    for (i = 0; i < 3; i++) {
        if (!strcmp(items[i].name, in)) {
            printf("%s,", SHOP_NAME_1);
            show_item(&items[i]);
            printf("%s,", SHOP_NAME_2);
            show_item(&items[i + 3]);
            return 0;
        }
    }
    return 1;
}

void edit_value(int *value) {
    printf("%d->", *value);
    gets(in);
    if (strlen(in) == 0) {
        return;
    }
    *value = atoi(in);
}

int feat_2() {
    printf("Please input shop name:");
    scanf("%s", in);
    if (!strcmp(SHOP_NAME_1, in)) {
        p_item = &items[0];
    } else if (!strcmp(SHOP_NAME_2, in)) {
        p_item = &items[3];
    } else {
        return 1;
    }
    printf("Please input item name:");
    scanf_(in);
    for (i = 0; i < 3; i++) {
        if (!strcmp(p_item[i].name, in)) {
            edit_value(&p_item[i].out_price);
            edit_value(&p_item[i].in_num);
            edit_value(&p_item[i].out_num);
            return 0;
        }
    }
    return 1;
}

int main() {
START:
    do {
        printf("1. Query item infomation\n");
        printf("2. Edit item infomation\n");
        printf("3. Calculate average profit\n");
        printf("4. Calculate profit rank\n");
        printf("5. Show all item infomation\n");
        printf("6. Exit\n");
    } while (((in_char = getchar()) < '1' || in_char > '6') && getchar());
    switch (in_char) {
    case '1':
        while (feat_1()) {
            continue;
        }
        goto START;
        break;
    case '2':
        while (feat_2()) {
            continue;
        }
        goto START;
        break;
    case '3':
        cal();
        getchar();
        goto START;
        break;
    case '4':
        calRank();
        getchar();
        goto START;
        break;
    case '5':
        printf("%s\n", SHOP_NAME_1);
        for (i = 0; i < 3; i++) {
            printf_(items[i].name);
            printf(",%d,%d,%d,%d,profit:%d\n", items[i].in_price, items[i].out_price, items[i].in_num, items[i].out_num, items[i].profit);
        }
        printf("%s\n", SHOP_NAME_2);
        for (i = 3; i < 6; i++) {
            printf_(items[i].name);
            printf(",%d,%d,%d,%d,rank:%d\n", items[i].in_price, items[i].out_price, items[i].in_num, items[i].out_num, items[i].profit);
        }
        getchar();
        goto START;
        break;
    case '6':
        return 0;
        break;
    }
    return 0;
}