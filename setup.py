"""
setup.py - Setup and install the project
Written by: Shahim Vedaei <shahim.vedaei@gmail.com>
Feb 2025
Verison: 1.0
"""

import os
import sys
import shutil
import argparse
import subprocess


appdata_path = os.getenv('APPDATA') # C:\Users\<username>\AppData\Roaming
ALTIUM_DIR = os.path.join(appdata_path, 'Altium')
DEST_DIR = os.path.join(ALTIUM_DIR, 'Chila360')
SETUP_DIR = os.path.dirname(os.path.abspath(__file__))  # Get script's directory
SRC_DIR = os.path.abspath(os.path.join(SETUP_DIR, "src"))

ADD_TO_TOOLS = f"""
PL PLChilaScript Command='ScriptingSystem:RunScript' Params='ProjectName={os.path.join(DEST_DIR, 'Chila360.PrjScr')}|ProcName={os.path.join(DEST_DIR, 'Chila360.pas')}>' Caption='Chila360' Image='{os.path.join(DEST_DIR, 'icon.png')}' Description='Cloud Library Search and Placement' DefaultChecked=0  End
Insertion _UserChila1 TargetID='MNSchematic_Tools10' RefID0='MNSchematic_Tools9999' 
    Link _UserChila2 PLID='PLChilaScript'    End
End
Insertion _UserChila3 TargetID='MNPCB_Tools10' RefID0='MNPCB_Tools9999' 
    Link _UserChila4 PLID='PLChilaScript'    End
End
"""


def install():
	"""Install the Chila360 to Altium"""
	# Install necessary packages
	# TODO: read packes from requirements.txt
	try:
		import requests  # Check if requests is already installed
		print("requests is already installed.")
	except ImportError:
		print("Installing requests...")
		subprocess.check_call([sys.executable, "-m", "pip", "install", "requests"])

	# Check existence files/folders
	if not os.path.exists(SRC_DIR):
		print(f"ERROR: src directory not found: {SRC_DIR}")
		return

	if not os.path.exists(ALTIUM_DIR):
		print(f"Altium AppData path does not exist. Creating the path...")
		os.makedirs(ALTIUM_DIR)
	
	if not os.path.exists(DEST_DIR):
		print(f"Creating the path for Chila360...")
		os.makedirs(DEST_DIR)

	# Installing
	for item in os.listdir(SRC_DIR):
		src_path = os.path.join(SRC_DIR, item)
		dest_path = os.path.join(DEST_DIR, item)
		if os.path.isdir(src_path):
			shutil.copytree(src_path, dest_path, dirs_exist_ok=True)
		else:
			shutil.copy2(src_path, dest_path)
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
	"""Remove the Chila360 from Altium"""
	if os.path.exists(DEST_DIR):
		shutil.rmtree(DEST_DIR)
		print(f"Uninstalled")
	else:
		print(f"Nothing to uninstall, Chila360 does not exist.")
	# TODO: Remove from toolbar


def parse_input():
	"""
	This function parse the input parameters
	"""
	# ArgumentParser
	parser = argparse.ArgumentParser()
	# Add arguments for searchpath and filter
	parser.add_argument("--install", action="store_true", help='To install the Chila360')
	parser.add_argument('--uninstall', action="store_true", help='To install the Chila360')

	return parser.parse_args()


def main():
	"""
	Main function
	"""
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
