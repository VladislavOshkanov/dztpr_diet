#include <iostream>
using namespace std;
#define INF 0
int main(int argc, char const * argv[]) {
  int c[6][6] = {
    {INF, 3300, 4100, 3100, 2300, 2000},
    {3300, INF, 2500, 690, 1400, 1400},
    {4100, 2500, INF, 2500, 3100, 2200},
    {3100, 690, 2500, INF, 760, 1800},
    {2300, 1400, 3100, 760, INF, 2100},
    {2000, 1400, 2200, 1800, 2100, INF}
  };
  bool simm = true;
    for (size_t i = 0; i < 6; i++) {
      for (size_t j = 0; j < 6; j++) {
        for (size_t k = 0; k < 6; k++) {
          if (c[i][j]>c[i][k]+c[k][j]){
             simm = false;
             cout << i+1 << j+1 << " " << i+1 << k+1 << " " << k+1 << j+1 << endl;
           }
        }
      }
    }
  return 0;
}
