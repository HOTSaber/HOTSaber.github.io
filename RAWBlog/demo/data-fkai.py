import numpy, pandas
print('hello')
import time

def count_forever():
    count = 1
    try:
        while True:
            print(f"计数: {count}")
            count += 1
            time.sleep(1)  # 暂停1秒
    except KeyboardInterrupt:
        print("\n程序已手动停止")

if __name__ == "__main__":
    print("开始循环计数，按Ctrl+C停止...")
    count_forever()

