import os
import shutil
import argparse

def cleaner(folder_path):
    deleted = 0
    log_file = open("Deleted_terraform_dirs.txt", "a")

    for root, dirs, files in os.walk(folder_path):
        for dir_name in dirs:
            if dir_name == ".terraform":
                terraform_dir_path = os.path.join(root, dir_name)
                try:
                    shutil.rmtree(terraform_dir_path)
                    print(f" Deleted: {terraform_dir_path}")
                    log_file.write(f"Deleted: {terraform_dir_path}\n")
                    deleted += 1
                except Exception as e:
                    print(f" Failed to delete {terraform_dir_path}: {e}")
    
    log_file.write(f"\n {deleted} .terraform directories deleted from {folder_path}\n\n")
    log_file.close()
    print(f"\n {deleted} .terraform directories deleted.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Recursively delete all .terraform folders")
    parser.add_argument('--path', required=True, help="Path to root folder")
    args = parser.parse_args()

    cleaner(args.path)
