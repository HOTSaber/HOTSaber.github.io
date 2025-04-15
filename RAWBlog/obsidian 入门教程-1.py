from PIL import Image
import os

input_folder = './blogpic'  # 替换为你的图片文件夹路径
output_folder = './test'  # 替换为输出图片的文件夹路径

if not os.path.exists(output_folder):
    os.makedirs(output_folder)
resize_num = 600
for filename in os.listdir(input_folder):
    if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp', '.gif')):
        img_path = os.path.join(input_folder, filename)
        img = Image.open(img_path)
        h_percent = (resize_num / float(img.size[0]))
        v_size = int((float(img.size[1]) * float(h_percent)))
        img = img.resize((resize_num, v_size), Image.ANTIALIAS)

        new_img_path = os.path.join(output_folder, filename)
        img.save(new_img_path)
        print(f'Resized {filename} and saved to {new_img_path}')
