def get_lcs_length(str1, str2):
    A = [''] + list(str1)
    B = [''] + list(str2)
    
    table = [[0] * len(B) for _ in range(len(A))]
    
    # 동적 프로그래밍 점화식 (이전 코드 그대로 사용)
    for i in range(1, len(A)):
        for j in range(1, len(B)):
            # 같은 글자일 때는 대각선 개수 + 1[cite: 28]
            if A[i] == B[j]:
                table[i][j] = table[i-1][j-1] + 1
            # 다른 글자일 때는 왼쪽이나 위 쪽 중 큰 값[cite: 28]
            else:
                if table[i-1][j] > table[i][j-1]:
                    table[i][j] = table[i-1][j]
                else:
                    table[i][j] = table[i][j-1]
                    
    # --- 1단계 실행 화면과 동일한 출력부 ---
    print(f"first string: {str1}")
    print(f"second string: {str2}")
    
    # 열(second string) 헤더 알파벳 출력
    print("    ", end="")
    for j in range(1, len(B)):
        print(f" {B[j]} ", end="")
    print()
    
    # 행(first string) 알파벳과 DP 테이블 내부 값 출력
    for i in range(1, len(A)):
        print(f"{A[i]} : ", end="")
        for j in range(1, len(B)):
            print(f" {table[i][j]} ", end="")
        print()
                    
    return table[-1][-1]

# 문제에 주어진 문자열[cite: 27]
first_string = "acbcdgadfgdze"
second_string = "abcacdefgadb"

# 함수 실행
get_lcs_length(first_string, second_string)
