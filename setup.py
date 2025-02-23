"""
setup.py - Setup and install the project
Written by: Shahim Vedaei <shahim.vedaei@gmail.com>
Feb 2025
Verison: 2.0
"""

import re
import os
import sys
import shutil
import argparse
import subprocess


PYTHON_MIN_VERSION = (3, 11, 9)

appdata_path = os.getenv('APPDATA') # C:\Users\<username>\AppData\Roaming
ALTIUM_DIR = os.path.join(appdata_path, 'Altium')
DEST_DIR = os.path.join(ALTIUM_DIR, 'CloudParts')
SETUP_DIR = os.path.dirname(os.path.abspath(__file__))  # Get script's directory
SRC_DIR = os.path.abspath(os.path.join(SETUP_DIR, "src"))

ADD_TO_TOOLS = f"""
PL PLCloudPartsScript Command='ScriptingSystem:RunScript' Params='ProjectName={os.path.join(DEST_DIR, 'CloudParts.PrjScr')}|ProcName={os.path.join(DEST_DIR, 'CloudParts.pas')}>' Caption='CloudParts' Image='{os.path.join(DEST_DIR, 'icon.png')}' Description='Cloud Library Search and Placement' DefaultChecked=0  End
Insertion _UserCouldPart1 TargetID='MNSchematic_Tools10' RefID0='MNSchematic_Tools9999' 
    Link _UserCouldPart2 PLID='PLCloudPartsScript'    End
End
Insertion _UserCouldPart3 TargetID='MNPCB_Tools10' RefID0='MNPCB_Tools9999' 
    Link _UserCouldPart4 PLID='PLCloudPartsScript'    End
End
"""

current_version = sys.version_info

def requirements():
	"""Check the requirements"""
	if current_version < PYTHON_MIN_VERSION:
		print(f"Error: Python {PYTHON_MIN_VERSION} or higher is required. You are using Python {current_version.major}.{current_version.minor}.{current_version.micro}")
		sys.exit(1)  # Exit with error code 1

	"""Install the necessary packages"""
	# Install necessary packages
	# Install necessary packages
	# TODO: read packes from requirements.txt
	try:
		import requests  # Check if requests is already installed
		print("requests is already installed.")
	except ImportError:
		print("Installing requests...")
		subprocess.check_call([sys.executable, "-m", "pip", "install", "requests"])


def clean_rcs():
	# Remove already install toolbar
	matches = []
	for root, _, files in os.walk(ALTIUM_DIR):
		if 'DXP.RCS' in files:
			matches.append(os.path.join(root, 'DXP.RCS'))

	for rcs_file in matches:
		# Define the pattern to match the block of text you want to remove
		pattern1 = re.compile(r"PL PLCloudPartsScript .*?End", re.DOTALL)
		pattern2 = re.compile(r"Insertion _UserCouldPart.*?PLCloudPartsScript.*?End.*?End", re.DOTALL)
		with open(rcs_file, 'r') as f:
			text = f.read()
		# Remove matching blocks of text
		cleaned_text = re.sub(pattern1, '', text)
		cleaned_text = re.sub(pattern2, '', cleaned_text)

		# Write the cleaned content back to a new file
		with open(rcs_file, 'w') as f:
			f.write(cleaned_text)
		print(f"Old Toolbar is removed")


def install():
	"""Install the CloudParts to Altium"""
	# Check existence files/folders
	if not os.path.exists(SRC_DIR):
		print(f"ERROR: src directory not found: {SRC_DIR}")
		sys.exit(1)  # Exit with error code 1

	if not os.path.exists(ALTIUM_DIR):
		print(f"Altium AppData path does not exist. Creating the path...")
		os.makedirs(ALTIUM_DIR)

	if not os.path.exists(DEST_DIR):
		print(f"Creating the path for CloudParts...")
		os.makedirs(DEST_DIR)

	# Installing
	for item in os.listdir(SRC_DIR):
		src_path = os.path.join(SRC_DIR, item)
		dest_path = os.path.join(DEST_DIR, item)
		if os.path.isdir(src_path):
			shutil.copytree(src_path, dest_path, dirs_exist_ok=True)
		else:
			shutil.copy2(src_path, dest_path)
	# Remove already install toolbar
	clean_rcs()
	# Add to toolbar
	matches = []
	for root, _, files in os.walk(ALTIUM_DIR):
		if 'DXP.RCS' in files:
			matches.append(os.path.join(root, 'DXP.RCS'))

	for rcs_file in matches:
		with open(rcs_file, "a") as file:
			file.write(ADD_TO_TOOLS)
		print(f"Added to Altium Toolbar")


def uninstall():
	"""Remove the CloudParts from Altium"""
	if os.path.exists(DEST_DIR):
		shutil.rmtree(DEST_DIR)
		print(f"Uninstalled")
	else:
		print(f"Nothing to uninstall, CloudParts does not exist.")

	# Remove toolbar from Altium
	clean_rcs()


def parse_input():
	"""
	This function parse the input parameters
	"""
	# ArgumentParser
	parser = argparse.ArgumentParser()
	# Add arguments for searchpath and filter
	parser.add_argument("--install", action="store_true", help='To install the CloudParts')
	parser.add_argument('--uninstall', action="store_true", help='To install the CloudParts')

	return parser.parse_args()


def main():
	"""
	Main function
	"""
	# Check Python
	requirements()

	# Parsing input params
	args = parse_input()

	# Check the action
	if args.install:   
		install()

	elif args.uninstall:
		uninstall()

	else:
		print("Invalid input. Either --install or --uninstall")


if __name__ == "__main__":
	main()
