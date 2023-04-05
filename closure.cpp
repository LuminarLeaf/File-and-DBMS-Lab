#include <bits/stdc++.h>

using namespace std;

int main(){
    int FDc = 4;
    array< vector<int>, 4> FD_left;
    array< vector<int>, 4> FD_right;
    
    FD_left[0].push_back(0);
    FD_right[0].push_back(1);

    FD_left[1].push_back(2);
    FD_right[1].push_back(3);

    FD_left[2].push_back(4);
    FD_left[2].push_back(3);
    FD_right[2].push_back(5);

    FD_left[3].push_back(0);
    FD_right[3].push_back(2);
    FD_right[3].push_back(4);

    // store 1st number of fdl[0] in temp
    int temp = FD_left[0].front();

    //print FDs
    for(int i = 0; i < FDc; i++){
        cout << "FD" << i << ": ";
        for(int j = 0; j < FD_left[i].size(); j++){
            cout << FD_left[i][j] << " ";
        }
        cout << "-> ";
        for(int j = 0; j < FD_right[i].size(); j++){
            cout << FD_right[i][j] << " ";
        }
        cout << endl;
    }

    //find closure of this
    int attr_index = 2;

    list<int> closure;
    closure.push_back(attr_index);

    //duplicate fd_left and fd_right
    array< vector<int>, 4> FD_left_dup = FD_left;
    array< vector<int>, 4> FD_right_dup = FD_right;

    //find closure of attr
    // repeat loop until no new attributes are added to closure
    // when a fd is used, remove it from fd_left and fd_right and  move onto next iteration
    while(true){
        bool flag = false;
        for(int i = 0; i < FDc; i++){
            if(FD_left_dup[i].size() == 0){
                continue;
            }
            bool flag2 = true;
            for(int j = 0; j < FD_left_dup[i].size(); j++){
                if(find(closure.begin(), closure.end(), FD_left_dup[i][j]) == closure.end()){
                    flag2 = false;
                    break;
                }
            }
            if(flag2){
                for(int j = 0; j < FD_right_dup[i].size(); j++){
                    if(find(closure.begin(), closure.end(), FD_right_dup[i][j]) == closure.end()){
                        closure.push_back(FD_right_dup[i][j]);
                        flag = true;
                    }
                }
                FD_left_dup[i].clear();
                FD_right_dup[i].clear();

            }
        }
        if(!flag){
            break;
        }
    }

    //remove duplicates
    closure.sort();
    closure.unique();

    //print closure
    cout << "Closure of " << attr_index << " is : ";
    for(auto i = closure.begin(); i != closure.end(); i++){
        cout << *i << " ";
    }
    cout << endl;

}