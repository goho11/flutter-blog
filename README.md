# 레코드 문법(괄호타입)

(String, int) hello(){
return ("ssar", 1234);
}

void main() {
var (username, password) = hello();
print(username);
print(password);
}

({String username, int password}) hello(){
return (username:"ssar", password:1234);
}

void main() {
var n = hello();
print(n.username);
print(n.password);
}