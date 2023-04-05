#include <bits/stdc++.h>

using namespace std;

int main(){
    int n, FDc, attr_index;
    cout << "Enter the number of attributes : ";
    cin >> n;
    vector <string> schema(n);
    cout << "Enter the attributes one by one : \n";
    for(int i = 0; i < n; i++){
        cin >> schema[i];
    }
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
    for(int i = 0; i < n; i++){
        if(schema[i].compare(attr) == 0){
            attr_index = i;
            break;
        }
    }
    vector<vector<int>>  FD_left;
    vector<vector<int>>  FD_right;
    for(int i = 0; i < FDc; i++){
        vector<int> left;
        vector<int> right;
        int j = 0;
        string FDl = FDs[i].substr(0, FDs[i].find("->"));
        string FDr = FDs[i].substr(FDs[i].find("->") + 2, FDs[i].length());
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
    list<int> closure;
    closure.push_back(attr_index);
    vector<vector<int>> FD_left_dup = FD_left;
    vector<vector<int>> FD_right_dup = FD_right;
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
        if(!flag)
            break;
    }
    closure.sort();
    closure.unique();
    cout << "Closure of " << attr << " is : {";
    for(auto i = closure.begin(); i != closure.end(); i++){
        cout << schema[*i];
        if(next(i) != closure.end()){
            cout << ", ";
        }
    }
    cout << "}" << endl;
}