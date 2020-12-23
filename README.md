# String Max Border
#### 64-bit NASM Assembler program written to calculate the max border of a string

### How to Run:
- Ensure that you have NASM installed on your machine
- Fork the repository to your local machine
- Within a command window that has NASM installed, run the command `make all` or `make fproj`
- A bash executable called `fproj` will be compiled and created
- To run the program execute the command: `fproj 'string'` with 'string' being the string you want to calculate the max border of
- In the command window, you will see the input string, the max border array, and the max border array as a bar chart:__
![Max Border Example](https://github.com/areezvisram/String-Max-Border-Assembler/blob/master/Example.PNG)
### Theory:
- The border of a string `x[0...n-1]` of length `n` is a substring `x[0...k]`, `0 = k < n - 1` such that `x[0...k] = x[n-k...n-1`
- i.e, the border of a string is a substring of the string that is simultaneously a prefix and suffix of the string
- EXAMPLES: `ababbcd` does not have a border, while the border of `ababa` is both `a` and `aba`
- The max border array of a string of length `n`, `border[0...n-1]` is an array of size `n` where `border[i]` is the size of the maximal border of the string `x[i...n-1]`
- EXAMPLE: For `abcdabcdab` the maximal border is `abcdab` so `border[0] = 6`. Moving forward one spot in the string, the maximal border of `bcdabcdab` is `bcdab` so `border[1] = 5`
- The full maximal border array for `abcdabcdab` is: `[6,5,4,3,2,1,0,0,0,0]`

### Limitations:
- Can only be run on strings with length between 1 and 12

### Notes:
- `driver.c`, `simple_io.inc`, `simple_io.asm` are external files used within the program, please do not alter these
