/* EXPECT_ERROR sweet -i=bug_top_cmp.alf func=main -ae css pu debug=trace
 *
 * expects error, because single path mode is specified (css), but there
 * are two possible paths
 */

volatile int x;

int main(int argc, char**argv) {
    if(argc < 5) return -1;
    x = 1;
    return 0;
}
