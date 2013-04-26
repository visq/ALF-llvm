void loop() {
    int x = 1;
    while(x != 0) x+=2;
    return;
}

int main(int argc, char** argv) {
    if(argc > 1) loop();
    return 0;
}