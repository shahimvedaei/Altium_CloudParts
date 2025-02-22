"""
Chila360_utils.py - Utility functions
Written by: Shahim Vedaei <shahim.vedaei@gmail.com>
Feb 2025
Verison: 2.1
"""

# Packages
import os
import csv
from pathlib import Path
import time
import argparse
import requests
from urllib.parse import urlparse

# How to generate .pyx file
# cython --embed -o Chila360_utils.c Chila360_utils.pyx

# TODO: this should be done automatically
IND_PATH = 3

def download_url(url, saveto):
	"""
	Download a file from a URL
	:param url: The URL to download the file from
	:param saveto: The full path with file name to save. 
	"""
	response = requests.get(url)
	if response.status_code == 200:
		baseDir = os.path.dirname(saveto)
		if not os.path.exists(baseDir):
			os.makedirs(baseDir)

		# Check if the file name is empty, so extract it from the URL
		if len(os.path.basename(saveto)) == 0:
			saveto = saveto + urlparse(url).path.split('/')[-1]

		# TODO: Check if dir is created.
		with open(saveto, "wb") as file:
			file.write(response.content)
			print("Downloaded successfully!", url)
	else:
		print("Failed to download", url)


def db_postprocess(db_file, dir_base):
	# Open the CSV file
	reader = None
	dir_base = dir_base.replace("\\", "/")

	with open(db_file, newline="") as csvfile:
		reader = list(csv.reader(csvfile))

		# Read and print the third column
		for i in range(1, len(reader)):  # Start from index 1 to skip the header
			if len(reader[i]) >= 3:  # Ensure the row has at least 2 columns
				if reader[i][IND_PATH][0] == "/":
					rel_path = reader[i][IND_PATH][1:]
				else:
					rel_path = reader[i][IND_PATH]
	
				true_path = os.path.join(dir_base, rel_path)
				if os.path.exists(true_path):
					true_path = str(Path(true_path).resolve())
				true_path = true_path.replace("\\", "/")
				true_path = true_path.removeprefix(dir_base)
				# update the path
				reader[i][IND_PATH] = true_path

	# Write the modified data back to the same file
	with open(db_file, "w", newline="") as csvfile:
		writer = csv.writer(csvfile)
		writer.writerows(reader)
		print("Database file updated successfully!")


def search_files(folder_path, filter, output):
	sch_files = []

	# Walk through all subdirectories
	print(folder_path)
	for root, dirs, files in os.walk(folder_path):
		# Append files that end with .sch
		for file in files:
			if file.lower().endswith(filter.lower()):
				sch_files.append(os.path.join(root, file))
	# save the results
	with open(output, "w") as file:
		for files in sch_files:
			file.write(files + "\n")

	print("result saved in: ", output)
	return sch_files


def parse_input():
	"""
	This function parse the input parameters
	"""
	# ArgumentParser
	parser = argparse.ArgumentParser()
	# Add arguments for searchpath and filter
	parser.add_argument('--action', type=str, required=True, help='Utility action to perform.')
	parser.add_argument('--url', type=str, required=False, help='The url.')
	parser.add_argument('--path', type=str, required=False, help='The directory path to search.')
	parser.add_argument('--filter', type=str, required=False, help='The filter pattern for file matching.')
	parser.add_argument('--saveto', type=str, required=False, help='output file path.')
	parser.add_argument('--db_file', type=str, required=False, help='TODO')
	parser.add_argument('--lib_dir', type=str, required=False, help='TODO')
	return parser.parse_args()


def main():
	"""
	Main function
	"""
	# Parsing input params
	args = parse_input()

	# Check the action
	if args.action == "search":   
		search_files(args.path, args.filter, args.saveto)

	elif args.action == "db_postprocess":
		db_postprocess(args.db_file, args.lib_dir)
	
	elif args.action == "download_url":
		download_url(args.url, args.saveto)


if __name__ == "__main__":
	main()
