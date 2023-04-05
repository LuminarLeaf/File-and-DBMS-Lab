#include <bits/stdc++.h>

using namespace std;

void FindClosure(vector<vector<int>> FD_L, vector<vector<int>> FD_R, int FDc, list<int> &closure){
    while(true){
        bool flag = false;
        for(int i = 0; i < FDc; i++){
            if(FD_L[i].size() == 0){
                continue;
            }
            bool flag2 = true;
            for(int j = 0; j < FD_L[i].size(); j++){
                if(find(closure.begin(), closure.end(), FD_L[i][j]) == closure.end()){
                    flag2 = false;
                    break;
                }
            }
            if(flag2){
                for(int j = 0; j < FD_R[i].size(); j++){
                    if(find(closure.begin(), closure.end(), FD_R[i][j]) == closure.end()){
                        closure.push_back(FD_R[i][j]);
                        flag = true;
                    }
                }
                FD_L[i].clear();
                FD_R[i].clear();

            }
        }
        if(!flag){
            break;
        }
    }

    closure.sort();
    closure.unique();
}

void ParseFDs(vector<string> FDs, vector<vector<int>> &FD_left, vector<vector<int>> &FD_right, int FDc, vector<string> schema, int n){
        for(int i = 0; i < FDc; i++){
        vector<int> left;
        vector<int> right;
        int j = 0;

        string FDl = FDs[i].substr(0, FDs[i].find("->"));
        string FDr = FDs[i].substr(FDs[i].find("->") + 2, FDs[i].length());
        
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
}

void FindKeys(vector<vector<int>> FD_L, vector<vector<int>> FD_R, int FDc, vector<string> schema, int n, vector<vector<int>> &keys, vector<int> key, int index){
    if(index == n){
        list<int> closure;
        for(int i = 0; i < key.size(); i++){
            closure.push_back(key[i]);
        }
        FindClosure(FD_L, FD_R, FDc, closure);
        if(closure.size() == n){
            keys.push_back(key);
        }
        return;
    }

    //include index
    key.push_back(index);
    FindKeys(FD_L, FD_R, FDc, schema, n, keys, key, index + 1);
    key.pop_back();

    //exclude index
    FindKeys(FD_L, FD_R, FDc, schema, n, keys, key, index + 1);
}

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

    vector<vector<int>>  FD_left;
    vector<vector<int>>  FD_right;
    ParseFDs(FDs, FD_left, FD_right, FDc, schema, n);

    list<int> closure;

    vector<vector<int>> keys;
    vector<int> key;
    int index = 0;
    FindKeys(FD_left, FD_right, FDc, schema, n, keys, key, index);

    cout << "The keys are : " << endl;
    for(int i = 0; i < keys.size(); i++){
        cout << "{";
        for(int j = 0; j < keys[i].size(); j++){
            cout << schema[keys[i][j]];
            if(j != keys[i].size() - 1){
                cout << ", ";
            }
        }
        cout << "}" << endl;
    }
    
    // PRINT KEYS OF MINIMUM LENGTH
    int min = n;
    for(int i = 0; i < keys.size(); i++){
        if(keys[i].size() < min){
            min = keys[i].size();
        }
    }
    cout << "The Candidate Keys are : " << endl;
    for(int i = 0; i < keys.size(); i++){
        if(keys[i].size() == min){
            cout << "{";
            for(int j = 0; j < keys[i].size(); j++){
                cout << schema[keys[i][j]];
                if(j != keys[i].size() - 1){
                    cout << ", ";
                }
            }
            cout << "}" << endl;
        }
    }

}