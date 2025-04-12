/* exemplo 1 
fatorial versão recursiva*/ 
int fact(int); 
void main(void); 
int fact (int k) { 
if (k<=1) { return 1; } 
else {return k * fact (k-1); } 
} 
void main(void){ 
int n; 
writes(“Introduza inteiro: ”); 
n = read(); 
write(fact(n)); 
}