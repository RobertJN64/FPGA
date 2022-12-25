import subprocess
import json

def validate_file():
  try:
    with open("IceCube/IceCube_Implmnt/sbt/outputs/bitmap/GoBoard_bitmap.bin") as f:
      pass
  except FileNotFoundError:
    raise Exception("Could not find GoBoard module in IceCube output.")

def load_config():
  with open("PyDiamond.conf.json") as f:
    return json.load(f)

def write_config(conf):
  with open("PyDiamond.conf.json", "w+") as f:
    json.dump(conf, f, indent=4)

def run_prog(conf):
  print("Running Diamond Programmer")
  out = subprocess.run("pgrcmd -infile diamond_prog.xcf -portaddress FTUSB-" + str(conf["port"]), text=True, capture_output=True).stdout
  print(out)
  return out 

def main():
  validate_file()
  conf = load_config()

  out = run_prog(conf)

  if "Failed" in out.split()[-1]:
    yn = input("Failure detected, switch ports and try again? y/n ")
    if yn == "y":
      conf["port"] = int(not int(conf["port"]))
      run_prog(conf)
      write_config(conf)

if __name__ == '__main__':
  main()
