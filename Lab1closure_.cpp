#include <bits/stdc++.h>

using namespace std;

int main(){
    int n;
    cout << "Enter the number of attributes : ";
    cin >> n;

    vector <string> schema(n);
    cout << "Enter the attributes one by one : \n";
    for(int i = 0; i < n; i++){
        cin >> schema[i];
    }

    int FDc;
    cout << "Enter the number of FDs : ";
    cin >> FDc;

    vector <string> FDs(FDc);
    cout << "Enter the FDs one by one : \n";
    for(int i = 0; i < FDc; i++){
        cin >> FDs[i];
    }

    string attr;
    cout << "Enter the attribute whose closure is to be found : ";
    cin >> attr;
    int attr_index;
    for(int i = 0; i < n; i++){
        if(schema[i].compare(attr) == 0){
            attr_index = i;
            break;
        }
    }

    //parse FDs into FD_left and FD_right
    vector<vector<int>>  FD_left;
    vector<vector<int>>  FD_right;

    for(int i = 0; i < FDc; i++){
        vector<int> left;
        vector<int> right;
        int j = 0;

        string FDl = FDs[i].substr(0, FDs[i].find("->"));
        string FDr = FDs[i].substr(FDs[i].find("->") + 2, FDs[i].length());

        // //print FDl and FDr
        // cout << FDl << " " << FDr << endl;

        //left side
        if(FDl[0] == '{'){
            j = 1;
            string temp = "";
            while(FDl[j] != '}'){
                while(FDl[j] != ',' && FDl[j] != '}'){
                    temp += FDl[j];
                    j++;
                }
                if(FDl[j] == ',' || FDl[j] == '}'){
                    for(int k = 0; k < n; k++){
                        if(schema[k].compare(temp) == 0){
                            left.push_back(k);
                            break;
                        }
                    }
                    temp = "";
                }
                if(FDl[j] == '}')
                    break;
                j++;
            }
        }else{
            for(int k = 0; k < n; k++){
                if(schema[k].compare(FDl) == 0){
                    left.push_back(k);
                    break;
                }
            }
        }

        // //print left
        // for(int j = 0; j < left.size(); j++){
        //     cout << left[j] << " ";
        // }
        // cout << endl;

        //right side
        if(FDr[0] == '{'){
            j = 1;
            string temp = "";
            while(FDr[j] != '}'){
                while(FDr[j] != ',' && FDr[j] != '}'){
                    temp += FDr[j];
                    j++;
                }
                if(FDr[j] == ',' || FDr[j] == '}'){
                    for(int k = 0; k < n; k++){
                        if(schema[k].compare(temp) == 0){
                            right.push_back(k);
                            break;
                        }
                    }
                    temp = "";
                }
                if(FDr[j] == '}')
                    break;
                j++;
            }
        }else{
            for(int k = 0; k < n; k++){
                if(schema[k].compare(FDr) == 0){
                    right.push_back(k);
                    break;
                }
            }
        }

        FD_left.push_back(left);
        FD_right.push_back(right);
    }

    // print FDs
    // for(int i = 0; i < FDc; i++){
    //     cout << "FD" << i << ": ";
    //     for(int j = 0; j < FD_left[i].size(); j++){
    //         cout << FD_left[i][j] << " ";
    //     }
    //     cout << "-> ";
    //     for(int j = 0; j < FD_right[i].size(); j++){
    //         cout << FD_right[i][j] << " ";
    //     }
    //     cout << endl;
    // }

        list<int> closure;
    closure.push_back(attr_index);

    //duplicate fd_left and fd_right
    vector<vector<int>> FD_left_dup = FD_left;
    vector<vector<int>> FD_right_dup = FD_right;

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

    //print closure in schema terms
    cout << "Closure of " << attr << " is : {";
    for(auto i = closure.begin(); i != closure.end(); i++){
        cout << schema[*i];
        if(next(i) != closure.end()){
            cout << ", ";
        }
    }
    cout << "}" << endl;

}